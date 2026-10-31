import Foundation

public final class MacBuildEngine: Sendable {
    private let toolsOverride: ToolLocations?
    private let runner: ProcessRunning

    public init(tools: ToolLocations? = nil, runner: ProcessRunning = AsyncProcessRunner()) {
        self.toolsOverride = tools
        self.runner = runner
    }

    private func resolveTools() throws -> ToolLocations {
        if let toolsOverride { return toolsOverride }
        return try BundledToolLocator.locate()
    }

    /// 检查本地 ISO 或解压目录，返回架构、构建版本、所有内置 SKU 及推荐默认索引
    public func inspectMedia(sourcePath: String) async throws -> MediaInspection {
        let tools = try resolveTools()
        let mediaReader = IsoMediaReader(hdiutilPath: tools.hdiutil, runner: runner)
        let wimClient = WimClient(executable: tools.wimlibImagex, runner: runner)

        let opened = try await mediaReader.open(sourcePath: sourcePath)
        do {
            let fm = FileManager.default
            var isDir: ObjCBool = false
            _ = fm.fileExists(atPath: sourcePath, isDirectory: &isDir)

            guard let bootWim = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "boot.wim"]) else {
                throw Tiny11Error.invalidMedia("源介质不是完整的 Windows 安装镜像：缺少 sources/boot.wim。")
            }

            let installMedia = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.wim"])
                ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.esd"])
            guard let install = installMedia else {
                throw Tiny11Error.invalidMedia("未找到 sources/install.wim 或 install.esd（不支持拆分版 install.swm）。")
            }

            let efiBoot = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys.bin"])
                ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys_noprompt.bin"])
            guard let efi = efiBoot else {
                throw Tiny11Error.invalidMedia("源介质缺少 UEFI 引导扇区文件 (efi/microsoft/boot/efisys.bin)。")
            }

