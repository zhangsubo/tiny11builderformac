import Foundation
import Testing
@testable import Tiny11Core

@Suite("Tiny11Core Native Engine Tests")
struct Tiny11CoreTests {

    @Test("WIM UTF-16LE XML 解析准确识别 ARM64 与 x64 系统版本及推荐专业版")
    func parseWimXmlHandlesUTF16LEAndArchitectures() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-16"?>
        <WIM>
            <IMAGE INDEX="1">
                <NAME>Windows 11 Home</NAME>
                <DESCRIPTION>Windows 11 Home</DESCRIPTION>
                <TOTALBYTES>16500000000</TOTALBYTES>
                <WINDOWS>
                    <ARCH>12</ARCH>
                    <EDITIONID>Core</EDITIONID>
                    <INSTALLATIONTYPE>Client</INSTALLATIONTYPE>
                    <VERSION><MAJOR>10</MAJOR><MINOR>0</MINOR><BUILD>26100</BUILD><SPBUILD>1742</SPBUILD></VERSION>
                    <LANGUAGES><LANGUAGE>zh-CN</LANGUAGE></LANGUAGES>
                </WINDOWS>
            </IMAGE>
            <IMAGE INDEX="2">
                <NAME>Windows 11 Pro</NAME>
                <DESCRIPTION>Windows 11 Pro</DESCRIPTION>
                <TOTALBYTES>16900000000</TOTALBYTES>
                <WINDOWS>
                    <ARCH>12</ARCH>
                    <EDITIONID>Professional</EDITIONID>
                    <INSTALLATIONTYPE>Client</INSTALLATIONTYPE>
                    <VERSION><MAJOR>10</MAJOR><MINOR>0</MINOR><BUILD>26100</BUILD><SPBUILD>1742</SPBUILD></VERSION>
                    <LANGUAGES><LANGUAGE>zh-CN</LANGUAGE></LANGUAGES>
                </WINDOWS>
            </IMAGE>
        </WIM>
        """
        var bomData = Data([0xFF, 0xFE])
        bomData.append(xml.data(using: .utf16LittleEndian)!)

        let images = try WimClient.parseWimXml(bomData)
        #expect(images.count == 2)
        #expect(images[0].architecture == .arm64)
        #expect(images[1].editionId == "Professional")
        #expect(images[1].build == 26100)
        #expect(images[1].servicePackBuild == 1742)
        #expect(images[1].isSupported == true)
        #expect(MacBuildEngine.selectRecommendedIndex(from: images) == 2)
    }

    @Test("Mac VM 预设与 PackageFamilyName 提取规则符合预期")
    func presetsAndPackageFamilyExtraction() {
        let macVmIds = Set(CleanupCatalog.optionIds(for: .macVM))
        #expect(macVmIds.contains("hardware-bypass"))
        #expect(macVmIds.contains("reserved-storage"))
        #expect(macVmIds.contains("device-encryption"))
        #expect(macVmIds.contains("onedrive-files"))
        // Mac VM 预设默认保留 Edge/WebView2 文件以确保虚拟机工具与现代安装器兼容
        #expect(!macVmIds.contains("edge-files"))

        let family = OfflineHiveEditor.extractPackageFamilyName(
            from: "Clipchamp.Clipchamp_3.0.10020.0_arm64__yxz26nhyzhsrt"
        )
        #expect(family == "Clipchamp.Clipchamp_yxz26nhyzhsrt")

        #expect(ImagePruner.preserveCoreWinSxSDirectory("arm64_microsoft.windows.common-controls_6595b64144ccf1df_6.0.26100.1_none"))
        #expect(ImagePruner.preserveCoreWinSxSDirectory("Manifests"))
        #expect(!ImagePruner.preserveCoreWinSxSDirectory("arm64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1_none"))
    }

    @Test("CHivex 离线注册表编辑器完整读写闭环测试")
    func offlineHiveEditorRoundtrip() throws {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("tiny11-hive-test-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let softPath = tempDir.appendingPathComponent("SOFTWARE").path
        let sysPath = tempDir.appendingPathComponent("SYSTEM").path
        let userPath = tempDir.appendingPathComponent("NTUSER.DAT").path

        try SyntheticRegfBuilder.writeMinimalHive(to: softPath)
        try SyntheticRegfBuilder.writeMinimalHive(to: sysPath)
        try SyntheticRegfBuilder.writeMinimalHive(to: userPath)

        // 预置 Select\Current=2、服务项与 Edge 卸载项
        do {
            let sys = try HiveSession(path: sysPath, writable: true)
            try sys.setValue(keyPath: "Select", name: "Current", data: .dword(2))
            try sys.setValue(keyPath: #"ControlSet002\Services\wuauserv"#, name: "Start", data: .dword(2))
            try sys.commit()
            sys.close()

            let soft = try HiveSession(path: softPath, writable: true)
            try soft.setValue(
                keyPath: #"Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge"#,
                name: "DisplayName",
                data: .string("Microsoft Edge")
            )
            try soft.setValue(
                keyPath: #"Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge"#,
                name: "Publisher",
                data: .string("Microsoft Corporation")
            )
            try soft.setValue(
                keyPath: #"Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Staged\Microsoft.BingNews_4.8.0.0_arm64__8wekyb3d8bbwe"#,
                name: "Path",
                data: .string("C:\\Program Files\\WindowsApps\\Microsoft.BingNews")
            )
            try soft.commit()
            soft.close()
        }

        var recipe = BuildRecipe(mode: .tiny11Core, coreFlavor: true, coreAcknowledged: true)
        recipe.selectedOptions = CleanupCatalog.optionIds(for: .tiny11Core)

        let summary = try OfflineHiveEditor.applyInstallHives(
            softwareHivePath: softPath,
            systemHivePath: sysPath,
            defaultUserHivePath: userPath,
            recipe: recipe,
            discoveredPackageNames: ["Clipchamp.Clipchamp_3.0.10020.0_arm64__yxz26nhyzhsrt"],
            removeEdgeUninstallEntry: true,
            log: { _ in }
        )

        #expect(summary.policiesWritten > 20)
        #expect(summary.deprovisionedFamilies.contains("Clipchamp.Clipchamp_yxz26nhyzhsrt"))
        #expect(summary.deprovisionedFamilies.contains("Microsoft.BingNews_8wekyb3d8bbwe"))
        #expect(summary.removedStagedEntries == 1)
        #expect(summary.edgeUninstallRemoved == true)
        #expect(summary.disabledServices.contains("wuauserv"))

        // 重新只读打开验证持久化结果
        let verifySoft = try HiveSession(path: softPath, writable: false)
        defer { verifySoft.close() }
        let oobeNode = try #require(try verifySoft.findNode(path: #"Microsoft\Windows\CurrentVersion\OOBE"#))
        #expect(try verifySoft.getDword(node: oobeNode, name: "BypassNRO") == 1)
        #expect(try verifySoft.findNode(path: #"Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Clipchamp.Clipchamp_yxz26nhyzhsrt"#) != nil)
        #expect(try verifySoft.findNode(path: #"Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge"#) == nil)

        let verifySys = try HiveSession(path: sysPath, writable: false)
        defer { verifySys.close() }
        let bitlockerNode = try #require(try verifySys.findNode(path: #"ControlSet002\Control\BitLocker"#))
        #expect(try verifySys.getDword(node: bitlockerNode, name: "PreventDeviceEncryption") == 1)
        let wuauservNode = try #require(try verifySys.findNode(path: #"ControlSet002\Services\wuauserv"#))
        #expect(try verifySys.getDword(node: wuauservNode, name: "Start") == 4)
    }

    @Test("合成 Windows 11 ARM64 ISO 全链路构建集成验证 (wimlib + CHivex + mkisofs + hdiutil)")
    func fullSyntheticIsoBuildEndToEnd() async throws {
        let tools = try BundledToolLocator.locate()
        let fm = FileManager.default
        let sandbox = fm.temporaryDirectory.appendingPathComponent("tiny11-e2e-\(UUID().uuidString)", isDirectory: true)
        try fm.createDirectory(at: sandbox, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: sandbox) }

        let runner = AsyncProcessRunner()
        let sourceMediaDir = sandbox.appendingPathComponent("source-media", isDirectory: true)
        let installRoot = sandbox.appendingPathComponent("install-tree", isDirectory: true)
        let bootRoot = sandbox.appendingPathComponent("boot-tree", isDirectory: true)

        // 1. 构造合成的 boot.wim 内容目录
        let bootConfigDir = bootRoot.appendingPathComponent("Windows/System32/config", isDirectory: true)
        let bootSourcesDir = bootRoot.appendingPathComponent("sources", isDirectory: true)
        try fm.createDirectory(at: bootConfigDir, withIntermediateDirectories: true)
        try fm.createDirectory(at: bootSourcesDir, withIntermediateDirectories: true)
        try SyntheticRegfBuilder.writeMinimalHive(to: bootConfigDir.appendingPathComponent("SYSTEM").path)
        try Data("mock-setup".utf8).write(to: bootSourcesDir.appendingPathComponent("setup.exe"))

        // 2. 构造合成的 install.wim 内容目录（含预装臃肿包、OneDrive、注册表 Hive）
        let instConfigDir = installRoot.appendingPathComponent("Windows/System32/config", isDirectory: true)
        let instDefaultUserDir = installRoot.appendingPathComponent("Users/Default", isDirectory: true)
        let clipchampDir = installRoot.appendingPathComponent("Program Files/WindowsApps/Clipchamp.Clipchamp_3.0.10020.0_arm64__yxz26nhyzhsrt", isDirectory: true)
        try fm.createDirectory(at: instConfigDir, withIntermediateDirectories: true)
        try fm.createDirectory(at: instDefaultUserDir, withIntermediateDirectories: true)
        try fm.createDirectory(at: clipchampDir, withIntermediateDirectories: true)

        try SyntheticRegfBuilder.writeMinimalHive(to: instConfigDir.appendingPathComponent("SOFTWARE").path)
        try SyntheticRegfBuilder.writeMinimalHive(to: instConfigDir.appendingPathComponent("SYSTEM").path)
        try SyntheticRegfBuilder.writeMinimalHive(to: instDefaultUserDir.appendingPathComponent("NTUSER.DAT").path)
        try Data(repeating: 0xAB, count: 65536).write(to: clipchampDir.appendingPathComponent("Clipchamp.exe"))
        try Data("onedrive-installer".utf8).write(to: installRoot.appendingPathComponent("Windows/System32/OneDriveSetup.exe"))

        // 3. 使用 wimlib-imagex 捕获生成源 boot.wim 与带标准 Windows 11 ARM64 元数据的 install.wim
        let mediaSourcesDir = sourceMediaDir.appendingPathComponent("sources", isDirectory: true)
        let mediaEfiDir = sourceMediaDir.appendingPathComponent("efi/microsoft/boot", isDirectory: true)
        try fm.createDirectory(at: mediaSourcesDir, withIntermediateDirectories: true)
        try fm.createDirectory(at: mediaEfiDir, withIntermediateDirectories: true)
        // 创建模拟的 64KB EFI 引导镜像扇区
        try Data(repeating: 0xEB, count: 65536).write(to: mediaEfiDir.appendingPathComponent("efisys.bin"))

        let bootWimPath = mediaSourcesDir.appendingPathComponent("boot.wim").path
        let bootCap = try await runner.run(
            executable: tools.wimlibImagex,
            arguments: ["capture", bootRoot.path, bootWimPath, "Microsoft Windows Setup (ARM64)", "--compress=fast", "--no-acls"]
        )
        #expect(bootCap.exitCode == 0)

        let installWimPath = mediaSourcesDir.appendingPathComponent("install.wim").path
        let instCap = try await runner.run(
            executable: tools.wimlibImagex,
            arguments: [
                "capture", installRoot.path, installWimPath, "Windows 11 Pro", "Windows 11 Pro",
                "--compress=fast", "--no-acls",
                "--image-property", "WINDOWS/ARCH=12",
                "--image-property", "WINDOWS/EDITIONID=Professional",
                "--image-property", "WINDOWS/INSTALLATIONTYPE=Client",
                "--image-property", "WINDOWS/VERSION/MAJOR=10",
                "--image-property", "WINDOWS/VERSION/MINOR=0",
                "--image-property", "WINDOWS/VERSION/BUILD=26100",
                "--image-property", "WINDOWS/VERSION/SPBUILD=2033"
            ]
        )
        #expect(instCap.exitCode == 0)

        // 4. 封装源 ISO 并使用 MacBuildEngine 完整检查与构建精简版 ISO
        let sourceIsoPath = sandbox.appendingPathComponent("Win11_24H2_ARM64_Source.iso").path
        let isoCreator = IsoCreator(mkisofsPath: tools.mkisofs, runner: runner)
        try await isoCreator.createBootableISO(
            stagingDirectory: sourceMediaDir.path,
            outputISO: sourceIsoPath,
            architecture: .arm64,
            efiBootRelativePath: "efi/microsoft/boot/efisys.bin",
            biosBootRelativePath: nil,
            volumeLabel: "WIN11_ARM64"
        )

        let engine = MacBuildEngine(tools: tools, runner: runner)
        let inspection = try await engine.inspectMedia(sourcePath: sourceIsoPath)
        #expect(inspection.images.count == 1)
        #expect(inspection.images[0].architecture == .arm64)
        #expect(inspection.images[0].build == 26100)

        let outputIsoPath = sandbox.appendingPathComponent("Tiny11_ARM64_Out.iso").path
        let workspaceDir = sandbox.appendingPathComponent("work", isDirectory: true).path
        let recipe = BuildRecipe(
            sourcePath: sourceIsoPath,
            imageIndex: 1,
            workspacePath: workspaceDir,
            outputPath: outputIsoPath,
            mode: .macVM,
            compression: .recoveryESD
        )

        let buildResult = try await engine.build(
            recipe: recipe,
            onProgress: { _ in },
            onLog: { _ in }
        )

        #expect(fm.fileExists(atPath: buildResult.isoPath))
        #expect(buildResult.sha256.count == 64)
        #expect(buildResult.deprovisionedAppsCount == 1)
        #expect(buildResult.removedEntriesCount >= 2)

        // 5. 挂载生成的精简版 ISO 验证内部结果：install.esd 存在、autounattend.xml 存在、Clipchamp 与 OneDrive 已被移除
        let reader = IsoMediaReader(hdiutilPath: tools.hdiutil, runner: runner)
        let outOpened = try await reader.open(sourcePath: outputIsoPath)
        do {
            let outInstallEsd = try #require(IsoMediaReader.resolveCaseInsensitive(root: outOpened.rootPath, components: ["sources", "install.esd"]))
            let outUnattend = try #require(IsoMediaReader.resolveCaseInsensitive(root: outOpened.rootPath, components: ["autounattend.xml"]))
            let unattendContent = try String(contentsOfFile: outUnattend.fullPath, encoding: .utf8)
            #expect(unattendContent.contains(#"processorArchitecture="arm64""#))
            #expect(unattendContent.contains("HideOnlineAccountScreens"))

            let wimClient = WimClient(executable: tools.wimlibImagex, runner: runner)
            let finalPaths = try await wimClient.listPaths(wimFile: outInstallEsd.fullPath, index: 1)
            let lowerFinal = Set(finalPaths.map { $0.lowercased() })
            #expect(!lowerFinal.contains(where: { $0.contains("clipchamp") }))
            #expect(!lowerFinal.contains("/windows/system32/onedrivesetup.exe"))
            #expect(lowerFinal.contains("/windows/setup/scripts/tiny11specialize.ps1"))
            await reader.close(outOpened)
        } catch {
            await reader.close(outOpened)
            throw error
        }
    }
}

/// 构造合法的 8192 字节最小 Windows REGF 注册表文件（零外部样本文件依赖）
enum SyntheticRegfBuilder {
    static func writeMinimalHive(to path: String) throws {
        var data = Data(count: 8192)

        func putU32(_ offset: Int, _ val: UInt32) {
            var le = val.littleEndian
            withUnsafeBytes(of: &le) { data.replaceSubrange(offset..<(offset + 4), with: $0) }
        }
        func putU16(_ offset: Int, _ val: UInt16) {
            var le = val.littleEndian
            withUnsafeBytes(of: &le) { data.replaceSubrange(offset..<(offset + 2), with: $0) }
        }
        func putI32(_ offset: Int, _ val: Int32) {
            var le = val.littleEndian
            withUnsafeBytes(of: &le) { data.replaceSubrange(offset..<(offset + 4), with: $0) }
        }

        // Page 0: regf header (4096 bytes)
        data.replaceSubrange(0..<4, with: Array("regf".utf8))
        putU32(0x04, 1)          // primary sequence
        putU32(0x08, 1)          // secondary sequence
        putU32(0x14, 1)          // major version
        putU32(0x18, 5)          // minor version
        putU32(0x1C, 0)          // type
        putU32(0x20, 1)          // format
        putU32(0x24, 0x20)       // root cell offset relative to 0x1000
        putU32(0x28, 0x1000)     // total hbin bytes
        putU32(0x2C, 1)          // clustering

        var checksum: UInt32 = 0
        for off in stride(from: 0, to: 0x1FC, by: 4) {
            let word = data.subdata(in: off..<(off + 4)).withUnsafeBytes { $0.load(as: UInt32.self) }
            checksum ^= UInt32(littleEndian: word)
        }
        putU32(0x1FC, checksum)

        // Page 1: hbin (4096 bytes at 0x1000)
        let hbin = 0x1000
        data.replaceSubrange(hbin..<(hbin + 4), with: Array("hbin".utf8))
        putU32(hbin + 0x04, 0)       // offset from first hbin
        putU32(hbin + 0x08, 0x1000)  // hbin size

        // Root nk cell at 0x1020 (allocated size = 96 bytes => negative -96, ends at 0x1080)
        let nk = 0x1020
        putI32(nk + 0x00, -96)
        data.replaceSubrange((nk + 0x04)..<(nk + 0x06), with: Array("nk".utf8))
        putU16(nk + 0x06, 0x002C)        // KEY_HIVE_ENTRY | KEY_COMP_NAME
        putU32(nk + 0x10, 0)             // access bits / unknown1
        putU32(nk + 0x14, 0xFFFF_FFFF)   // parent
        putU32(nk + 0x18, 0)             // nr_subkeys
        putU32(nk + 0x1C, 0)             // nr_volatile_subkeys
        putU32(nk + 0x20, 0xFFFF_FFFF)   // subkey_lf
        putU32(nk + 0x24, 0xFFFF_FFFF)   // volatile_subkey_lf
        putU32(nk + 0x28, 0)             // nr_values
        putU32(nk + 0x2C, 0xFFFF_FFFF)   // valuelist
        putU32(nk + 0x30, 0x0000_0080)   // sk offset relative to 0x1000 -> 0x1080
        putU32(nk + 0x34, 0xFFFF_FFFF)   // classname
        putU16(nk + 0x4C, 4)             // name_len ("ROOT")
        putU16(nk + 0x4E, 0)             // classname_len
        data.replaceSubrange((nk + 0x50)..<(nk + 0x54), with: Array("ROOT".utf8))

        // Minimal sk (Security Key) cell at 0x1080 (allocated size = 48 bytes => -48, ends at 0x10B0)
        let sk = 0x1080
        putI32(sk + 0x00, -48)
        data.replaceSubrange((sk + 0x04)..<(sk + 0x06), with: Array("sk".utf8))
        putU16(sk + 0x06, 0)
        putU32(sk + 0x08, 0x0000_0080)   // flink -> self
        putU32(sk + 0x0C, 0x0000_0080)   // blink -> self
        putU32(sk + 0x10, 1)             // refcount
        putU32(sk + 0x14, 20)            // security descriptor length (20 bytes)
        putU16(sk + 0x18, 1)             // SECURITY_DESCRIPTOR_RELATIVE revision = 1
        putU16(sk + 0x1A, 0x8004)        // SE_SELF_RELATIVE | SE_DACL_PRESENT

        // Remaining free block at 0x10B0, size = 0x2000 - 0x10B0 = 3920 (positive = free)
        putI32(0x10B0, 3920)

        try data.write(to: URL(fileURLWithPath: path))
    }
}
