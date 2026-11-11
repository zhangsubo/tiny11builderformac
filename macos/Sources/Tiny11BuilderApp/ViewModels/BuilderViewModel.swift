import Foundation
import AppKit
import Observation
import Tiny11Core

public enum WizardStep: Int, CaseIterable, Identifiable, Sendable {
    case mode = 0
    case source = 1
    case customize = 2
    case settings = 3
    case review = 4
    case build = 5

    public var id: Int { rawValue }

    public var title: String {
        L10n.wizardStepTitle(rawValue)
    }

    public var subtitle: String {
        L10n.wizardStepSubtitle(rawValue)
    }

    public var iconName: String {
        switch self {
        case .mode: return "sparkles.rectangle.stack"
        case .source: return "opticaldisc.fill"
        case .customize: return "checklist"
        case .settings: return "slider.horizontal.2.square"
        case .review: return "doc.text.magnifyingglass"
        case .build: return "hammer.fill"
        }
    }
}

@MainActor
@Observable
public final class StageStatusRow: Identifiable {
    public let phase: BuildPhaseId
    public var state: BuildOperationState = .pending
    public var message: String
    public var percent: Double? = nil
    public var detail: String? = nil

    public nonisolated var id: String { phase.id }

    public init(phase: BuildPhaseId) {
        self.phase = phase
        self.message = L10n.stageWaiting()
    }

    public func reset() {
        state = .pending
        message = L10n.stageWaiting()
        percent = nil
        detail = nil
    }
}

@MainActor
@Observable
public final class BuilderViewModel {
    public let language: AppLanguage = L10n.currentLanguage
    public var currentStep: WizardStep = .mode
    public var maxReachedStep: Int = 0

    // 构建配方状态
    public var recipe: BuildRecipe = BuildRecipe()
    public var searchQuery: String = ""
    public var selectedCategory: CleanupCategory? = nil

    // 源镜像解析状态
    public var isInspecting: Bool = false
    public var inspection: MediaInspection? = nil
    public var inspectionError: String? = nil

    // Core 风险确认弹窗
    public var showCoreRiskSheet: Bool = false
    private var pendingCoreModeSwitch: Bool = false

    // 构建运行状态
    public var isBuilding: Bool = false
    public var cancelRequested: Bool = false
    public var stageRows: [StageStatusRow] = BuildPhaseId.allCases.map { StageStatusRow(phase: $0) }
    public var liveLogs: [String] = []
    public var buildResult: BuildResult? = nil
    public var buildError: String? = nil
    public var buildStartDate: Date? = nil

    // 顶部提示条
    public var bannerMessage: String? = nil
    public var bannerIsError: Bool = false

    // 工具链状态检查
    public var toolStatusText: String = ""
    public var toolsAvailable: Bool = false

    private let engine = MacBuildEngine()
    private var buildTask: Task<Void, Never>? = nil

    public init() {
        refreshToolStatus()
        updateDefaultOutputPath()
    }

    public func refreshToolStatus() {
        do {
            let loc = try BundledToolLocator.locate()
            toolsAvailable = true
            toolStatusText = loc.bundledMode
                ? L10n.toolStatusBundled()
                : L10n.toolStatusDev()
        } catch {
            toolsAvailable = false
            toolStatusText = error.localizedDescription
        }
    }

    public var selectedImage: WindowsImage? {
        inspection?.images.first(where: { $0.index == recipe.imageIndex })
    }

    public var canGoBack: Bool {
        !isBuilding && currentStep.rawValue > 0
    }

    public var canGoNext: Bool {
        guard !isBuilding && !isInspecting else { return false }
        switch currentStep {
        case .mode:
            return !recipe.effectiveCore || recipe.coreAcknowledged
        case .source:
            return selectedImage?.isSupported == true
        case .customize:
            return !recipe.effectiveCore || recipe.coreAcknowledged
        case .settings:
            return !recipe.outputPath.isEmpty && !recipe.workspacePath.isEmpty
        case .review:
            return toolsAvailable && selectedImage?.isSupported == true
        case .build:
            return false
        }
    }

    public var overallProgress: Double {
        guard !stageRows.isEmpty else { return 0 }
        var total = 0.0
        for row in stageRows {
            switch row.state {
            case .completed, .skipped:
                total += 1.0
            case .running:
                total += min(max((row.percent ?? 15.0) / 100.0, 0.05), 0.99)
            default:
                break
            }
        }
        return total / Double(stageRows.count)
    }

    // MARK: - 模式与选项操作

    public func chooseModeCard(_ mode: BuildMode) {
        if mode == .tiny11Core && !recipe.coreAcknowledged {
            pendingCoreModeSwitch = true
            showCoreRiskSheet = true
            return
        }
        applyMode(mode)
        advanceStep(to: .source)
    }

    public func applyMode(_ mode: BuildMode) {
        recipe.mode = mode
        if mode == .tiny11Core {
            recipe.coreFlavor = true
        } else if mode != .custom {
            recipe.coreFlavor = false
        }
        if mode != .custom {
            recipe.selectedOptions = CleanupCatalog.optionIds(
                for: mode,
                tiny11RemoveEdge: recipe.tiny11RemoveEdge
            )
        }
        if mode == .macVM {
            recipe.preferLocalAccount = true
            recipe.compactInstallation = true
            recipe.removeRedundantData = true
        }
        updateDefaultOutputPath()
    }

