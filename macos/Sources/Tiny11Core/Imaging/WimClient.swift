import Foundation

public enum WimUpdateCommand: Sendable, Equatable {
    /// 将本地文件或目录写入 WIM 指定路径（路径以 `\` 开头）
    case add(localPath: String, wimPath: String)
    /// 递归强制删除 WIM 内指定路径（路径以 `\` 开头）
    case delete(wimPath: String)

    func serializedLine() -> String {
        switch self {
        case .add(let local, let wim):
            return "add \(Self.quote(local)) \(Self.quote(wim))"
        case .delete(let wim):
            return "delete --force --recursive \(Self.quote(wim))"
        }
    }

    private static func quote(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\\\"")
        return "\"\(escaped)\""
    }
}

public final class WimClient: Sendable {
    private let executable: String
    private let runner: ProcessRunning

    public init(executable: String, runner: ProcessRunning = AsyncProcessRunner()) {
        self.executable = executable
        self.runner = runner
    }

    /// 读取 WIM / ESD 镜像中所有卷的元数据（直接解析标准 WIM XML 头，无代码页乱码问题）
    public func getImages(wimFile: String) async throws -> [WindowsImage] {
        let result = try await runner.run(
            executable: executable,
            arguments: ["info", "--xml", wimFile],
            stdinData: nil,
            environment: nil,
            onOutputLine: nil
        )
        guard result.exitCode == 0 else {
            throw Tiny11Error.processFailed(executable: executable, exitCode: result.exitCode, output: result.combinedText)
        }
        return try Self.parseWimXml(result.stdout)
    }

    public static func parseWimXml(_ rawData: Data) throws -> [WindowsImage] {
        guard !rawData.isEmpty else {
            throw Tiny11Error.invalidMedia(L10n.wimXmlEmpty())
        }

        let xmlString: String
        if rawData.count >= 2 && rawData[0] == 0xFF && rawData[1] == 0xFE {
            xmlString = String(data: rawData.dropFirst(2), encoding: .utf16LittleEndian) ?? ""
        } else if rawData.count >= 2 && rawData[0] == 0xFE && rawData[1] == 0xFF {
            xmlString = String(data: rawData.dropFirst(2), encoding: .utf16BigEndian) ?? ""
        } else if rawData.count >= 3 && rawData[0] == 0xEF && rawData[1] == 0xBB && rawData[2] == 0xBF {
            xmlString = String(decoding: rawData.dropFirst(3), as: UTF8.self)
        } else {
            xmlString = String(decoding: rawData, as: UTF8.self)
        }

        // 清理 XML 声明中可能与转换后 UTF-8 字符串冲突的 UTF-16 encoding 标记
        let sanitized = xmlString.replacingOccurrences(
            of: #"encoding=["']UTF-16["']"#,
            with: #"encoding="UTF-8""#,
            options: [.regularExpression, .caseInsensitive]
        )

        let doc = try XMLDocument(xmlString: sanitized, options: [])
        guard let root = doc.rootElement() else {
            throw Tiny11Error.invalidMedia(L10n.wimXmlRootParseError())
        }

        let imageElements = root.elements(forName: "IMAGE")
        var images: [WindowsImage] = []

        for imgElem in imageElements {
            guard let indexText = imgElem.attribute(forName: "INDEX")?.stringValue,
                  let index = Int(indexText) else {
                continue
            }

            let name = imgElem.elements(forName: "DISPLAYNAME").first?.stringValue
                ?? imgElem.elements(forName: "NAME").first?.stringValue
                ?? "Image \(index)"
            let description = imgElem.elements(forName: "DISPLAYDESCRIPTION").first?.stringValue
                ?? imgElem.elements(forName: "DESCRIPTION").first?.stringValue
                ?? ""
            let totalBytes = Int64(imgElem.elements(forName: "TOTALBYTES").first?.stringValue ?? "0") ?? 0

            guard let winElem = imgElem.elements(forName: "WINDOWS").first else {
                // 如 WinPE 卷可能不含完整 WINDOWS 节或仅用于 boot.wim 识别
                images.append(WindowsImage(
                    index: index,
                    name: name,
                    description: description,
                    architecture: .arm64,
                    major: 10,
                    minor: 0,
                    build: 0,
                    servicePackBuild: 0,
                    editionId: "",
                    installationType: "WinPE",
                    totalBytes: totalBytes
                ))
                continue
            }

            let archCode = Int(winElem.elements(forName: "ARCH").first?.stringValue ?? "-1") ?? -1
            let arch = ImageArchitecture.fromWimArchCode(archCode) ?? .x64
            let editionId = winElem.elements(forName: "EDITIONID").first?.stringValue ?? ""
            let installationType = winElem.elements(forName: "INSTALLATIONTYPE").first?.stringValue ?? "Client"

            let verElem = winElem.elements(forName: "VERSION").first
            let major = Int(verElem?.elements(forName: "MAJOR").first?.stringValue ?? "0") ?? 0
            let minor = Int(verElem?.elements(forName: "MINOR").first?.stringValue ?? "0") ?? 0
            let build = Int(verElem?.elements(forName: "BUILD").first?.stringValue ?? "0") ?? 0
            let spBuild = Int(verElem?.elements(forName: "SPBUILD").first?.stringValue ?? "0") ?? 0

            var langs: [String] = []
            if let langsElem = winElem.elements(forName: "LANGUAGES").first {
                for l in langsElem.elements(forName: "LANGUAGE") {
                    if let val = l.stringValue, !val.isEmpty {
                        langs.append(val)
                    }
                }
            }

            images.append(WindowsImage(
                index: index,
                name: name,
                description: description,
                architecture: arch,
                major: major,
                minor: minor,
                build: build,
                servicePackBuild: spBuild,
                editionId: editionId,
                installationType: installationType,
                totalBytes: totalBytes,
                languages: langs
            ))
        }

        if images.isEmpty {
            throw Tiny11Error.invalidMedia(L10n.wimNoSystemVolumes())
        }
        return images.sorted(by: { $0.index < $1.index })
    }

