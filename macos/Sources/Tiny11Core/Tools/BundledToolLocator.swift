import Foundation

public struct ToolLocations: Sendable, Equatable {
    public let wimlibImagex: String
    public let mkisofs: String
    public let hdiutil: String
    public let bundledMode: Bool

    public init(wimlibImagex: String, mkisofs: String, hdiutil: String, bundledMode: Bool) {
        self.wimlibImagex = wimlibImagex
        self.mkisofs = mkisofs
        self.hdiutil = hdiutil
        self.bundledMode = bundledMode
    }
}

public enum BundledToolLocator {
    public static func locate() throws -> ToolLocations {
        let fm = FileManager.default
        let hdiutil = "/usr/bin/hdiutil"
        guard fm.isExecutableFile(atPath: hdiutil) else {
            throw Tiny11Error.toolMissing("/usr/bin/hdiutil 不可用。")
        }

        // 1. 优先查找 .app/Contents/Resources/bin 内嵌的独立工具
        if let resourceURL = Bundle.main.resourceURL {
            let binDir = resourceURL.appendingPathComponent("bin")
            let bundledWim = binDir.appendingPathComponent("wimlib-imagex").path
            let bundledMkisofs = binDir.appendingPathComponent("mkisofs").path
            if fm.isExecutableFile(atPath: bundledWim), fm.isExecutableFile(atPath: bundledMkisofs) {
                return ToolLocations(
                    wimlibImagex: bundledWim,
                    mkisofs: bundledMkisofs,
                    hdiutil: hdiutil,
                    bundledMode: true
                )
            }
        }

        // 2. 支持环境变量覆盖（方便测试或自定义路径）
        let env = ProcessInfo.processInfo.environment
        let wimCandidates = [
            env["TINY11_WIMLIB_IMAGEX"],
            "/opt/homebrew/bin/wimlib-imagex",
            "/usr/local/bin/wimlib-imagex"
        ].compactMap { $0 }

        let isoCandidates = [
            env["TINY11_MKISOFS"],
            "/opt/homebrew/bin/mkisofs",
            "/usr/local/bin/mkisofs"
        ].compactMap { $0 }

        guard let wimPath = wimCandidates.first(where: { fm.isExecutableFile(atPath: $0) }) else {
            throw Tiny11Error.toolMissing(
                "未找到 wimlib-imagex。若是开发模式请运行 macos/Scripts/setup-dev-deps.sh，或使用打包好的 Tiny11Builder.app。"
            )
        }
        guard let mkisofsPath = isoCandidates.first(where: { fm.isExecutableFile(atPath: $0) }) else {
            throw Tiny11Error.toolMissing(
                "未找到 mkisofs (cdrtools)。若是开发模式请运行 macos/Scripts/setup-dev-deps.sh，或使用打包好的 Tiny11Builder.app。"
            )
        }

        return ToolLocations(
            wimlibImagex: wimPath,
            mkisofs: mkisofsPath,
            hdiutil: hdiutil,
            bundledMode: false
        )
    }
}
