import Foundation

public final class IsoCreator: Sendable {
    private let mkisofsPath: String
    private let runner: ProcessRunning

    public init(mkisofsPath: String, runner: ProcessRunning = AsyncProcessRunner()) {
        self.mkisofsPath = mkisofsPath
        self.runner = runner
    }

    /// 使用 cdrtools mkisofs 生成兼容大于 4GB 文件的 UDF + ISO9660 Level 3 + El Torito UEFI (及 x64 BIOS) 混合引导 ISO
    public func createBootableISO(
        stagingDirectory: String,
        outputISO: String,
        architecture: ImageArchitecture,
        efiBootRelativePath: String,
        biosBootRelativePath: String?,
        volumeLabel: String = "TINY11",
        onOutput: (@Sendable (String) -> Void)? = nil
    ) async throws {
        let fm = FileManager.default
        if fm.fileExists(atPath: outputISO) {
            try fm.removeItem(atPath: outputISO)
        }

        // 确保传入 mkisofs 的引导镜像相对路径使用正斜杠且位于 stagingDirectory 内部
        let cleanEfi = efiBootRelativePath.replacingOccurrences(of: "\\", with: "/")
        var args: [String] = [
            "-iso-level", "3",
            "-udf",
            "-r",
            "-D",
            "-N",
            "-V", String(volumeLabel.prefix(32)),
            "-c", "boot.catalog",
            "-hide", "boot.catalog",
            "-hide-udf", "boot.catalog"
        ]

        if architecture == .x64,
           let biosRel = biosBootRelativePath?.replacingOccurrences(of: "\\", with: "/"),
           fm.fileExists(atPath: URL(fileURLWithPath: stagingDirectory).appendingPathComponent(biosRel).path) {
            // x64 双引导：Legacy BIOS (etfsboot.com) + UEFI (efisys.bin, Platform 0xEF)
            args.append(contentsOf: [
                "-b", biosRel,
                "-no-emul-boot",
                "-boot-load-size", "8",
                "-eltorito-alt-boot",
                "-eltorito-platform", "efi",
                "-b", cleanEfi,
                "-no-emul-boot"
            ])
        } else {
            // ARM64 或纯 UEFI 介质：挂载 El Torito Platform 0xEF 引导扇区
            args.append(contentsOf: [
                "-eltorito-platform", "efi",
                "-b", cleanEfi,
                "-no-emul-boot"
            ])
        }

        args.append(contentsOf: ["-o", outputISO, stagingDirectory])

        let result = try await runner.run(
            executable: mkisofsPath,
            arguments: args,
            stdinData: nil,
            environment: nil,
            onOutputLine: onOutput
        )

        guard result.exitCode == 0,
              fm.fileExists(atPath: outputISO),
              ((try? fm.attributesOfItem(atPath: outputISO)[.size] as? NSNumber)?.int64Value ?? 0) >= 34816 else {
            throw Tiny11Error.processFailed(
                executable: mkisofsPath,
                exitCode: result.exitCode,
                output: result.combinedText
            )
        }
    }
}