    /// 列出 WIM 内部指定子路径下的条目（路径使用反斜杠或正斜杠均可，返回带前导 `/` 的标准路径）
    public func listPaths(wimFile: String, index: Int, subpath: String? = nil) async throws -> [String] {
        var args = ["dir", wimFile, String(index)]
        if let subpath {
            args.append("--path=\(subpath)")
        }
        let result = try await runner.run(
            executable: executable,
            arguments: args,
            stdinData: nil,
            environment: nil,
            onOutputLine: nil
        )
        if result.exitCode != 0 {
            let text = result.combinedText
            if text.localizedCaseInsensitiveContains("does not exist") || text.localizedCaseInsensitiveContains("not found") {
                return []
            }
            throw Tiny11Error.processFailed(executable: executable, exitCode: result.exitCode, output: text)
        }
        let output = String(decoding: result.stdout, as: UTF8.self)
        return output
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    /// 从 WIM 中提取指定文件到本地目录（不附带 NTFS ACL/只读属性，便于离线修改 Hive）
    public func extract(
        wimFile: String,
        index: Int,
        wimPaths: [String],
        destinationDir: String,
        nullglob: Bool = true
    ) async throws {
        guard !wimPaths.isEmpty else { return }
        try FileManager.default.createDirectory(atPath: destinationDir, withIntermediateDirectories: true)
        var args = [
            "extract",
            wimFile,
            String(index),
            "--dest-dir=\(destinationDir)",
            "--no-acls",
            "--no-attributes"
        ]
        if nullglob {
            args.append("--nullglob")
        }
        args.append(contentsOf: wimPaths)

        let result = try await runner.run(
            executable: executable,
            arguments: args,
            stdinData: nil,
            environment: nil,
            onOutputLine: nil
        )
        guard result.exitCode == 0 else {
            throw Tiny11Error.processFailed(executable: executable, exitCode: result.exitCode, output: result.combinedText)
        }
    }

    /// 通过单次事务向 WIM 提交增删命令批处理
    public func update(
        wimFile: String,
        index: Int,
        commands: [WimUpdateCommand],
        checkIntegrity: Bool = true,
        onOutput: (@Sendable (String) -> Void)? = nil
    ) async throws {
        guard !commands.isEmpty else { return }
        let script = commands.map { $0.serializedLine() }.joined(separator: "\n") + "\n"
        var args = ["update", wimFile, String(index)]
        if checkIntegrity {
            args.append("--check")
        }
        let result = try await runner.run(
            executable: executable,
            arguments: args,
            stdinData: Data(script.utf8),
            environment: nil,
            onOutputLine: onOutput
        )
        guard result.exitCode == 0 else {
            throw Tiny11Error.processFailed(executable: executable, exitCode: result.exitCode, output: result.combinedText)
        }
    }

    /// 导出单个卷并按指定级别多核压缩（支持导出为工作 WIM、精简 boot.wim 或最终 install.esd / install.wim）
    public func export(
        sourceWim: String,
        sourceIndex: Int,
        destinationFile: String,
        compression: CompressionMode,
        checkIntegrity: Bool = true,
        bootable: Bool = false,
        threads: Int = ProcessInfo.processInfo.activeProcessorCount,
        onOutput: (@Sendable (String, Double?) -> Void)? = nil
    ) async throws {
        if FileManager.default.fileExists(atPath: destinationFile) {
            try FileManager.default.removeItem(atPath: destinationFile)
        }

        var args = [
            "export",
            sourceWim,
            String(sourceIndex),
            destinationFile,
            "--threads=\(max(1, threads))"
        ]

        switch compression {
        case .fastWIM:
            args.append("--compress=fast")
        case .maximumWIM:
            args.append("--compress=LZX")
        case .recoveryESD:
            args.append("--compress=LZMS")
            args.append("--solid")
        }

        if bootable {
            args.append("--boot")
        }
        if checkIntegrity {
            args.append("--check")
        }

        let result = try await runner.run(
            executable: executable,
            arguments: args,
            stdinData: nil,
            environment: nil,
            onOutputLine: { line in
                let pct = Self.extractPercent(from: line)
                onOutput?(line, pct)
            }
        )
        guard result.exitCode == 0 else {
            throw Tiny11Error.processFailed(executable: executable, exitCode: result.exitCode, output: result.combinedText)
        }
    }

    public static func extractPercent(from line: String) -> Double? {
        guard let range = line.range(of: #"\((\d{1,3})%\)"#, options: .regularExpression) else {
            return nil
        }
        let match = line[range]
        let digits = match.filter(\.isNumber)
        return Double(digits)
    }
}
