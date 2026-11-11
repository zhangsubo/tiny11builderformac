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
                throw Tiny11Error.invalidMedia(L10n.mediaMissingBootWim())
            }

            let installMedia = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.wim"])
                ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.esd"])
            guard let install = installMedia else {
                throw Tiny11Error.invalidMedia(L10n.mediaMissingInstallWim())
            }

            let efiBoot = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys.bin"])
                ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys_noprompt.bin"])
            guard let efi = efiBoot else {
                throw Tiny11Error.invalidMedia(L10n.mediaMissingEfiBoot())
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
        // WIM XML <EDITIONID> is language-neutral ("Professional"); also match localized Pro display names
        let proKeywords = ["Windows 11 Pro", "专业版", "Professionnel", "Профессиональная"]
        if let pro = images.first(where: { img in
            img.editionId.caseInsensitiveCompare("Professional") == .orderedSame ||
            proKeywords.contains(where: { img.name.localizedCaseInsensitiveContains($0) })
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
        logger.log(L10n.logJobStarted(jobDir.path))
        logger.log(L10n.logToolchainMode(bundled: tools.bundledMode, wimlib: tools.wimlibImagex, mkisofs: tools.mkisofs))

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
            try beginPhase(.prepareMedia, detail: L10n.phasePrepareRunning())
            let opened = try await mediaReader.open(sourcePath: recipe.sourcePath)
            openedMedia = opened

            let sourceAttrs = try? fm.attributesOfItem(atPath: recipe.sourcePath)
            let sourceTotalBytes = (sourceAttrs?[.size] as? NSNumber)?.int64Value ?? 0

            guard let bootWimRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "boot.wim"]),
                  let installRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.wim"])
                    ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "install.esd"]),
                  let efiRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys.bin"])
                    ?? IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["efi", "microsoft", "boot", "efisys_noprompt.bin"]) else {
                throw Tiny11Error.invalidMedia(L10n.mediaMissingRequiredFiles())
            }
            let biosRel = IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["boot", "etfsboot.com"])

            let images = try await wimClient.getImages(wimFile: installRel.fullPath)
            guard let targetImage = images.first(where: { $0.index == recipe.imageIndex }) else {
                throw Tiny11Error.validationFailed(L10n.imageIndexNotFound(recipe.imageIndex))
            }
            try targetImage.validate()
            logger.log(L10n.logTargetEdition(targetImage.summary))

            if recipe.enableNetFx3 && IsoMediaReader.resolveCaseInsensitive(root: opened.rootPath, components: ["sources", "sxs"]) == nil {
                throw Tiny11Error.invalidMedia(L10n.netFx3PayloadMissingError())
            }

            try checkAvailableDiskSpace(at: workspaceRoot, requiredBytes: max(18 * 1024 * 1024 * 1024, targetImage.totalBytes + 8 * 1024 * 1024 * 1024))

            let stagingDir = jobDir.appendingPathComponent("media", isDirectory: true)
            let stagingResult = try MediaStager.copyMedia(
                from: opened.rootPath,
                to: stagingDir.path,
                omitNetFx3Payload: recipe.omitNetFx3Payload && !recipe.enableNetFx3,
                onLog: { logger.log($0) }
            )
            finishPhase(.prepareMedia, detail: L10n.phasePrepareDone(copiedFiles: stagingResult.copiedFiles))

            // 2. 导出单版本工作 WIM
            try beginPhase(.exportEdition, detail: L10n.phaseExportRunning(imageName: targetImage.name))
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
                            message: L10n.phaseExportPercent(Int(pct)),
                            state: .running,
                            percent: pct
                        ))
                    }
                }
            )
            // 源镜像文件提取完毕后即可提前卸载只读光盘挂载点
            await mediaReader.close(opened)
            openedMedia = nil
            finishPhase(.exportEdition, detail: L10n.phaseExportDone())

            // 3. 提取并离线修改注册表 Hive
            try beginPhase(.modifyRegistry, detail: L10n.phaseRegistryRunning())
            let allWimPaths = try await wimClient.listPaths(wimFile: workingWim, index: 1)
            var lowerPathMap: [String: String] = [:]
            for p in allWimPaths { lowerPathMap[p.lowercased()] = p }

            guard let wimSoftwarePath = lowerPathMap["/windows/system32/config/software"],
                  let wimSystemPath = lowerPathMap["/windows/system32/config/system"],
                  let wimDefaultUserPath = lowerPathMap["/users/default/ntuser.dat"] else {
                throw Tiny11Error.invalidMedia(L10n.missingCoreHivesError())
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
                detail: L10n.phaseRegistryDone(
                    policies: hiveSummary.policiesWritten,
                    lockedApps: hiveSummary.deprovisionedFamilies.count
                )
            )

            // 4. 在 WIM 归档内执行原子裁剪与 Hive 回写
            try beginPhase(.pruneImage, detail: L10n.phasePruneRunning(count: prunePlan.deleteWimPaths.count))
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
                logger.log(L10n.logSpecializeScriptInjected())
            }

            try await wimClient.update(
                wimFile: workingWim,
                index: 1,
                commands: updateCommands,
                checkIntegrity: true,
                onOutput: { logger.log($0) }
            )
            finishPhase(.pruneImage, detail: L10n.phasePruneDone(count: prunePlan.deleteWimPaths.count))

            // 5. 生成 autounattend.xml 并修改引导镜像 boot.wim
            try beginPhase(.configureBoot, detail: L10n.phaseBootRunning())
            let unattendXml = UnattendGenerator.generateXML(
                image: targetImage,
                recipe: recipe,
                includeSpecializeScript: specializeScript != nil
            )
            let stagedUnattendURL = stagingDir.appendingPathComponent("autounattend.xml")
            try Data(unattendXml.utf8).write(to: stagedUnattendURL)
            logger.log(L10n.logUnattendWritten(targetImage.architecture.unattendProcessorArchitecture))

            let stagedBootWim = stagingDir.appendingPathComponent(bootWimRel.relativePath).path
            let legacyInstallerUsed = try await BootImageEditor.customizeBootWimIfNeeded(
                bootWimPath: stagedBootWim,
                workTempDir: jobDir.path,
                recipe: recipe,
                wimClient: wimClient,
                log: { logger.log($0) }
            )
            finishPhase(.configureBoot, detail: L10n.phaseBootDone(legacyInstallerUsed: legacyInstallerUsed))

            // 6. 最终多核压缩导出至 staging/sources/install.(esd|wim)
            let destInstallLeaf = recipe.compression.installFileName
            try beginPhase(.compressImage, detail: L10n.phaseCompressRunning(leaf: destInstallLeaf, modeTitle: recipe.compression.title))
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
                            message: L10n.phaseCompressPercent(leaf: destInstallLeaf, pct: Int(pct)),
                            state: .running,
                            percent: pct
                        ))
                    }
                }
            )
            if !recipe.keepWorkingFiles {
                try? fm.removeItem(atPath: workingWim)
            }
            finishPhase(.compressImage, detail: L10n.phaseCompressDone(leaf: destInstallLeaf))

            // 7. 封装可引导 UDF/UEFI ISO
            try beginPhase(.createISO, detail: L10n.phaseIsoRunning())
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
            finishPhase(.createISO, detail: L10n.phaseIsoDone())

            // 8. 校验 ISO 结构、计算 SHA-256 并原子发布
            try beginPhase(.verifyOutput, detail: L10n.phaseVerifyRunning())
            try IsoValidator.validateISO(at: tempIsoPath)
            let (isoBytes, sha256) = try IsoValidator.sha256Hex(at: tempIsoPath) { pct in
                onProgress(BuildProgressEvent(
                    phase: .verifyOutput,
                    operationId: "stage:\(BuildPhaseId.verifyOutput.rawValue)",
                    message: L10n.phaseVerifyPercent(pct),
                    state: .running,
                    percent: Double(pct)
                ))
            }

            let outputURL = URL(fileURLWithPath: recipe.outputPath).standardizedFileURL
            try fm.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            if fm.fileExists(atPath: outputURL.path) {
                throw Tiny11Error.validationFailed(L10n.outputAppearedDuringBuildError(tempIsoPath))
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

            logger.log(L10n.logBuildSuccess(outputURL.path))
            logger.log(L10n.logBuildSizeAndSha(size: L10n.formatBytes(isoBytes), sha256: sha256))
            logger.flush()
            finishPhase(.verifyOutput, detail: L10n.phaseVerifyDone())
            return result
        } catch {
            if let opened = openedMedia {
                await mediaReader.close(opened)
            }
            let isCancelled = error is CancellationError || (error as? Tiny11Error)?.isCancelledError == true
            logger.log(isCancelled ? L10n.logBuildCancelled() : L10n.logBuildFailed(error.localizedDescription))
            logger.flush()
            onProgress(BuildProgressEvent(
                phase: currentPhase,
                operationId: "stage:\(currentPhase.rawValue)",
                message: isCancelled ? L10n.phaseCancelledShort() : error.localizedDescription,
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
            throw Tiny11Error.validationFailed(L10n.insufficientDiskSpaceError(freeGiB: freeGiB, needGiB: needGiB))
        }
    }
}

public extension Tiny11Error {
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
