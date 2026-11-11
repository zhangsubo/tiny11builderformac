import Foundation
import Darwin

public struct MediaStagingResult: Codable, Sendable, Equatable {
    public let copiedFiles: Int
    public let copiedBytes: Int64
    public let omittedFiles: Int
    public let omittedBytes: Int64
}

public enum MediaStager {
    /// 将安装盘中除 `sources/install.(wim|esd)` 以外的所有引导和安装支持文件复制到暂存区，并赋予用户可写权限
    public static func copyMedia(
        from sourceRoot: String,
        to stagingRoot: String,
        omitNetFx3Payload: Bool,
        onLog: @Sendable (String) -> Void
    ) throws -> MediaStagingResult {
        let fm = FileManager.default
        let rootURL = URL(fileURLWithPath: sourceRoot).standardizedFileURL
        let targetURL = URL(fileURLWithPath: stagingRoot).standardizedFileURL
        try fm.createDirectory(at: targetURL, withIntermediateDirectories: true)

        guard let enumerator = fm.enumerator(
            at: rootURL,
            includingPropertiesForKeys: [.isDirectoryKey, .isSymbolicLinkKey, .fileSizeKey],
            options: []
        ) else {
            throw Tiny11Error.invalidMedia(L10n.stagerEnumerateError(sourceRoot))
        }

        struct PendingCopy {
            let source: URL
            let relativePath: String
            let size: Int64
        }

        var candidates: [PendingCopy] = []
        var omittedCount = 0
        var omittedBytes: Int64 = 0

        for case let itemURL as URL in enumerator {
            try Task.checkCancellation()
            let values = try itemURL.resourceValues(forKeys: [.isDirectoryKey, .isSymbolicLinkKey, .fileSizeKey])
            if values.isSymbolicLink == true {
                throw Tiny11Error.invalidMedia(L10n.stagerUnsupportedSymlink(itemURL.path))
            }
            if values.isDirectory == true {
                continue
            }

            let fullPath = itemURL.standardizedFileURL.path
            let prefix = rootURL.path.hasSuffix("/") ? rootURL.path : rootURL.path + "/"
            guard fullPath.hasPrefix(prefix) else { continue }
            let relative = String(fullPath.dropFirst(prefix.count))
            let lowerRel = relative.lowercased()
            let lowerLeaf = itemURL.lastPathComponent.lowercased()

            // 跳过主系统卷、光盘引导目录表（由 mkisofs 重新合成）以及 macOS Finder 元数据文件
            if lowerRel == "sources/install.wim" || lowerRel == "sources/install.esd" || lowerRel == "boot.catalog" {
                continue
            }
            if lowerLeaf == ".ds_store" || lowerLeaf.hasPrefix("._") {
                continue
            }
            if lowerRel.hasPrefix("sources/install") && lowerRel.hasSuffix(".swm") {
                throw Tiny11Error.invalidMedia(L10n.stagerUnsupportedSwm())
            }
            if omitNetFx3Payload && lowerRel.hasPrefix("sources/sxs/") {
                omittedCount += 1
                omittedBytes += Int64(values.fileSize ?? 0)
                continue
            }

            candidates.append(PendingCopy(
                source: itemURL,
                relativePath: relative,
                size: Int64(values.fileSize ?? 0)
            ))
        }

        // 大文件优先复制
        candidates.sort { $0.size > $1.size }

        var copiedBytes: Int64 = 0
        for (idx, entry) in candidates.enumerated() {
            try Task.checkCancellation()
            let destURL = targetURL.appendingPathComponent(entry.relativePath)
            let parentDir = destURL.deletingLastPathComponent()
            try fm.createDirectory(at: parentDir, withIntermediateDirectories: true)
            if fm.fileExists(atPath: destURL.path) {
                try fm.removeItem(at: destURL)
            }
            // 仅复制纯文件数据流（忽略 UDF/ISO9660 光盘文件系统的只读/不可变元数据标志）
            let rc = Darwin.copyfile(entry.source.path, destURL.path, nil, copyfile_flags_t(COPYFILE_DATA))
            guard rc == 0 else {
                let errMsg = String(cString: strerror(errno))
                throw Tiny11Error.invalidMedia(L10n.stagerCopyFailed(relativePath: entry.relativePath, error: errMsg))
            }
            _ = Darwin.chmod(destURL.path, mode_t(0o644))
            copiedBytes += entry.size

            let current = idx + 1
            if current % 100 == 0 || current == candidates.count {
                onLog(L10n.logMediaStagedProgress(current: current, total: candidates.count))
            }
        }

        if omittedCount > 0 {
            onLog(L10n.logOmittedNetFx3Payload(count: omittedCount, mib: omittedBytes / (1024 * 1024)))
        }

        return MediaStagingResult(
            copiedFiles: candidates.count,
            copiedBytes: copiedBytes,
            omittedFiles: omittedCount,
            omittedBytes: omittedBytes
        )
    }
}