    public func setTiny11RemoveEdge(_ removeEdge: Bool, selectModeIfOnModeStep: Bool = false) {
        recipe.tiny11RemoveEdge = removeEdge
        if selectModeIfOnModeStep && currentStep == .mode && recipe.mode != .tiny11 {
            applyMode(.tiny11)
            return
        }
        if recipe.mode == .tiny11 {
            recipe.selectedOptions = CleanupCatalog.optionIds(
                for: .tiny11,
                tiny11RemoveEdge: removeEdge
            )
        }
    }

    public func confirmCoreRisk() {
        recipe.coreAcknowledged = true
        showCoreRiskSheet = false
        if pendingCoreModeSwitch {
            pendingCoreModeSwitch = false
            applyMode(.tiny11Core)
            advanceStep(to: .source)
        } else {
            recipe.coreFlavor = true
            recipe.enableNetFx3 = false
            updateDefaultOutputPath()
        }
    }

    public func cancelCoreRisk() {
        pendingCoreModeSwitch = false
        showCoreRiskSheet = false
        if recipe.mode != .tiny11Core {
            recipe.coreFlavor = false
        }
    }

    public func requestCustomCoreToggle(_ enabled: Bool) {
        if enabled && !recipe.coreAcknowledged {
            pendingCoreModeSwitch = false
            showCoreRiskSheet = true
        } else {
            recipe.coreFlavor = enabled
            if enabled { recipe.enableNetFx3 = false }
            updateDefaultOutputPath()
        }
    }

    public func isOptionSelected(_ id: String) -> Bool {
        recipe.selectedOptions.contains(id)
    }

    public func toggleOption(_ id: String, isOn: Bool) {
        if recipe.mode == .tiny11 && id == "edge-files" {
            setTiny11RemoveEdge(isOn)
            return
        }
        // 若用户在预设模式下手动改动其他开关，自动平滑转为 Custom 模式并保留原有勾选项
        if recipe.mode != .custom {
            recipe.coreFlavor = (recipe.mode == .tiny11Core)
            recipe.mode = .custom
        }
        var set = Set(recipe.selectedOptions)
        if isOn {
            set.insert(id)
        } else {
            set.remove(id)
        }
        recipe.selectedOptions = CleanupCatalog.options.map(\.id).filter { set.contains($0) }
    }

    public var filteredOptions: [CleanupOption] {
        CleanupCatalog.options.filter { opt in
            let matchCategory = (selectedCategory == nil || opt.categoryId == selectedCategory)
            let q = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
            let matchQuery = q.isEmpty
                || opt.title.localizedCaseInsensitiveContains(q)
                || opt.description.localizedCaseInsensitiveContains(q)
                || opt.id.localizedCaseInsensitiveContains(q)
            return matchCategory && matchQuery
        }
    }

    // MARK: - 步骤跳转

    public func advanceStep(to target: WizardStep? = nil) {
        let nextRaw = target?.rawValue ?? (currentStep.rawValue + 1)
        guard let step = WizardStep(rawValue: min(nextRaw, WizardStep.allCases.count - 1)) else { return }
        currentStep = step
        maxReachedStep = max(maxReachedStep, step.rawValue)
    }

    public func goBack() {
        guard canGoBack, let prev = WizardStep(rawValue: currentStep.rawValue - 1) else { return }
        currentStep = prev
    }

    public func jumpToStep(_ step: WizardStep) {
        guard !isBuilding, step.rawValue <= maxReachedStep else { return }
        currentStep = step
    }

    // MARK: - 本地镜像选择与解析

