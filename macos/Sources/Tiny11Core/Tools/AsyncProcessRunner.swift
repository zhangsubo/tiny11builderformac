import Foundation

public struct ProcessResult: Sendable {
    public let exitCode: Int32
    public let stdout: Data
    public let stderr: Data

    public var combinedText: String {
        let outStr = String(decoding: stdout, as: UTF8.self)
        let errStr = String(decoding: stderr, as: UTF8.self)
        if outStr.isEmpty { return errStr }
        if errStr.isEmpty { return outStr }
        return outStr + "\n" + errStr
    }
}

public protocol ProcessRunning: Sendable {
    func run(
        executable: String,
        arguments: [String],
        stdinData: Data?,
        environment: [String: String]?,
        onOutputLine: (@Sendable (String) -> Void)?
    ) async throws -> ProcessResult
}

public final class AsyncProcessRunner: ProcessRunning, Sendable {
    public init() {}

    public func run(
        executable: String,
        arguments: [String],
        stdinData: Data? = nil,
        environment: [String: String]? = nil,
        onOutputLine: (@Sendable (String) -> Void)? = nil
    ) async throws -> ProcessResult {
        try Task.checkCancellation()

        let box = ProcessBox()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let process = Process()
                process.executableURL = URL(fileURLWithPath: executable)
                process.arguments = arguments

                var mergedEnv = ProcessInfo.processInfo.environment
                mergedEnv["LC_ALL"] = "en_US.UTF-8"
                if let environment {
                    for (k, v) in environment { mergedEnv[k] = v }
                }
                process.environment = mergedEnv

                let outPipe = Pipe()
                let errPipe = Pipe()
                process.standardOutput = outPipe
                process.standardError = errPipe

                let stdinPipe: Pipe?
                if stdinData != nil {
                    let p = Pipe()
                    process.standardInput = p
                    stdinPipe = p
                } else {
                    stdinPipe = nil
                }

                let collector = StreamCollector(onOutputLine: onOutputLine)

                outPipe.fileHandleForReading.readabilityHandler = { handle in
                    let chunk = handle.availableData
                    if !chunk.isEmpty {
                        collector.appendStdout(chunk)
                    }
                }
                errPipe.fileHandleForReading.readabilityHandler = { handle in
                    let chunk = handle.availableData
                    if !chunk.isEmpty {
                        collector.appendStderr(chunk)
                    }
                }

                process.terminationHandler = { proc in
                    outPipe.fileHandleForReading.readabilityHandler = nil
                    errPipe.fileHandleForReading.readabilityHandler = nil
                    let remainOut = outPipe.fileHandleForReading.readDataToEndOfFile()
                    let remainErr = errPipe.fileHandleForReading.readDataToEndOfFile()
                    if !remainOut.isEmpty { collector.appendStdout(remainOut) }
                    if !remainErr.isEmpty { collector.appendStderr(remainErr) }
                    collector.flushRemainingLines()

                    let (stdoutData, stderrData) = collector.snapshot()
                    if box.wasCancelled {
                        continuation.resume(throwing: Tiny11Error.cancelled)
                    } else {
                        continuation.resume(returning: ProcessResult(
                            exitCode: proc.terminationStatus,
                            stdout: stdoutData,
                            stderr: stderrData
                        ))
                    }
                }

                do {
                    box.attach(process)
                    try process.run()
                    if let stdinData, let stdinPipe {
                        try? stdinPipe.fileHandleForWriting.write(contentsOf: stdinData)
                        try? stdinPipe.fileHandleForWriting.close()
                    }
                } catch {
                    outPipe.fileHandleForReading.readabilityHandler = nil
                    errPipe.fileHandleForReading.readabilityHandler = nil
                    continuation.resume(throwing: error)
                }
            }
        } onCancel: {
            box.terminateIfRunning()
        }
    }
}

private final class ProcessBox: @unchecked Sendable {
    private let lock = NSLock()
    private var process: Process?
    private var cancelled = false

    var wasCancelled: Bool {
        lock.lock()
        defer { lock.unlock() }
        return cancelled
    }

    func attach(_ proc: Process) {
        lock.lock()
        process = proc
        let shouldTerminate = cancelled
        lock.unlock()
        if shouldTerminate && proc.isRunning {
            proc.terminate()
        }
    }

    func terminateIfRunning() {
        lock.lock()
        cancelled = true
        let proc = process
        lock.unlock()
        if let proc, proc.isRunning {
            proc.terminate()
        }
    }
}

private final class StreamCollector: @unchecked Sendable {
    private let lock = NSLock()
    private var stdoutBuffer = Data()
    private var stderrBuffer = Data()
    private var lineRemainder = ""
    private let onOutputLine: (@Sendable (String) -> Void)?

    init(onOutputLine: (@Sendable (String) -> Void)?) {
        self.onOutputLine = onOutputLine
    }

    func appendStdout(_ data: Data) {
        var lines: [String] = []
        lock.lock()
        stdoutBuffer.append(data)
        if onOutputLine != nil {
            lines = extractLines(from: data)
        }
        lock.unlock()
        emit(lines)
    }

    func appendStderr(_ data: Data) {
        var lines: [String] = []
        lock.lock()
        stderrBuffer.append(data)
        if onOutputLine != nil {
            lines = extractLines(from: data)
        }
        lock.unlock()
        emit(lines)
    }

    func flushRemainingLines() {
        var tail: String?
        lock.lock()
        let trimmed = lineRemainder.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            tail = trimmed
        }
        lineRemainder = ""
        lock.unlock()
        if let tail, let onOutputLine {
            onOutputLine(tail)
        }
    }

    func snapshot() -> (Data, Data) {
        lock.lock()
        defer { lock.unlock() }
        return (stdoutBuffer, stderrBuffer)
    }

    private func extractLines(from data: Data) -> [String] {
        let text = String(decoding: data, as: UTF8.self).replacingOccurrences(of: "\r", with: "\n")
        lineRemainder += text
        var parts = lineRemainder.components(separatedBy: "\n")
        lineRemainder = parts.removeLast()
        return parts.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }

    private func emit(_ lines: [String]) {
        guard let onOutputLine else { return }
        for line in lines {
            onOutputLine(line)
        }
    }
}
