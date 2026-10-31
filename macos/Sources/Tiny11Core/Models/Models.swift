import Foundation

public enum BuildMode: String, Codable, CaseIterable, Sendable, Identifiable {
    case macVM = "MacVM"
    case tiny11 = "Tiny11"
    case tiny11Core = "Tiny11Core"
    case custom = "Custom"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .macVM: return "Tiny11 · Mac 虚拟机优化版"
        case .tiny11: return "Tiny11 · 标准精简版"
        case .tiny11Core: return "Tiny11 Core · 极限测试版"
        case .custom: return "Custom · 自定义构建"
        }
    }

    public var badge: String? {
        switch self {
        case .macVM: return "推荐 · Parallels / Fusion / UTM"
        case .tiny11: return "PC 装机通用"
        case .tiny11Core: return "不可更新 · 仅限测试"
        case .custom: return "按需勾选"
        }
    }

    public var summary: String {
        switch self {
        case .macVM:
            return "专为 Apple Silicon 虚拟机调优：移除 20+ 预装臃肿应用与广告遥测，自动绕过 TPM/内存限制与 OOBE 无网卡强制联网死锁，关闭自动加密与预留空间（立省约 7GB 虚拟磁盘），完整保留 Guest Tools 驱动与系统更新能力。"
        case .tiny11:
            return "复刻原版 Tiny11 规则：彻底移除预装应用、Edge/WebView2 及 OneDrive 安装程序，保留 Windows Update、Defender 与系统恢复能力。"
        case .tiny11Core:
            return "在标准版基础上进一步裁剪 WinSxS 组件库、移除 WinRE 恢复镜像并禁用 Windows Update 与 Defender。体积最小，但安装后无法打补丁或添加功能。"
        case .custom:
            return "从空白方案起步，自由勾选要移除的预装应用、可选功能、系统文件、隐私策略以及是否启用 Core 级深度组件裁剪。"
        }
    }

    public var isCoreFlavor: Bool {
        self == .tiny11Core
    }
}

public enum CompressionMode: String, Codable, CaseIterable, Sendable, Identifiable {
    case recoveryESD = "Recovery"
    case maximumWIM = "Maximum"
    case fastWIM = "Fast"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .recoveryESD: return "极限固态压缩 (Recovery ESD)"
        case .maximumWIM: return "高压缩可挂载 (Maximum WIM)"
        case .fastWIM: return "极速构建 (Fast WIM)"
        }
    }

    public var subtitle: String {
        switch self {
        case .recoveryESD: return "输出 install.esd（LZMS 固态压缩），ISO 体积最小（约 2.8~3.3 GiB），多核全力加速但耗时较长。"
        case .maximumWIM: return "输出 install.wim（LZX 压缩），兼顾较小体积与后续二次离线维护。"
        case .fastWIM: return "输出 install.wim（XPRESS 快速压缩），打包速度最快，适合本地虚拟机快速装机验证。"
        }
    }

    public var installFileName: String {
        self == .recoveryESD ? "install.esd" : "install.wim"
    }
}

public enum ImageArchitecture: String, Codable, Sendable, CaseIterable {
    case arm64 = "arm64"
    case x64 = "x64"

    public var displayName: String {
        switch self {
        case .arm64: return "ARM64 (Apple Silicon 虚拟机原生架构)"
        case .x64: return "x64 / AMD64 (Intel/AMD PC 架构)"
        }
    }

    public var unattendProcessorArchitecture: String {
        switch self {
        case .arm64: return "arm64"
        case .x64: return "amd64"
        }
    }

    public static func fromWimArchCode(_ code: Int) -> ImageArchitecture? {
        switch code {
        case 12: return .arm64
        case 9: return .x64
        default: return nil
        }
    }
}

public enum OptionKind: String, Codable, Sendable {
    case app = "App"
    case feature = "Feature"
    case capability = "Capability"
    case policy = "Policy"
    case file = "File"
}

public enum PolicyHive: String, Codable, Sendable {
    case software = "Software"
    case defaultUser = "DefaultUser"
    case system = "System"
}

public enum RegistryValueData: Codable, Sendable, Equatable {
    case dword(UInt32)
    case string(String)
}

