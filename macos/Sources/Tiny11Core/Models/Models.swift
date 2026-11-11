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
    public let customOnly: Bool
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
        customOnly: Bool = false,
        targets: [String] = []
    ) {
        self.id = id
        self.categoryId = categoryId
        self.kind = kind
        self.macVMDefault = macVMDefault
        self.tiny11Default = tiny11Default
        self.coreDefault = coreDefault
        self.customOnly = customOnly
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
    public var shrinkBootImage: Bool
    public var isoSizeLimitBytes: Int64?

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
        keepWorkingFiles: Bool = false,
        shrinkBootImage: Bool = false,
        isoSizeLimitBytes: Int64? = nil
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
        self.shrinkBootImage = shrinkBootImage
        self.isoSizeLimitBytes = isoSizeLimitBytes
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
        case shrinkBootImage
        case isoSizeLimitBytes
    }

    private enum UpstreamPascalKeys: String, CodingKey {
        case schemaVersion = "SchemaVersion"
        case sourcePath = "SourcePath"
        case imageIndex = "ImageIndex"
        case workspacePath = "WorkspacePath"
        case outputPath = "OutputPath"
        case mode = "Mode"
        case flavor = "Flavor"
        case coreAcknowledged = "CoreAcknowledged"
        case compression = "Compression"
        case selectedOptions = "SelectedOptions"
        case enableNetFx3 = "EnableNetFx3"
        case compactInstallation = "CompactInstallation"
        case preferLocalAccount = "PreferLocalAccount"
        case removeRedundantData = "RemoveRedundantData"
        case omitNetFx3SetupPayload = "OmitNetFx3SetupPayload"
        case keepWorkingFiles = "KeepWorkingFiles"
        case shrinkBootImage = "ShrinkBootImage"
        case isoSizeLimitBytes = "IsoSizeLimitBytes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let pascal = try decoder.container(keyedBy: UpstreamPascalKeys.self)

        self.schemaVersion = try container.decodeIfPresent(Int.self, forKey: .schemaVersion)
            ?? (try pascal.decodeIfPresent(Int.self, forKey: .schemaVersion))
            ?? 1
        self.sourcePath = try container.decodeIfPresent(String.self, forKey: .sourcePath)
            ?? (try pascal.decodeIfPresent(String.self, forKey: .sourcePath))
            ?? ""
        self.imageIndex = try container.decodeIfPresent(Int.self, forKey: .imageIndex)
            ?? (try pascal.decodeIfPresent(Int.self, forKey: .imageIndex))
            ?? 1
        let decodedWorkspace = try container.decodeIfPresent(String.self, forKey: .workspacePath)
            ?? (try pascal.decodeIfPresent(String.self, forKey: .workspacePath))
            ?? ""
        self.workspacePath = decodedWorkspace.isEmpty ? BuildRecipe.defaultWorkspacePath() : decodedWorkspace
        self.outputPath = try container.decodeIfPresent(String.self, forKey: .outputPath)
            ?? (try pascal.decodeIfPresent(String.self, forKey: .outputPath))
            ?? ""

        let decodedMode = try container.decodeIfPresent(BuildMode.self, forKey: .mode)
            ?? (try pascal.decodeIfPresent(BuildMode.self, forKey: .mode))
            ?? .custom
        self.mode = decodedMode

        let rawOptions = try container.decodeIfPresent([String].self, forKey: .selectedOptions)
            ?? (try pascal.decodeIfPresent([String].self, forKey: .selectedOptions))
            ?? CleanupCatalog.optionIds(for: decodedMode)
        let validOptionSet = Set(CleanupCatalog.options.map(\.id))
        // Strip Windows-only DISM servicing option IDs (such as "cleanup") when importing upstream portable recipes
        self.selectedOptions = rawOptions.filter { validOptionSet.contains($0) || $0 != "cleanup" }

        self.tiny11RemoveEdge = try container.decodeIfPresent(Bool.self, forKey: .tiny11RemoveEdge)
            ?? (decodedMode == .tiny11 ? self.selectedOptions.contains("edge-files") : true)

        if let explicitCore = try container.decodeIfPresent(Bool.self, forKey: .coreFlavor) {
            self.coreFlavor = explicitCore
        } else if let upstreamFlavor = try pascal.decodeIfPresent(String.self, forKey: .flavor) {
            self.coreFlavor = upstreamFlavor.caseInsensitiveCompare("Core") == .orderedSame
        } else {
            self.coreFlavor = (decodedMode == .tiny11Core)
        }

        self.coreAcknowledged = try container.decodeIfPresent(Bool.self, forKey: .coreAcknowledged)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .coreAcknowledged))
            ?? false
        self.compression = try container.decodeIfPresent(CompressionMode.self, forKey: .compression)
            ?? (try pascal.decodeIfPresent(CompressionMode.self, forKey: .compression))
            ?? .recoveryESD
        self.enableNetFx3 = try container.decodeIfPresent(Bool.self, forKey: .enableNetFx3)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .enableNetFx3))
            ?? false
        self.compactInstallation = try container.decodeIfPresent(Bool.self, forKey: .compactInstallation)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .compactInstallation))
            ?? true
        self.preferLocalAccount = try container.decodeIfPresent(Bool.self, forKey: .preferLocalAccount)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .preferLocalAccount))
            ?? false
        self.removeRedundantData = try container.decodeIfPresent(Bool.self, forKey: .removeRedundantData)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .removeRedundantData))
            ?? true
        self.omitNetFx3Payload = try container.decodeIfPresent(Bool.self, forKey: .omitNetFx3Payload)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .omitNetFx3SetupPayload))
            ?? false
        self.keepWorkingFiles = try container.decodeIfPresent(Bool.self, forKey: .keepWorkingFiles)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .keepWorkingFiles))
            ?? false
        self.shrinkBootImage = try container.decodeIfPresent(Bool.self, forKey: .shrinkBootImage)
            ?? (try pascal.decodeIfPresent(Bool.self, forKey: .shrinkBootImage))
            ?? false
        self.isoSizeLimitBytes = try container.decodeIfPresent(Int64.self, forKey: .isoSizeLimitBytes)
            ?? (try pascal.decodeIfPresent(Int64.self, forKey: .isoSizeLimitBytes))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schemaVersion, forKey: .schemaVersion)
        try container.encode(sourcePath, forKey: .sourcePath)
        try container.encode(imageIndex, forKey: .imageIndex)
        try container.encode(workspacePath, forKey: .workspacePath)
        try container.encode(outputPath, forKey: .outputPath)
        try container.encode(mode, forKey: .mode)
        try container.encode(tiny11RemoveEdge, forKey: .tiny11RemoveEdge)
        try container.encode(coreFlavor, forKey: .coreFlavor)
        try container.encode(coreAcknowledged, forKey: .coreAcknowledged)
        try container.encode(compression, forKey: .compression)
        try container.encode(selectedOptions, forKey: .selectedOptions)
        try container.encode(enableNetFx3, forKey: .enableNetFx3)
        try container.encode(compactInstallation, forKey: .compactInstallation)
        try container.encode(preferLocalAccount, forKey: .preferLocalAccount)
        try container.encode(removeRedundantData, forKey: .removeRedundantData)
        try container.encode(omitNetFx3Payload, forKey: .omitNetFx3Payload)
        try container.encode(keepWorkingFiles, forKey: .keepWorkingFiles)
        try container.encode(shrinkBootImage, forKey: .shrinkBootImage)
        try container.encodeIfPresent(isoSizeLimitBytes, forKey: .isoSizeLimitBytes)
    }

    public static func defaultWorkspacePath() -> String {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Application Support")
        return appSupport.appendingPathComponent("Tiny11Builder/Workspace").path
    }

    public var effectiveCore: Bool {
        mode == .tiny11Core || (mode == .custom && coreFlavor)
    }

    /// Whether the build requires the legacy Windows Setup installer (`sources\setup.exe`) and interactive ProductKey UI.
    /// Matches upstream `SetupInstaller.RequiresLegacy(recipe)`.
    public var requiresLegacySetup: Bool {
        effectiveCore || selectedOptions.contains(where: { CleanupCatalog.nativePayloadOptionIds.contains($0) })
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
        if let limit = isoSizeLimitBytes, (limit < 64_000_000 || limit > 4_000_000_000) {
            throw Tiny11Error.validationFailed(L10n.invalidIsoSizeLimitError())
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
    public let bootImageBytesBefore: Int64?
    public let bootImageBytesAfter: Int64?
    public let isoSizeLimitBytes: Int64?

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
        warnings: [String],
        bootImageBytesBefore: Int64? = nil,
        bootImageBytesAfter: Int64? = nil,
        isoSizeLimitBytes: Int64? = nil
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
        self.bootImageBytesBefore = bootImageBytesBefore
        self.bootImageBytesAfter = bootImageBytesAfter
        self.isoSizeLimitBytes = isoSizeLimitBytes
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
