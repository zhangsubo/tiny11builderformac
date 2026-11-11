import Foundation

public struct BootEditOutcome: Sendable, Equatable {
    public let legacyInstallerUsed: Bool
    public let bytesBefore: Int64?
    public let bytesAfter: Int64?
}

public enum BootImageEditor {
    /// 修改暂存区 `sources/boot.wim`（可选单索引高压缩重建、注入 Setup\LabConfig 硬件绕过策略及经典安装器启动配置）
    public static func customizeBootWimIfNeeded(
        bootWimPath: String,
        workTempDir: String,
        recipe: BuildRecipe,
        wimClient: WimClient,
        log: @Sendable (String) -> Void
    ) async throws -> BootEditOutcome {
        let bypassHardware = recipe.selectedOptions.contains("hardware-bypass")
        let requiresLegacySetup = recipe.requiresLegacySetup
        let shrinkBoot = recipe.shrinkBootImage
        guard shrinkBoot || bypassHardware || requiresLegacySetup else {
            return BootEditOutcome(legacyInstallerUsed: false, bytesBefore: nil, bytesAfter: nil)
        }

        let bootImages = try await wimClient.getImages(wimFile: bootWimPath)
        let setupImage = bootImages.first(where: { $0.name.localizedCaseInsensitiveContains("Setup") })
            ?? bootImages.first(where: { $0.index == 2 })
            ?? bootImages.first
        guard let targetSetup = setupImage else {
            throw Tiny11Error.invalidMedia(L10n.bootWimSetupNotFound())
        }

        let fm = FileManager.default
        let beforeAttrs = try? fm.attributesOfItem(atPath: bootWimPath)
        let bytesBefore = (beforeAttrs?[.size] as? NSNumber)?.int64Value

        let bootScratch = URL(fileURLWithPath: workTempDir).appendingPathComponent("boot-edit", isDirectory: true)
        if fm.fileExists(atPath: bootScratch.path) {
            try fm.removeItem(at: bootScratch)
        }
        try fm.createDirectory(at: bootScratch, withIntermediateDirectories: true)

        var activeIndex = targetSetup.index
        if shrinkBoot {
            let shrunkPath = bootScratch.appendingPathComponent("boot-shrunk.wim").path
            try await wimClient.export(
                sourceWim: bootWimPath,
                sourceIndex: targetSetup.index,
                destinationFile: shrunkPath,
                compression: .maximumWIM,
                checkIntegrity: true,
                bootable: true
            )
            try fm.removeItem(atPath: bootWimPath)
            try fm.moveItem(atPath: shrunkPath, toPath: bootWimPath)
            activeIndex = 1
        }

        if bypassHardware || requiresLegacySetup {
            let bootPaths = try await wimClient.listPaths(wimFile: bootWimPath, index: activeIndex)
            var lowerMap: [String: String] = [:]
            for p in bootPaths { lowerMap[p.lowercased()] = p }

            var commands: [WimUpdateCommand] = []

            if bypassHardware {
                guard let sysWimPath = lowerMap["/windows/system32/config/system"] else {
                    throw Tiny11Error.invalidMedia(L10n.bootWimMissingSystemHive())
                }
                let hiveDir = bootScratch.appendingPathComponent("hive", isDirectory: true)
                try await wimClient.extract(
                    wimFile: bootWimPath,
                    index: activeIndex,
                    wimPaths: [sysWimPath],
                    destinationDir: hiveDir.path,
                    nullglob: false
                )
                let localSystemHive = hiveDir.appendingPathComponent((sysWimPath as NSString).lastPathComponent).path
                try OfflineHiveEditor.applyBootSetupBypass(systemHivePath: localSystemHive, log: log)
                commands.append(.add(localPath: localSystemHive, wimPath: sysWimPath))
            }

            if requiresLegacySetup {
                let legacyExeRel: String
                if lowerMap["/sources/setup_old.exe"] != nil {
                    legacyExeRel = #"sources\setup_old.exe"#
                } else if lowerMap["/sources/setup.exe"] != nil {
                    legacyExeRel = #"sources\setup.exe"#
                } else {
                    throw Tiny11Error.invalidMedia(L10n.bootWimMissingLegacySetup())
                }

                let winpeshlContent = "[LaunchApps]\r\n%SYSTEMROOT%\\System32\\wpeinit.exe\r\n%SYSTEMDRIVE%\\\(legacyExeRel)\r\n"
                let localWinpeshl = bootScratch.appendingPathComponent("winpeshl.ini")
                guard let asciiData = winpeshlContent.data(using: .ascii) else {
                    throw Tiny11Error.validationFailed(L10n.winpeshlEncodeFailed())
                }
                try asciiData.write(to: localWinpeshl)
                let targetWinpeshl = lowerMap["/windows/system32/winpeshl.ini"] ?? "/Windows/System32/winpeshl.ini"
                commands.append(.add(localPath: localWinpeshl.path, wimPath: targetWinpeshl))
                log(L10n.logCoreLegacySetupEnabled(legacyExeRel))
            }

            try await wimClient.update(
                wimFile: bootWimPath,
                index: activeIndex,
                commands: commands,
                checkIntegrity: true,
                onOutput: nil
            )
        }

        let afterAttrs = try? fm.attributesOfItem(atPath: bootWimPath)
        let bytesAfter = (afterAttrs?[.size] as? NSNumber)?.int64Value
        if shrinkBoot, let before = bytesBefore, let after = bytesAfter {
            log(L10n.logBootWimShrunk(before: L10n.formatBytes(before), after: L10n.formatBytes(after)))
        }
        return BootEditOutcome(legacyInstallerUsed: requiresLegacySetup, bytesBefore: bytesBefore, bytesAfter: bytesAfter)
    }
}