public struct PolicyValue: Codable, Sendable, Equatable {
    public let hive: PolicyHive
    public let keyPath: String
    public let name: String
    public let data: RegistryValueData

    public init(hive: PolicyHive, keyPath: String, name: String, data: RegistryValueData) {
        self.hive = hive
        self.keyPath = keyPath
        self.name = name
        self.data = data
    }
}

public struct CleanupOption: Codable, Sendable, Equatable, Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let category: String
    public let kind: OptionKind
    public let macVMDefault: Bool
    public let tiny11Default: Bool
    public let coreDefault: Bool
    public let targets: [String]

    public init(
        id: String,
        title: String,
        description: String,
        category: String,
        kind: OptionKind,
        macVMDefault: Bool,
        tiny11Default: Bool,
        coreDefault: Bool,
        targets: [String] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.kind = kind
        self.macVMDefault = macVMDefault
        self.tiny11Default = tiny11Default
        self.coreDefault = coreDefault
        self.targets = targets
    }
}

public struct WindowsImage: Codable, Sendable, Equatable, Identifiable {
    public let index: Int
    public let name: String
    public let description: String
    public let architecture: ImageArchitecture
    public let major: Int
    public let minor: Int
    public let build: Int
    public let servicePackBuild: Int
    public let editionId: String
    public let installationType: String
    public let totalBytes: Int64
    public let languages: [String]

    public var id: Int { index }

    public init(
        index: Int,
        name: String,
        description: String,
        architecture: ImageArchitecture,
        major: Int,
        minor: Int,
        build: Int,
        servicePackBuild: Int,
        editionId: String,
        installationType: String,
        totalBytes: Int64,
        languages: [String] = []
    ) {
        self.index = index
        self.name = name
        self.description = description
        self.architecture = architecture
        self.major = major
        self.minor = minor
        self.build = build
        self.servicePackBuild = servicePackBuild
        self.editionId = editionId
        self.installationType = installationType
        self.totalBytes = totalBytes
        self.languages = languages
    }

    public var versionString: String {
        "\(major).\(minor).\(build).\(servicePackBuild)"
    }

    public var summary: String {
        let langText = languages.isEmpty ? "" : " · \(languages.joined(separator: ", "))"
        return "\(name) · \(architecture.rawValue.uppercased()) · Build \(build).\(servicePackBuild)\(langText)"
    }

    public var isSupported: Bool {
        index > 0 && totalBytes > 0 && major == 10 && build >= 22621 &&
        installationType.caseInsensitiveCompare("Client") == .orderedSame
    }

    public func validate() throws {
        guard isSupported else {
            throw Tiny11Error.unsupportedImage(
                "仅支持 Windows 11 客户端镜像（Build 22621 / 22H2 及以上，ARM64 或 x64）。当前镜像为 \(name) (Build \(build), \(installationType))。"
            )
        }
    }
}

public struct MediaInspection: Sendable, Equatable {
    public let sourcePath: String
    public let isDirectory: Bool
    public let installFileRelativePath: String
    public let installFileBytes: Int64
    public let bootWimRelativePath: String
    public let efiBootRelativePath: String
    public let biosBootRelativePath: String?
    public let hasNetFx3Payload: Bool
    public let images: [WindowsImage]
    public let recommendedIndex: Int

    public init(
        sourcePath: String,
        isDirectory: Bool,
        installFileRelativePath: String,
        installFileBytes: Int64,
        bootWimRelativePath: String,
        efiBootRelativePath: String,
        biosBootRelativePath: String?,
        hasNetFx3Payload: Bool,
        images: [WindowsImage],
        recommendedIndex: Int
    ) {
        self.sourcePath = sourcePath
        self.isDirectory = isDirectory
        self.installFileRelativePath = installFileRelativePath
        self.installFileBytes = installFileBytes
        self.bootWimRelativePath = bootWimRelativePath
        self.efiBootRelativePath = efiBootRelativePath
        self.biosBootRelativePath = biosBootRelativePath
        self.hasNetFx3Payload = hasNetFx3Payload
        self.images = images
        self.recommendedIndex = recommendedIndex
    }
}

