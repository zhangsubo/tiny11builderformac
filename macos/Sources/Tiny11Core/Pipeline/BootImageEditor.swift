import Foundation

public enum BootImageEditor {
    /// 修改暂存区 `sources/boot.wim`（注入 Setup\LabConfig 硬件绕过策略及 Core 所需的经典安装器启动配置）
    public static func customizeBootWimIfNeeded(
        bootWimPath: String,
        workTempDir: String,
        recipe: BuildRecipe,
        wimClient: WimClient,
        log: @Sendable (String) -> Void
    ) async throws -> Bool {
        let bypassHardware = recipe.selectedOptions.contains("hardware-bypass")
        let requiresLegacySetup = recipe.effectiveCore
        guard bypassHardware || requiresLegacySetup else {
            return false
        }

        let bootImages = try await wimClient.getImages(wimFile: bootWimPath)
        let setupImage = bootImages.first(where: { $0.name.localizedCaseInsensitiveContains("Setup") })
            ?? bootImages.first(where: { $0.index == 2 })
            ?? bootImages.first
        guard let targetSetup = setupImage else {
            throw Tiny11Error.invalidMedia("无法在 boot.wim 中找到有效的 Windows Setup 引导卷。")
        }

        let fm = FileManager.default
        let bootScratch = URL(fileURLWithPath: workTempDir).appendingPathComponent("boot-edit", isDirectory: true)
        if fm.fileExists(atPath: bootScratch.path) {
            try fm.removeItem(at: bootScratch)
        }
        try fm.createDirectory(at: bootScratch, withIntermediateDirectories: true)

        let bootPaths = try await wimClient.listPaths(wimFile: bootWimPath, index: targetSetup.index)
        var lowerMap: [String: String] = [:]
        for p in bootPaths { lowerMap[p.lowercased()] = p }

        var commands: [WimUpdateCommand] = []

        if bypassHardware {
            guard let sysWimPath = lowerMap["/windows/system32/config/system"] else {
                throw Tiny11Error.invalidMedia("boot.wim 缺少 SYSTEM 注册表文件。")
            }
            let hiveDir = bootScratch.appendingPathComponent("hive", isDirectory: true)
            try await wimClient.extract(
                wimFile: bootWimPath,
                index: targetSetup.index,
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
                throw Tiny11Error.invalidMedia("Core 模式需要经典安装器 sources\\setup.exe，但当前镜像的 boot.wim 中未包含该文件。")
            }

            let winpeshlContent = "[LaunchApps]\r\n%SYSTEMROOT%\\System32\\wpeinit.exe\r\n%SYSTEMDRIVE%\\\(legacyExeRel)\r\n"
            let localWinpeshl = bootScratch.appendingPathComponent("winpeshl.ini")
            guard let asciiData = winpeshlContent.data(using: .ascii) else {
                throw Tiny11Error.validationFailed("无法编码 winpeshl.ini。")
            }
            try asciiData.write(to: localWinpeshl)
            let targetWinpeshl = lowerMap["/windows/system32/winpeshl.ini"] ?? "/Windows/System32/winpeshl.ini"
            commands.append(.add(localPath: localWinpeshl.path, wimPath: targetWinpeshl))
            log("Core: 已在 boot.wim 启用经典安装器 (%SYSTEMDRIVE%\\\(legacyExeRel))")
        }

        try await wimClient.update(
            wimFile: bootWimPath,
            index: targetSetup.index,
            commands: commands,
            checkIntegrity: true,
            onOutput: nil
        )
        return requiresLegacySetup
    }
}
