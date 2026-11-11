import Foundation
import CryptoKit

public enum IsoValidator {
    /// 校验文件是否具备合法的 ISO9660 / UDF 卷描述符（对应原版 IsoStructure.cs）
    public static func validateISO(at path: String) throws {
        let url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: path) else {
            throw Tiny11Error.invalidMedia(L10n.isoFileNotFound(path))
        }
        let attrs = try FileManager.default.attributesOfItem(atPath: path)
        let length = (attrs[.size] as? NSNumber)?.int64Value ?? 0
        guard length >= 34816, length % 2048 == 0 else {
            throw Tiny11Error.invalidMedia(L10n.isoInvalidSectorSize(length))
        }

        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }
        try handle.seek(toOffset: 2048 * 16)
        guard let descriptor = try handle.read(upToCount: 2048 * 16), descriptor.count >= 6 else {
            throw Tiny11Error.invalidMedia(L10n.isoDescriptorReadError())
        }

        let validMarkers: Set<String> = ["CD001", "BEA01", "NSR02", "NSR03"]
        var offset = 1
        while offset + 5 <= descriptor.count {
            let slice = descriptor.subdata(in: offset..<(offset + 5))
            if let tag = String(data: slice, encoding: .ascii), validMarkers.contains(tag) {
                return
            }
            offset += 2048
        }
        throw Tiny11Error.invalidMedia(L10n.isoInvalidVolumeDescriptor())
    }

    /// 流式计算大文件 SHA-256，支持取消与进度回调
    public static func sha256Hex(at path: String, onPercent: (@Sendable (Int) -> Void)? = nil) throws -> (bytes: Int64, sha256: String) {
        let url = URL(fileURLWithPath: path)
        let attrs = try FileManager.default.attributesOfItem(atPath: path)
        let total = (attrs[.size] as? NSNumber)?.int64Value ?? 0
        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }

        var hasher = SHA256()
        var processed: Int64 = 0
        var lastReported = -1
        let chunkSize = 4 * 1024 * 1024

        while true {
            try Task.checkCancellation()
            guard let chunk = try handle.read(upToCount: chunkSize), !chunk.isEmpty else {
                break
            }
            hasher.update(data: chunk)
            processed += Int64(chunk.count)
            if total > 0, let onPercent {
                let pct = Int((processed * 100) / total)
                if pct >= lastReported + 5 || pct == 100 {
                    lastReported = pct
                    onPercent(pct)
                }
            }
        }
        let digest = hasher.finalize()
        let hex = digest.map { String(format: "%02X", $0) }.joined()
        return (processed, hex)
    }
}