public struct BuildRecipe: Codable, Sendable, Equatable {
    public var schemaVersion: Int = 1
    public var sourcePath: String
    public var imageIndex: Int
    public var workspacePath: String
    public var outputPath: String
    public var mode: BuildMode
    public var coreFlavor: Bool
    public var coreAcknowledged: Bool
    public var compression: CompressionMode
    public var selectedOptions: [String]
    public var enableNetFx3: Bool
    public var compactInstallation: Bool
    public var preferLocalAccount: Bool
    public var removeRedundantData: Bool
    public var omitNetFx3Payload: Bool
    public var keepWorkingFiles: Bool

    public init(
        sourcePath: String = "",
        imageIndex: Int = 1,
        workspacePath: String = BuildRecipe.defaultWorkspacePath(),
        outputPath: String = "",
        mode: BuildMode = .macVM,
        coreFlavor: Bool = false,
        coreAcknowledged: Bool = false,
        compression: CompressionMode = .recoveryESD,
        selectedOptions: [String] = CleanupCatalog.optionIds(for: .macVM),
        enableNetFx3: Bool = false,
        compactInstallation: Bool = true,
        preferLocalAccount: Bool = true,
        removeRedundantData: Bool = true,
        omitNetFx3Payload: Bool = false,
        keepWorkingFiles: Bool = false
    ) {
        self.sourcePath = sourcePath
        self.imageIndex = imageIndex
        self.workspacePath = workspacePath
        self.outputPath = outputPath
        self.mode = mode
        self.coreFlavor = coreFlavor
        self.coreAcknowledged = coreAcknowledged
        self.compression = compression
        self.selectedOptions = selectedOptions
        self.enableNetFx3 = enableNetFx3
        self.compactInstallation = compactInstallation
        self.preferLocalAccount = preferLocalAccount
        self.removeRedundantData = removeRedundantData
        self.omitNetFx3Payload = omitNetFx3Payload
        self.keepWorkingFiles = keepWorkingFiles
    }

    public static func defaultWorkspacePath() -> String {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Application Support")
        return appSupport.appendingPathComponent("Tiny11Builder/Workspace").path
    }

    public var effectiveCore: Bool {
        mode == .tiny11Core || (mode == .custom && coreFlavor)
    }

    public func validate() throws {
        guard schemaVersion == 1 else {
            throw Tiny11Error.validationFailed("不支持的配方版本：\(schemaVersion)。")
        }
        guard !sourcePath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Tiny11Error.validationFailed("请先选择有效的 Windows 11 ISO 文件或解压后的安装目录。")
        }
        guard imageIndex >= 1 else {
            throw Tiny11Error.validationFailed("镜像版本索引无效：\(imageIndex)。")
        }
        guard !workspacePath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Tiny11Error.validationFailed("请指定有效的工作缓存目录。")
        }
        guard !outputPath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              outputPath.lowercased().hasSuffix(".iso") else {
            throw Tiny11Error.validationFailed("输出路径必须是新的 .iso 文件路径。")
        }
        if FileManager.default.fileExists(atPath: outputPath) {
            throw Tiny11Error.validationFailed("输出 ISO 文件已存在（不会覆盖已有文件）：\(outputPath)")
        }
        let cleanSource = URL(fileURLWithPath: sourcePath).standardizedFileURL.path
        let cleanOutput = URL(fileURLWithPath: outputPath).standardizedFileURL.path
        if cleanSource == cleanOutput {
            throw Tiny11Error.validationFailed("输出文件不能与源镜像路径相同。")
        }
        if effectiveCore && !coreAcknowledged {
            throw Tiny11Error.validationFailed("使用 Tiny11 Core 裁剪必须先确认已知悉失去系统更新、恢复环境与 Defender 防护的风险。")
        }
        let validIds = Set(CleanupCatalog.options.map(\.id))
        for optionId in selectedOptions where !validIds.contains(optionId) {
            throw Tiny11Error.validationFailed("包含未知的清理选项 ID：\(optionId)")
        }
    }
}

public enum BuildOperationState: String, Codable, Sendable {
    case pending
    case running
    case completed
    case skipped
    case failed
    case cancelled
}

