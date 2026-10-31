import Foundation

public struct PrunePlan: Sendable {
    public let discoveredAppPackageNames: [String]
    public let deleteWimPaths: [String]
    public let hasPendingMarkers: Bool
    public let edgeFilesIncluded: Bool
    public let warnings: [String]
}

public enum ImagePruner {
    private static let coreMetadataDirectories: Set<String> = [
        "catalogs", "filemaps", "fusion", "installtemp", "manifests", "settingsmanifests", "temp"
    ]

    private static let coreRuntimeRegex: NSRegularExpression = {
        // 与原版 ImageOperations.cs PreserveCoreDirectory 完全一致的运行库保留模式
        let pattern = #"(?:common-controls|c\.\.-controls|gdiplus|isolationautomation|utomation\.proxystub|microsoft\.vc\d+\.crt|servicing|s\.\.(?:ngstack|stack))"#
        return try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
    }()

    public static func preserveCoreWinSxSDirectory(_ name: String) -> Bool {
        if coreMetadataDirectories.contains(name.lowercased()) {
            return true
        }
        let range = NSRange(name.startIndex..<name.endIndex, in: name)
        return coreRuntimeRegex.firstMatch(in: name, options: [], range: range) != nil
    }

    /// 扫描 WIM 镜像路径树并规划所有需要离线删除的路径（不挂载宿主机，保留原始大小写）
    public static func buildPrunePlan(
        allWimPaths: [String],
        image: WindowsImage,
        recipe: BuildRecipe,
        hasRegistryPending: Bool,
        log: (String) -> Void
    ) throws -> PrunePlan {
        let selectedSet = Set(recipe.selectedOptions)
        var warnings: [String] = []
        var deleteTargets: [String] = []
        var seenLower = Set<String>()

        func scheduleDelete(_ path: String) {
            let normalized = path.hasPrefix("/") ? path : "/" + path
            let key = normalized.lowercased()
            if seenLower.insert(key).inserted {
                deleteTargets.append(normalized)
            }
        }

        // 建立不区分大小写的顶层/特定目录索引
        var lowerLookup: [String: String] = [:]
        for p in allWimPaths {
            lowerLookup[p.lowercased()] = p
        }

        let hasPendingXml = lowerLookup["/windows/winsxs/pending.xml"] != nil ||
            lowerLookup["/windows/winsxs/reboot.xml"] != nil
        let hasPending = hasPendingXml || hasRegistryPending

        if hasPending && recipe.effectiveCore {
            throw Tiny11Error.validationFailed(
                "检测到该镜像包含尚未完成的挂起更新 (pending.xml 或 CBS 挂起状态)。Tiny11 Core 会删除首次开机完成更新所需的组件，已中止裁剪；请改用 Mac 虚拟机优化版或标准版构建。"
            )
        }

        // 1. 扫描预装 AppX 目录 (/Program Files/WindowsApps/* 与 /Windows/InfusedApps/Packages/*)
        var discoveredPackages: [String] = []
        for parentPrefix in ["/program files/windowsapps/", "/windows/infusedapps/packages/"] {
            for p in allWimPaths {
                let lp = p.lowercased()
                guard lp.hasPrefix(parentPrefix) else { continue }
                let remainder = p.dropFirst(parentPrefix.count)
                // 只取直接一级子目录名（不含后续 `/`）
                guard !remainder.isEmpty, !remainder.contains("/") else { continue }
                let folderName = String(remainder)
                if CleanupCatalog.matchesAppPackageName(folderName, selectedOptionIds: selectedSet) != nil {
                    discoveredPackages.append(folderName)
                    scheduleDelete(p)
                    log("计划移除预装应用载荷: \(p)")
                }
            }
        }

        // 2. 删除 OneDrive 安装程序
        if selectedSet.contains("onedrive-files") {
            for candidate in ["/windows/system32/onedrivesetup.exe", "/windows/syswow64/onedrivesetup.exe"] {
                if let exact = lowerLookup[candidate] {
                    scheduleDelete(exact)
                    log("计划移除 OneDrive 安装器: \(exact)")
                }
            }
        }

        // 3. 删除 Edge 与 WebView2（若存在挂起更新则安全跳过并给出警告）
        var edgeRemoved = false
        if selectedSet.contains("edge-files") {
            if hasPending {
                let warn = "镜像存在挂起的组件服务操作，为避免首次开机失败，已保留 Edge/WebView2 文件。"
                warnings.append(warn)
                log("警告: \(warn)")
            } else {
                for base in ["/program files/microsoft/", "/program files (x86)/microsoft/"] {
                    for edgeDir in ["edge", "edgecore", "edgeupdate", "edgewebview"] {
                        if let exact = lowerLookup[base + edgeDir] {
                            scheduleDelete(exact)
                            edgeRemoved = true
                            log("计划移除 Edge 目录: \(exact)")
                        }
                    }
                }
                if let sysEdge = lowerLookup["/windows/system32/microsoft-edge-webview"] {
                    scheduleDelete(sysEdge)
                    edgeRemoved = true
                }
                let winSxsPrefix = "/windows/winsxs/"
                for p in allWimPaths {
                    let lp = p.lowercased()
                    guard lp.hasPrefix(winSxsPrefix) else { continue }
                    let child = lp.dropFirst(winSxsPrefix.count)
                    if !child.contains("/") && child.contains("microsoft-edge-webview") {
                        scheduleDelete(p)
                        edgeRemoved = true
                    }
                }
            }
        }

        // 4. 清理离线缓存、临时文件与崩溃转储（对应 OfflineDataCleaner.cs）
        if recipe.removeRedundantData {
            let safeCacheRoots = [
                "/windows/softwaredistribution/download/",
                "/windows/temp/",
                "/users/default/appdata/local/temp/",
                "/programdata/microsoft/windows/wer/reportarchive/",
                "/programdata/microsoft/windows/wer/reportqueue/"
            ]
            for rootPrefix in safeCacheRoots {
                let isServicingSensitive = rootPrefix.contains("softwaredistribution") || rootPrefix.contains("temp/")
                if hasPending && isServicingSensitive {
                    continue
                }
                for p in allWimPaths {
                    let lp = p.lowercased()
                    guard lp.hasPrefix(rootPrefix) else { continue }
                    let rest = lp.dropFirst(rootPrefix.count)
                    if !rest.isEmpty && !rest.contains("/") {
                        scheduleDelete(p)
                    }
                }
            }
            if let memoryDmp = lowerLookup["/windows/memory.dmp"] {
                scheduleDelete(memoryDmp)
            }
        }

        // 5. Tiny11 Core 深度组件库 (WinSxS) 与恢复环境 (WinRE) 裁剪
        if recipe.effectiveCore {
            let winSxsPrefix = "/windows/winsxs/"
            var winSxsChildren: [(exactPath: String, leafName: String)] = []
            for p in allWimPaths {
                let lp = p.lowercased()
                guard lp.hasPrefix(winSxsPrefix) else { continue }
                let rem = p.dropFirst(winSxsPrefix.count)
                if !rem.isEmpty && !rem.contains("/") {
                    winSxsChildren.append((p, String(rem)))
                }
            }

            let nativeArchPrefix = image.architecture == .x64 ? "amd64_" : "arm64_"
            for requiredFamily in ["common-controls", "gdiplus", "servicing"] {
                let found = winSxsChildren.contains { item in
                    let lower = item.leafName.lowercased()
                    return lower.hasPrefix(nativeArchPrefix) && lower.contains(requiredFamily)
                }
                if !found {
                    throw Tiny11Error.unsupportedImage(
                        "Core 模式无法在该构建版本中识别必需的 \(image.architecture.rawValue) \(requiredFamily) 运行库布局，已安全停止裁剪。"
                    )
                }
            }

            var prunedWinSxsCount = 0
            for item in winSxsChildren where !preserveCoreWinSxSDirectory(item.leafName) {
                scheduleDelete(item.exactPath)
                prunedWinSxsCount += 1
            }
            log("Core: 计划裁剪 WinSxS 非核心组件目录 \(prunedWinSxsCount) 个")

            if let winre = lowerLookup["/windows/system32/recovery/winre.wim"] {
                scheduleDelete(winre)
                log("Core: 计划移除恢复镜像 \(winre)")
            }
        }

        return PrunePlan(
            discoveredAppPackageNames: discoveredPackages,
            deleteWimPaths: deleteTargets,
            hasPendingMarkers: hasPending,
            edgeFilesIncluded: edgeRemoved,
            warnings: warnings
        )
    }
}