            let biosBoot = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["boot", "etfsboot.com"])
            let sxsDir = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "sxs"])

            let installAttrs = try fm.attributesOfItem(atPath: install.fullPath)
            let installBytes = (installAttrs[.size] as? NSNumber)?.int64Value ?? 0

            let images = try await wimClient.getImages(wimFile: install.fullPath)
            let recommended = Self.selectRecommendedIndex(from: images)

            await mediaReader.close(opened)
            return MediaInspection(
                sourcePath: URL(fileURLWithPath: sourcePath).standardizedFileURL.path,
                isDirectory: isDir.boolValue,
                installFileRelativePath: install.relativePath,
                installFileBytes: installBytes,
                bootWimRelativePath: bootWim.relativePath,
                efiBootRelativePath: efi.relativePath,
                biosBootRelativePath: biosBoot?.relativePath,
                hasNetFx3Payload: sxsDir != nil,
                images: images,
                recommendedIndex: recommended
            )
        } catch {
            await mediaReader.close(opened)
            throw error
        }
    }

    public static func selectRecommendedIndex(from images: [WindowsImage]) -> Int {
        if let pro = images.first(where: {
            $0.editionId.caseInsensitiveCompare("Professional") == .orderedSame ||
            $0.name.caseInsensitiveCompare("Windows 11 Pro") == .orderedSame ||
            $0.name.contains("专业版")
        }) {
            return pro.index
        }
        return images.first?.index ?? 1
    }

    /// 执行全流程纯原生无虚拟机镜像构建
    public func build(
        recipe: BuildRecipe,
        onProgress: @escaping @Sendable (BuildProgressEvent) -> Void,
        onLog: @escaping @Sendable (String) -> Void
    ) async throws -> BuildResult {
        let startTime = Date()
        try recipe.validate()
        let tools = try resolveTools()

        let fm = FileManager.default
        let workspaceRoot = URL(fileURLWithPath: recipe.workspacePath).standardizedFileURL
        try fm.createDirectory(at: workspaceRoot, withIntermediateDirectories: true)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        let jobId = "\(formatter.string(from: startTime))-\(UUID().uuidString.prefix(8).lowercased())"
        let jobDir = workspaceRoot.appendingPathComponent("tiny11-\(jobId)", isDirectory: true)
        try fm.createDirectory(at: jobDir, withIntermediateDirectories: true)

        let logFileURL = jobDir.appendingPathComponent("build.log")
        let logger = JobFileLogger(fileURL: logFileURL, forward: onLog)
        logger.log("Tiny11 Builder for Mac · 任务启动: \(jobDir.path)")
        logger.log("工具链模式: \(tools.bundledMode ? "App 内嵌独立工具" : "开发环境工具") | wimlib=\(tools.wimlibImagex) | mkisofs=\(tools.mkisofs)")

        // 保存输入配方快照
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(recipe).write(to: jobDir.appendingPathComponent("recipe.json"))

        // 预先声明八大阶段至待执行状态
        for phase in BuildPhaseId.allCases {
            onProgress(BuildProgressEvent(
                phase: phase,
                operationId: "stage:\(phase.rawValue)",
                message: phase.title,
                state: .pending
            ))
        }

        let mediaReader = IsoMediaReader(hdiutilPath: tools.hdiutil, runner: runner)
        let wimClient = WimClient(executable: tools.wimlibImagex, runner: runner)
        let isoCreator = IsoCreator(mkisofsPath: tools.mkisofs, runner: runner)

        var currentPhase: BuildPhaseId = .prepareMedia
        func beginPhase(_ phase: BuildPhaseId, detail: String) throws {
            try Task.checkCancellation()
            currentPhase = phase
            logger.log("=== [\(phase.title)] \(detail) ===")
            onProgress(BuildProgressEvent(
                phase: phase,
                operationId: "stage:\(phase.rawValue)",
                message: detail,
                state: .running,
                percent: 0
            ))
        }

        func finishPhase(_ phase: BuildPhaseId, detail: String) {
            onProgress(BuildProgressEvent(
                phase: phase,
                operationId: "stage:\(phase.rawValue)",
                message: detail,
                state: .completed,
                percent: 100,
                detail: detail
            ))
        }

        var openedMedia: OpenedMedia?
        do {
            // 1. 挂载并检查源介质与可用磁盘空间
            try beginPhase(.prepareMedia, detail: "正在挂载源镜像并检查系统版本与磁盘剩余空间...")
            let opened = try await mediaReader.open(sourcePath: recipe.sourcePath)
            openedMedia = opened

            let sourceAttrs = try? fm.attributesOfItem(atPath: recipe.sourcePath)
            let sourceTotalBytes = (sourceAttrs?[.size] as? NSNumber)?.int64Value ?? 0

            guard let bootWimRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "boot.wim"]),
                  let installRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.wim"])
                    ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.esd"]),
                  let efiRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys.bin"])
                    ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys_noprompt.bin"]) else {
                throw Tiny11Error.invalidMedia("源介质缺少必需的引导或安装镜像文件 (boot.wim / install.wim / efisys.bin)。")
            }
            let biosRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["boot", "etfsboot.com"])

            let images = try await wimClient.getImages(wimFile: installRel.fullPath)
            guard let targetImage = images.first(where: { $0.index == recipe.imageIndex }) else {
                throw Tiny11Error.validationFailed("源镜像中不存在索引为 \(recipe.imageIndex) 的系统版本。")
            }
            try targetImage.validate()
            logger.log("目标版本: \(targetImage.summary)")

            if recipe.enableNetFx3 && IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "sxs"]) == nil {
                throw Tiny11Error.invalidMedia("已勾选启用 .NET Framework 3.5，但当前源镜像不包含 sources/sxs 离线安装包。")
            }

            try checkAvailableDiskSpace(at: workspaceRoot, requiredBytes: max(18 * 1024 * 1024 * 1024, targetImage.totalBytes + 8 * 1024 * 1024 * 1024))

            let stagingDir = jobDir.appendingPathComponent("media", isDirectory: true)
            let stagingResult = try MediaStager.copyMedia(
                from: opened.rootPath,
                to: stagingDir.path,
                omitNetFx3Payload: recipe.omitNetFx3Payload && !recipe.enableNetFx3,
                onLog: { logger.log($0) }
            )
            finishPhase(.prepareMedia, detail: "已复制 \(stagingResult.copiedFiles) 个安装支持文件")

            // 2. 导出单版本工作 WIM
            try beginPhase(.exportEdition, detail: "正在导出 \(targetImage.name) 至可读写工作镜像...")
            let workingWim = jobDir.appendingPathComponent("working.wim").path
            try await wimClient.export(
                sourceWim: installRel.fullPath,
                sourceIndex: targetImage.index,
                destinationFile: workingWim,
                compression: .fastWIM,
                checkIntegrity: true,
                onOutput: { line, pct in
                    logger.log(line)
                    if let pct {
                        onProgress(BuildProgressEvent(
                            phase: .exportEdition,
                            operationId: "stage:\(BuildPhaseId.exportEdition.rawValue)",
                            message: "正在导出单版本工作镜像 (\(Int(pct))%)",
                            state: .running,
                            percent: pct
                        ))
                    }
                }
            )
            // 源镜像文件提取完毕后即可提前卸载只读光盘挂载点
            await mediaReader.close(opened)
            openedMedia = nil
            finishPhase(.exportEdition, detail: "单版本导出完成 (索引已归一为 1)")

            // 3. 提取并离线修改注册表 Hive
            try beginPhase(.modifyRegistry, detail: "正在扫描镜像结构并注入离线注册表策略与防重装锁...")
            let allWimPaths = try await wimClient.listPaths(wimFile: workingWim, index: 1)
            var lowerPathMap: [String: String] = [:]
            for p in allWimPaths { lowerPathMap[p.lowercased()] = p }

            guard let wimSoftwarePath = lowerPathMap["/windows/system32/config/software"],
                  let wimSystemPath = lowerPathMap["/windows/system32/config/system"],
                  let wimDefaultUserPath = lowerPathMap["/users/default/ntuser.dat"] else {
                throw Tiny11Error.invalidMedia("工作镜像缺少核心注册表 Hive 文件 (SOFTWARE / SYSTEM / NTUSER.DAT)。")
            }

            let hiveDir = jobDir.appendingPathComponent("hives", isDirectory: true)
            try await wimClient.extract(
                wimFile: workingWim,
                index: 1,
                wimPaths: [wimSoftwarePath, wimSystemPath, wimDefaultUserPath],
                destinationDir: hiveDir.path,
                nullglob: false
            )

            let localSoftware = hiveDir.appendingPathComponent((wimSoftwarePath as NSString).lastPathComponent).path
            let localSystem = hiveDir.appendingPathComponent((wimSystemPath as NSString).lastPathComponent).path
            let localNtuser = hiveDir.appendingPathComponent((wimDefaultUserPath as NSString).lastPathComponent).path

            let hasRegistryPending = OfflineHiveEditor.hasPendingServicingMarkers(softwareHivePath: localSoftware)
            let prunePlan = try ImagePruner.buildPrunePlan(
                allWimPaths: allWimPaths,
                image: targetImage,
                recipe: recipe,
                hasRegistryPending: hasRegistryPending,
                log: { logger.log($0) }
            )

            let hiveSummary = try OfflineHiveEditor.applyInstallHives(
                softwareHivePath: localSoftware,
                systemHivePath: localSystem,
                defaultUserHivePath: localNtuser,
                recipe: recipe,
                discoveredPackageNames: prunePlan.discoveredAppPackageNames,
                removeEdgeUninstallEntry: prunePlan.edgeFilesIncluded,
                log: { logger.log($0) }
            )
            finishPhase(
                .modifyRegistry,
                detail: "写入策略 \(hiveSummary.policiesWritten) 项 · 锁定预装应用 \(hiveSummary.deprovisionedFamilies.count) 个"
            )

            // 4. 在 WIM 归档内执行原子裁剪与 Hive 回写
            try beginPhase(.pruneImage, detail: "正在执行流式组件裁剪与注册表提交 (共 \(prunePlan.deleteWimPaths.count) 项移除)...")
            var updateCommands: [WimUpdateCommand] = prunePlan.deleteWimPaths.map { .delete(wimPath: $0) }
            updateCommands.append(.add(localPath: localSoftware, wimPath: wimSoftwarePath))
            updateCommands.append(.add(localPath: localSystem, wimPath: wimSystemPath))
            updateCommands.append(.add(localPath: localNtuser, wimPath: wimDefaultUserPath))

            let specializeScript = UnattendGenerator.generateSpecializePowerShell(recipe: recipe)
            if let specializeScript {
                let localScript = jobDir.appendingPathComponent("Tiny11Specialize.ps1")
                try Data(specializeScript.utf8).write(to: localScript)
                updateCommands.append(.add(
                    localPath: localScript.path,
                    wimPath: "/Windows/Setup/Scripts/Tiny11Specialize.ps1"
                ))
                logger.log("已注入部署期可选功能与预装存根清理脚本: /Windows/Setup/Scripts/Tiny11Specialize.ps1")
            }

            try await wimClient.update(
                wimFile: workingWim,
                index: 1,
                commands: updateCommands,
                checkIntegrity: true,
                onOutput: { logger.log($0) }
            )
            finishPhase(.pruneImage, detail: "已移除 \(prunePlan.deleteWimPaths.count) 个目录/文件并提交离线注册表")

            // 5. 生成 autounattend.xml 并修改引导镜像 boot.wim
            try beginPhase(.configureBoot, detail: "正在生成无人值守应答配置并处理引导镜像 boot.wim...")
            let unattendXml = UnattendGenerator.generateXML(
                image: targetImage,
                recipe: recipe,
                includeSpecializeScript: specializeScript != nil
            )
            let stagedUnattendURL = stagingDir.appendingPathComponent("autounattend.xml")
            try Data(unattendXml.utf8).write(to: stagedUnattendURL)
            logger.log("已写入应答配置文件: autounattend.xml (架构: \(targetImage.architecture.unattendProcessorArchitecture))")

            let stagedBootWim = stagingDir.appendingPathComponent(bootWimRel.relativePath).path
            let legacyInstallerUsed = try await BootImageEditor.customizeBootWimIfNeeded(
                bootWimPath: stagedBootWim,
                workTempDir: jobDir.path,
                recipe: recipe,
                wimClient: wimClient,
                log: { logger.log($0) }
            )
            finishPhase(
                .configureBoot,
                detail: legacyInstallerUsed ? "已配置应答文件、硬件绕过与经典安装器" : "已配置应答文件与引导环境"
            )

            // 6. 最终多核压缩导出至 staging/sources/install.(esd|wim)
            let destInstallLeaf = recipe.compression.installFileName
            try beginPhase(.compressImage, detail: "正在使用 Apple Silicon 多核压缩生成 \(destInstallLeaf) (\(recipe.compression.title))...")
            let stagedSourcesDir = stagingDir.appendingPathComponent((bootWimRel.relativePath as NSString).deletingLastPathComponent)
            let finalInstallPath = stagedSourcesDir.appendingPathComponent(destInstallLeaf).path
            try await wimClient.export(
                sourceWim: workingWim,
                sourceIndex: 1,
                destinationFile: finalInstallPath,
                compression: recipe.compression,
                checkIntegrity: true,
                onOutput: { line, pct in
                    logger.log(line)
                    if let pct {
                        onProgress(BuildProgressEvent(
                            phase: .compressImage,
                            operationId: "stage:\(BuildPhaseId.compressImage.rawValue)",
                            message: "正在多核压缩 \(destInstallLeaf) (\(Int(pct))%)",
                            state: .running,
                            percent: pct
                        ))
                    }
                }
            )
            if !recipe.keepWorkingFiles {
                try? fm.removeItem(atPath: workingWim)
            }
            finishPhase(.compressImage, detail: "已完成 \(destInstallLeaf) 压缩校验")

            // 7. 封装可引导 UDF/UEFI ISO
            try beginPhase(.createISO, detail: "正在使用 mkisofs 构建 UEFI/UDF 可引导光盘镜像...")
            let tempIsoPath = jobDir.appendingPathComponent("output.iso").path
            let volLabel = recipe.effectiveCore ? "TINY11_CORE" : "TINY11_\(targetImage.architecture.rawValue.uppercased())"
            try await isoCreator.createBootableISO(
                stagingDirectory: stagingDir.path,
                outputISO: tempIsoPath,
                architecture: targetImage.architecture,
                efiBootRelativePath: efiRel.relativePath,
                biosBootRelativePath: biosRel?.relativePath,
                volumeLabel: volLabel,
                onOutput: { logger.log($0) }
            )
            finishPhase(.createISO, detail: "可引导光盘镜像合成完毕")

            // 8. 校验 ISO 结构、计算 SHA-256 并原子发布
            try beginPhase(.verifyOutput, detail: "正在校验 ISO 卷结构并计算 SHA-256 校验和...")
            try IsoValidator.validateISO(at: tempIsoPath)
            let (isoBytes, sha256) = try IsoValidator.sha256Hex(at: tempIsoPath) { pct in
                onProgress(BuildProgressEvent(
                    phase: .verifyOutput,
                    operationId: "stage:\(BuildPhaseId.verifyOutput.rawValue)",
                    message: "正在计算输出镜像 SHA-256 (\(pct)%)",
                    state: .running,
                    percent: Double(pct)
                ))
            }

            let outputURL = URL(fileURLWithPath: recipe.outputPath).standardizedFileURL
            try fm.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            if fm.fileExists(atPath: outputURL.path) {
                throw Tiny11Error.validationFailed("目标路径在构建期间出现了同名文件，已保留镜像副本于：\(tempIsoPath)")
            }
            try fm.moveItem(at: URL(fileURLWithPath: tempIsoPath), to: outputURL)

            let duration = Date().timeIntervalSince(startTime)
            let result = BuildResult(
                isoPath: outputURL.path,
                sha256: sha256,
                outputBytes: isoBytes,
                sourceBytes: sourceTotalBytes,
                durationSeconds: duration,
                reportPath: jobDir.appendingPathComponent("report.json").path,
                workDirectory: jobDir.path,
                removedEntriesCount: prunePlan.deleteWimPaths.count,
                deprovisionedAppsCount: hiveSummary.deprovisionedFamilies.count,
                appliedPoliciesCount: hiveSummary.policiesWritten,
                warnings: prunePlan.warnings
            )

            try encoder.encode(result).write(to: URL(fileURLWithPath: result.reportPath))
            if !recipe.keepWorkingFiles {
                for tempSub in ["media", "hives", "boot-edit"] {
                    try? fm.removeItem(at: jobDir.appendingPathComponent(tempSub))
                }
            }

            logger.log("构建成功! 输出镜像: \(outputURL.path)")
            logger.log("大小: \(ByteCountFormatter.string(fromByteCount: isoBytes, countStyle: .file)) | SHA-256: \(sha256)")
            logger.flush()
            finishPhase(.verifyOutput, detail: "校验通过并已发布 ISO")
            return result
        } catch {
            if let opened = openedMedia {
                await mediaReader.close(opened)
            }
            let isCancelled = error is CancellationError || (error as? Tiny11Error)?.isCancelledError == true
            logger.log(isCancelled ? "构建已由用户取消。" : "构建失败: \(error.localizedDescription)")
            logger.flush()
            onProgress(BuildProgressEvent(
                phase: currentPhase,
                operationId: "stage:\(currentPhase.rawValue)",
                message: isCancelled ? "已取消" : error.localizedDescription,
                state: isCancelled ? .cancelled : .failed,
                detail: error.localizedDescription
            ))
            if isCancelled {
                throw Tiny11Error.cancelled
            }
            throw error
        }
    }

    private func checkAvailableDiskSpace(at directory: URL, requiredBytes: Int64) throws {
        let values = try directory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeAvailableCapacityKey])
        let free = values.volumeAvailableCapacityForImportantUsage
            ?? Int64(values.volumeAvailableCapacity ?? 0)
        if free > 0 && free < requiredBytes {
            let needGiB = (requiredBytes + (1 << 30) - 1) >> 30
            let freeGiB = free >> 30
            throw Tiny11Error.validationFailed("工作目录所在磁盘剩余空间不足（当前可用约 \(freeGiB) GiB，建议至少预留 \(needGiB) GiB）。")
        }
    }
}

private extension Tiny11Error {
    var isCancelledError: Bool {
        if case .cancelled = self { return true }
        return false
    }
}

private final class JobFileLogger: @unchecked Sendable {
    private let lock = NSLock()
    private let fileHandle: FileHandle?
    private let forward: @Sendable (String) -> Void
    private let isoFormatter = ISO8601DateFormatter()

    init(fileURL: URL, forward: @escaping @Sendable (String) -> Void) {
        self.forward = forward
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        self.fileHandle = try? FileHandle(forWritingTo: fileURL)
    }

    deinit {
        try? fileHandle?.close()
    }

    func log(_ message: String) {
        let timestamp = isoFormatter.string(from: Date())
        let line = "[\(timestamp)] \(message)\n"
        lock.lock()
        if let data = line.data(using: .utf8) {
            try? fileHandle?.write(contentsOf: data)
        }
        lock.unlock()
        forward(message)
    }

    func flush() {
        lock.lock()
        try? fileHandle?.synchronize()
        lock.unlock()
    }
}