public enum BuildPhaseId: String, Codable, CaseIterable, Sendable, Identifiable {
    case prepareMedia = "prepare"
    case exportEdition = "export"
    case modifyRegistry = "registry"
    case pruneImage = "prune"
    case configureBoot = "boot"
    case compressImage = "compress"
    case createISO = "iso"
    case verifyOutput = "verify"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .prepareMedia: return "1. 解包与暂存安装介质"
        case .exportEdition: return "2. 导出单版本工作镜像"
        case .modifyRegistry: return "3. 注入离线注册表策略与防重装锁"
        case .pruneImage: return "4. 流式裁剪预装应用与冗余文件"
        case .configureBoot: return "5. 配置应答文件与引导环境"
        case .compressImage: return "6. 多核压缩最终系统镜像"
        case .createISO: return "7. 封装 UEFI/UDF 可引导 ISO"
        case .verifyOutput: return "8. 校验结构与生成报告"
        }
    }

    public var symbolName: String {
        switch self {
        case .prepareMedia: return "opticaldisc"
        case .exportEdition: return "square.and.arrow.down.on.square"
        case .modifyRegistry: return "slider.horizontal.3"
        case .pruneImage: return "scissors"
        case .configureBoot: return "gearshape.2"
        case .compressImage: return "archivebox"
        case .createISO: return "externaldrive.badge.checkmark"
        case .verifyOutput: return "checkmark.shield"
        }
    }
}

public struct BuildProgressEvent: Sendable, Equatable {
    public let phase: BuildPhaseId
    public let operationId: String
    public let message: String
    public let state: BuildOperationState
    public let percent: Double?
    public let detail: String?

    public init(
        phase: BuildPhaseId,
        operationId: String,
        message: String,
        state: BuildOperationState,
        percent: Double? = nil,
        detail: String? = nil
    ) {
        self.phase = phase
        self.operationId = operationId
        self.message = message
        self.state = state
        self.percent = percent
        self.detail = detail
    }
}

public struct BuildResult: Codable, Sendable, Equatable {
    public let isoPath: String
    public let sha256: String
    public let outputBytes: Int64
    public let sourceBytes: Int64
    public let durationSeconds: Double
    public let reportPath: String
    public let workDirectory: String
    public let removedEntriesCount: Int
    public let deprovisionedAppsCount: Int
    public let appliedPoliciesCount: Int
    public let warnings: [String]

    public init(
        isoPath: String,
        sha256: String,
        outputBytes: Int64,
        sourceBytes: Int64,
        durationSeconds: Double,
        reportPath: String,
        workDirectory: String,
        removedEntriesCount: Int,
        deprovisionedAppsCount: Int,
        appliedPoliciesCount: Int,
        warnings: [String]
    ) {
        self.isoPath = isoPath
        self.sha256 = sha256
        self.outputBytes = outputBytes
        self.sourceBytes = sourceBytes
        self.durationSeconds = durationSeconds
        self.reportPath = reportPath
        self.workDirectory = workDirectory
        self.removedEntriesCount = removedEntriesCount
        self.deprovisionedAppsCount = deprovisionedAppsCount
        self.appliedPoliciesCount = appliedPoliciesCount
        self.warnings = warnings
    }
}

public enum Tiny11Error: LocalizedError, Sendable {
    case toolMissing(String)
    case validationFailed(String)
    case unsupportedImage(String)
    case invalidMedia(String)
    case processFailed(executable: String, exitCode: Int32, output: String)
    case registryError(String)
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .toolMissing(let detail):
            return "缺少必要的底层镜像工具：\(detail)"
        case .validationFailed(let detail):
            return detail
        case .unsupportedImage(let detail):
            return detail
        case .invalidMedia(let detail):
            return detail
        case .processFailed(let executable, let exitCode, let output):
            let trimmed = output.trimmingCharacters(in: .whitespacesAndNewlines)
            let suffix = trimmed.isEmpty ? "" : "\n\(trimmed.suffix(600))"
            return "命令执行失败 (\(URL(fileURLWithPath: executable).lastPathComponent), 退出码 \(exitCode))。\(suffix)"
        case .registryError(let detail):
            return "离线注册表操作失败：\(detail)"
        case .cancelled:
            return "操作已安全取消。"
        }
    }
}
