import Foundation

public enum BuildMode: String, Codable, CaseIterable, Sendable, Identifiable {
    case macVM = "MacVM"
    case tiny11 = "Tiny11"
    case tiny11Core = "Tiny11Core"
    case custom = "Custom"

    public var id: String { rawValue }

    public var title: String {
        L10n.buildModeTitle(self)
    }

    public var badge: String? {
        L10n.buildModeBadge(self)
    }

    public var summary: String {
        L10n.buildModeSummary(self)
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
        L10n.compressionTitle(self)
    }

    public var subtitle: String {
        L10n.compressionSubtitle(self)
    }

    public var installFileName: String {
        self == .recoveryESD ? "install.esd" : "install.wim"
    }
}

public enum ImageArchitecture: String, Codable, Sendable, CaseIterable {
    case arm64 = "arm64"
    case x64 = "x64"

    public var displayName: String {
        L10n.architectureDisplayName(self)
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
    public let categoryId: CleanupCategory
    public let kind: OptionKind
    public let macVMDefault: Bool
    public let tiny11Default: Bool
    public let coreDefault: Bool
    public let targets: [String]

    public var title: String {
        L10n.optionCopy(for: id).title
    }

    public var description: String {
        L10n.optionCopy(for: id).description
    }

    public var category: String {
        categoryId.title
    }

    public func title(in lang: AppLanguage) -> String {
        L10n.optionCopy(for: id, lang: lang).title
    }

    public func description(in lang: AppLanguage) -> String {
        L10n.optionCopy(for: id, lang: lang).description
    }

    public init(
        id: String,
        categoryId: CleanupCategory,
        kind: OptionKind,
        macVMDefault: Bool,
        tiny11Default: Bool,
        coreDefault: Bool,
        targets: [String] = []
    ) {
        self.id = id
        self.categoryId = categoryId
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
                L10n.unsupportedImageError(name: name, build: build, installationType: installationType)
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
    public var tiny11RemoveEdge: Bool
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
        tiny11RemoveEdge: Bool = true,
        coreFlavor: Bool = false,
        coreAcknowledged: Bool = false,
        compression: CompressionMode = .recoveryESD,
        selectedOptions: [String]? = nil,
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
        self.tiny11RemoveEdge = tiny11RemoveEdge
        self.coreFlavor = coreFlavor
        self.coreAcknowledged = coreAcknowledged
        self.compression = compression
        self.selectedOptions = selectedOptions ?? CleanupCatalog.optionIds(for: mode, tiny11RemoveEdge: tiny11RemoveEdge)
        self.enableNetFx3 = enableNetFx3
        self.compactInstallation = compactInstallation
        self.preferLocalAccount = preferLocalAccount
        self.removeRedundantData = removeRedundantData
        self.omitNetFx3Payload = omitNetFx3Payload
        self.keepWorkingFiles = keepWorkingFiles
    }

    enum CodingKeys: String, CodingKey {
        case schemaVersion
        case sourcePath
        case imageIndex
        case workspacePath
        case outputPath
        case mode
        case tiny11RemoveEdge
        case coreFlavor
        case coreAcknowledged
        case compression
        case selectedOptions
        case enableNetFx3
        case compactInstallation
        case preferLocalAccount
        case removeRedundantData
        case omitNetFx3Payload
        case keepWorkingFiles
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.schemaVersion = try container.decodeIfPresent(Int.self, forKey: .schemaVersion) ?? 1
        self.sourcePath = try container.decode(String.self, forKey: .sourcePath)
        self.imageIndex = try container.decode(Int.self, forKey: .imageIndex)
        self.workspacePath = try container.decode(String.self, forKey: .workspacePath)
        self.outputPath = try container.decode(String.self, forKey: .outputPath)
        let decodedMode = try container.decode(BuildMode.self, forKey: .mode)
        self.mode = decodedMode
        let decodedOptions = try container.decode([String].self, forKey: .selectedOptions)
        self.selectedOptions = decodedOptions
        self.tiny11RemoveEdge = try container.decodeIfPresent(Bool.self, forKey: .tiny11RemoveEdge)
            ?? (decodedMode == .tiny11 ? decodedOptions.contains("edge-files") : true)
        self.coreFlavor = try container.decode(Bool.self, forKey: .coreFlavor)
        self.coreAcknowledged = try container.decode(Bool.self, forKey: .coreAcknowledged)
        self.compression = try container.decode(CompressionMode.self, forKey: .compression)
        self.enableNetFx3 = try container.decode(Bool.self, forKey: .enableNetFx3)
        self.compactInstallation = try container.decode(Bool.self, forKey: .compactInstallation)
        self.preferLocalAccount = try container.decode(Bool.self, forKey: .preferLocalAccount)
        self.removeRedundantData = try container.decode(Bool.self, forKey: .removeRedundantData)
        self.omitNetFx3Payload = try container.decode(Bool.self, forKey: .omitNetFx3Payload)
        self.keepWorkingFiles = try container.decode(Bool.self, forKey: .keepWorkingFiles)
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
            throw Tiny11Error.validationFailed(L10n.unsupportedSchemaError(schemaVersion))
        }
        guard !sourcePath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Tiny11Error.validationFailed(L10n.emptySourcePathError())
        }
        guard imageIndex >= 1 else {
            throw Tiny11Error.validationFailed(L10n.invalidImageIndexError(imageIndex))
        }
        guard !workspacePath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Tiny11Error.validationFailed(L10n.emptyWorkspacePathError())
        }
        guard !outputPath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              outputPath.lowercased().hasSuffix(".iso") else {
            throw Tiny11Error.validationFailed(L10n.invalidOutputPathError())
        }
        if FileManager.default.fileExists(atPath: outputPath) {
            throw Tiny11Error.validationFailed(L10n.outputFileAlreadyExistsError(outputPath))
        }
        let cleanSource = URL(fileURLWithPath: sourcePath).standardizedFileURL.path
        let cleanOutput = URL(fileURLWithPath: outputPath).standardizedFileURL.path
        if cleanSource == cleanOutput {
            throw Tiny11Error.validationFailed(L10n.outputSameAsSourceError())
        }
        if effectiveCore && !coreAcknowledged {
            throw Tiny11Error.validationFailed(L10n.coreNotAcknowledgedError())
        }
        let validIds = Set(CleanupCatalog.options.map(\.id))
        for optionId in selectedOptions where !validIds.contains(optionId) {
            throw Tiny11Error.validationFailed(L10n.unknownOptionIdError(optionId))
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
        L10n.buildPhaseTitle(self)
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
            return L10n.toolMissingError(detail)
        case .validationFailed(let detail):
            return detail
        case .unsupportedImage(let detail):
            return detail
        case .invalidMedia(let detail):
            return detail
        case .processFailed(let executable, let exitCode, let output):
            let trimmed = output.trimmingCharacters(in: .whitespacesAndNewlines)
            let suffix = trimmed.isEmpty ? "" : "\n\(trimmed.suffix(600))"
            return L10n.processFailedError(
                execName: URL(fileURLWithPath: executable).lastPathComponent,
                exitCode: exitCode,
                suffix: suffix
            )
        case .registryError(let detail):
            return L10n.registryError(detail)
        case .cancelled:
            return L10n.cancelledError()
        }
    }
}