    public func pickSourceISO() {
        let panel = NSOpenPanel()
        panel.title = L10n.pickSourcePanelTitle()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.diskImage, .folder]
        if panel.runModal() == .OK, let url = panel.url {
            loadSource(url: url)
        }
    }

    public func loadSource(url: URL) {
        let path = url.standardizedFileURL.path
        recipe.sourcePath = path
        inspection = nil
        inspectionError = nil
        isInspecting = true
        bannerMessage = nil

        Task {
            do {
                let result = try await engine.inspectMedia(sourcePath: path)
                self.inspection = result
                self.recipe.imageIndex = result.recommendedIndex
                if !result.hasNetFx3Payload {
                    self.recipe.enableNetFx3 = false
                }
                self.updateDefaultOutputPath()
                self.isInspecting = false
            } catch {
                self.inspectionError = error.localizedDescription
                self.isInspecting = false
            }
        }
    }

    public func pickOutputISO() {
        let panel = NSSavePanel()
        panel.title = L10n.pickOutputPanelTitle()
        let currentURL = URL(fileURLWithPath: recipe.outputPath)
        panel.nameFieldStringValue = currentURL.lastPathComponent.isEmpty ? "Tiny11-Mac.iso" : currentURL.lastPathComponent
        panel.directoryURL = currentURL.deletingLastPathComponent()
        if panel.runModal() == .OK, let url = panel.url {
            var finalPath = url.path
            if !finalPath.lowercased().hasSuffix(".iso") {
                finalPath += ".iso"
            }
            recipe.outputPath = finalPath
        }
    }

    public func pickWorkspaceFolder() {
        let panel = NSOpenPanel()
        panel.title = L10n.pickWorkspacePanelTitle()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url {
            recipe.workspacePath = url.path
        }
    }

    public func updateDefaultOutputPath() {
        let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads")
        let archTag = selectedImage?.architecture.rawValue.uppercased() ?? "ARM64"
        let buildTag = selectedImage.map { "-\($0.build)" } ?? ""
        let modeTag = recipe.effectiveCore ? "Tiny11Core" : (recipe.mode == .macVM ? "Tiny11VM" : "Tiny11")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMdd-HHmm"
        let stamp = formatter.string(from: Date())
        let filename = "\(modeTag)-\(archTag)\(buildTag)-\(stamp).iso"
        recipe.outputPath = downloads.appendingPathComponent(filename).path
    }

    // MARK: - 配方导入导出

    public func exportRecipe() {
        let panel = NSSavePanel()
        panel.title = L10n.exportRecipePanelTitle()
        panel.nameFieldStringValue = "tiny11-recipe.json"
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let data = try encoder.encode(recipe)
                try data.write(to: url)
                showBanner(L10n.recipeExportedBanner(url.lastPathComponent), isError: false)
            } catch {
                showBanner(L10n.recipeExportFailedBanner(error.localizedDescription), isError: true)
            }
        }
    }

    public func importRecipe() {
        let panel = NSOpenPanel()
        panel.title = L10n.importRecipePanelTitle()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try Data(contentsOf: url)
                let loaded = try JSONDecoder().decode(BuildRecipe.self, from: data)
                self.recipe = loaded
                if !loaded.sourcePath.isEmpty && FileManager.default.fileExists(atPath: loaded.sourcePath) {
                    loadSource(url: URL(fileURLWithPath: loaded.sourcePath))
                }
                showBanner(L10n.recipeImportedBanner(url.lastPathComponent), isError: false)
            } catch {
                showBanner(L10n.recipeImportFailedBanner(error.localizedDescription), isError: true)
            }
        }
    }

    // MARK: - 启动与安全取消构建

    public func startBuild() {
        refreshToolStatus()
        if FileManager.default.fileExists(atPath: recipe.outputPath) {
            updateDefaultOutputPath()
        }
        do {
            try recipe.validate()
        } catch {
            showBanner(error.localizedDescription, isError: true)
            return
        }

        advanceStep(to: .build)
        for row in stageRows { row.reset() }
        liveLogs.removeAll()
        buildResult = nil
        buildError = nil
        cancelRequested = false
        isBuilding = true
        buildStartDate = Date()
        bannerMessage = nil

        let snapshotRecipe = recipe
        let localEngine = engine
        buildTask = Task { [weak self] in
            do {
                let res = try await localEngine.build(
                    recipe: snapshotRecipe,
                    onProgress: { [weak self] event in
                        Task { @MainActor [weak self] in
                            self?.handleProgress(event)
                        }
                    },
                    onLog: { [weak self] line in
                        Task { @MainActor [weak self] in
                            self?.appendLog(line)
                        }
                    }
                )
                guard let self else { return }
                self.buildResult = res
                self.isBuilding = false
                self.cancelRequested = false
            } catch {
                guard let self else { return }
                self.buildError = error.localizedDescription
                self.isBuilding = false
                self.cancelRequested = false
                let wasCancelled = (error as? Tiny11Error)?.isCancelledError == true || error is CancellationError
                for row in self.stageRows where row.state == .running {
                    row.state = wasCancelled ? .cancelled : .failed
                }
            }
        }
    }

    public func cancelBuild() {
        guard isBuilding, !cancelRequested else { return }
        cancelRequested = true
        appendLog(L10n.cancelBuildLogLine())
        buildTask?.cancel()
    }

    public func revealInFinder(path: String) {
        let url = URL(fileURLWithPath: path)
        if FileManager.default.fileExists(atPath: path) {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        } else {
            NSWorkspace.shared.open(url.deletingLastPathComponent())
        }
    }

    public func copyToPasteboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        showBanner(L10n.copiedToClipboardBanner(), isError: false)
    }

    private func handleProgress(_ event: BuildProgressEvent) {
        guard let row = stageRows.first(where: { $0.phase == event.phase }) else { return }
        row.state = event.state
        row.message = event.message
        if let pct = event.percent {
            row.percent = pct
        }
        if let detail = event.detail {
            row.detail = detail
        }
    }

    private func appendLog(_ line: String) {
        liveLogs.append(line)
        if liveLogs.count > 600 {
            liveLogs.removeFirst(liveLogs.count - 600)
        }
    }

    public func showBanner(_ message: String, isError: Bool) {
        bannerMessage = message
        bannerIsError = isError
    }
}
