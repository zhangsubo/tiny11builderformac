import Foundation

public struct OpenedMedia: Sendable {
    public let rootPath: String
    public let deviceEntry: String?
    public let ownedMount: Bool
}

public final class IsoMediaReader: Sendable {
    private let hdiutilPath: String
    private let runner: ProcessRunning

    public init(hdiutilPath: String = "/usr/bin/hdiutil", runner: ProcessRunning = AsyncProcessRunner()) {
        self.hdiutilPath = hdiutilPath
        self.runner = runner
    }

    public func open(sourcePath: String) async throws -> OpenedMedia {
        let fm = FileManager.default
        let standardized = URL(fileURLWithPath: sourcePath).standardizedFileURL.path
        var isDir: ObjCBool = false
        guard fm.fileExists(atPath: standardized, isDirectory: &isDir) else {
            throw Tiny11Error.invalidMedia(L10n.mediaSourceNotFound(standardized))
        }

        if isDir.boolValue {
            return OpenedMedia(rootPath: standardized, deviceEntry: nil, ownedMount: false)
        }

        guard standardized.lowercased().hasSuffix(".iso") else {
            throw Tiny11Error.invalidMedia(L10n.mediaInvalidExtension())
        }

        try IsoValidator.validateISO(at: standardized)

        // 先检查是否已经被用户在 Finder 中挂载，若是则直接复用挂载点且不在构建结束时强行弹出用户的挂载卷
        if let existingMount = try? await findExistingMountPoint(forISO: standardized) {
            return OpenedMedia(rootPath: existingMount, deviceEntry: nil, ownedMount: false)
        }

        let mountParent = fm.temporaryDirectory.appendingPathComponent("tiny11-mounts", isDirectory: true)
        try fm.createDirectory(at: mountParent, withIntermediateDirectories: true)

        let result = try await runner.run(
            executable: hdiutilPath,
            arguments: [
                "attach",
                "-readonly",
                "-nobrowse",
                "-noverify",
                "-mountrandom", mountParent.path,
                "-plist",
                standardized
            ],
            stdinData: nil,
            environment: nil,
            onOutputLine: nil
        )

        guard result.exitCode == 0 else {
            throw Tiny11Error.processFailed(
                executable: hdiutilPath,
                exitCode: result.exitCode,
                output: result.combinedText
            )
        }

        guard let plist = try? PropertyListSerialization.propertyList(from: result.stdout, options: [], format: nil) as? [String: Any],
              let entities = plist["system-entities"] as? [[String: Any]] else {
            throw Tiny11Error.invalidMedia(L10n.hdiutilParseError())
        }

        for entity in entities {
            if let mountPoint = entity["mount-point"] as? String, !mountPoint.isEmpty {
                let devEntry = entity["dev-entry"] as? String
                return OpenedMedia(rootPath: mountPoint, deviceEntry: devEntry, ownedMount: true)
            }
        }

        throw Tiny11Error.invalidMedia(L10n.hdiutilNoReadableVolume())
    }

    public func close(_ media: OpenedMedia) async {
        guard media.ownedMount else { return }
        let target = media.deviceEntry ?? media.rootPath
        _ = try? await runner.run(
            executable: hdiutilPath,
            arguments: ["detach", target, "-force"],
            stdinData: nil,
            environment: nil,
            onOutputLine: nil
        )
    }

    private func findExistingMountPoint(forISO isoPath: String) async throws -> String? {
        let infoResult = try await runner.run(
            executable: hdiutilPath,
            arguments: ["info", "-plist"],
            stdinData: nil,
            environment: nil,
            onOutputLine: nil
        )
        guard infoResult.exitCode == 0,
              let plist = try? PropertyListSerialization.propertyList(from: infoResult.stdout, options: [], format: nil) as? [String: Any],
              let images = plist["images"] as? [[String: Any]] else {
            return nil
        }

        let targetStandard = URL(fileURLWithPath: isoPath).resolvingSymlinksInPath().path
        for image in images {
            guard let imagePath = image["image-path"] as? String else { continue }
            let candidateStandard = URL(fileURLWithPath: imagePath).resolvingSymlinksInPath().path
            guard candidateStandard == targetStandard,
                  let entities = image["system-entities"] as? [[String: Any]] else { continue }
            for entity in entities {
                if let mountPoint = entity["mount-point"] as? String, !mountPoint.isEmpty {
                    return mountPoint
                }
            }
        }
        return nil
    }

    /// 大小写无关查找安装盘内的相对路径（兼容 UDF 大写 `SOURCES/BOOT.WIM` 与小写 `sources/boot.wim`）
    public static func resolveCaseInsensitive(root: String, components: [String]) -> (fullPath: String, relativePath: String)? {
        let fm = FileManager.default
        var currentURL = URL(fileURLWithPath: root)
        var resolvedRelative: [String] = []

        for part in components {
            guard let entries = try? fm.contentsOfDirectory(atPath: currentURL.path) else {
                return nil
            }
            guard let matched = entries.first(where: { $0.caseInsensitiveCompare(part) == .orderedSame }) else {
                return nil
            }
            currentURL.appendPathComponent(matched)
            resolvedRelative.append(matched)
        }
        return (currentURL.path, resolvedRelative.joined(separator: "/"))
    }
}
