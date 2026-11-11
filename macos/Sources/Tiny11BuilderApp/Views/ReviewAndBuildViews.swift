import SwiftUI
import Tiny11Core

struct ReviewView: View {
    @Bindable var vm: BuilderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.reviewViewTitle())
                    .font(.title2.bold())
                Text(L10n.reviewViewSubtitle())
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                ReviewCard(title: L10n.reviewTargetCardTitle(), icon: "opticaldisc") {
                    if let img = vm.selectedImage {
                        ReviewRow(label: L10n.reviewOsNameLabel(), value: img.name)
                        ReviewRow(label: L10n.reviewArchLabel(), value: img.architecture.displayName)
                        ReviewRow(label: L10n.reviewVersionLabel(), value: img.versionString)
                        ReviewRow(
                            label: L10n.reviewLanguageLabel(),
                            value: img.languages.isEmpty ? L10n.reviewDefaultLanguage() : img.languages.joined(separator: ", ")
                        )
                    } else {
                        Text(L10n.reviewNoSourceSelected()).foregroundStyle(.red)
                    }
                }

                ReviewCard(title: L10n.reviewCleanupCardTitle(), icon: "scissors") {
                    ReviewRow(label: L10n.reviewModeLabel(), value: vm.recipe.mode.title)
                    ReviewRow(label: L10n.reviewEnabledRulesLabel(), value: L10n.reviewEnabledRulesValue(vm.recipe.selectedOptions.count))
                    ReviewRow(
                        label: L10n.reviewEdgeLabel(),
                        value: L10n.reviewEdgeValue(
                            removeEdgeFiles: vm.recipe.selectedOptions.contains("edge-files"),
                            suppressEdgePromos: vm.recipe.selectedOptions.contains("edge")
                        )
                    )
                    ReviewRow(label: L10n.reviewCoreLabel(), value: L10n.reviewCoreValue(vm.recipe.effectiveCore))
                    ReviewRow(
                        label: L10n.reviewHardwareBypassLabel(),
                        value: L10n.reviewHardwareBypassValue(vm.recipe.selectedOptions.contains("hardware-bypass"))
                    )
                }

                ReviewCard(title: L10n.reviewInstallCardTitle(), icon: "archivebox") {
                    ReviewRow(label: L10n.reviewCompressionLabel(), value: vm.recipe.compression.title)
                    ReviewRow(label: L10n.reviewLocalAccountLabel(), value: L10n.reviewLocalAccountValue(vm.recipe.preferLocalAccount))
                    ReviewRow(label: L10n.reviewCompactOsLabel(), value: L10n.reviewOnOffValue(vm.recipe.compactInstallation))
                    ReviewRow(
                        label: L10n.reviewNetFx3Label(),
                        value: L10n.reviewNetFx3Value(enable: vm.recipe.enableNetFx3, omitPayload: vm.recipe.omitNetFx3Payload)
                    )
                }

                ReviewCard(title: L10n.reviewPathsCardTitle(), icon: "folder") {
                    ReviewRow(label: L10n.reviewSourceLabel(), value: URL(fileURLWithPath: vm.recipe.sourcePath).lastPathComponent, forceLTR: true)
                    ReviewRow(label: L10n.reviewOutputLabel(), value: vm.recipe.outputPath, forceLTR: true)
                    ReviewRow(label: L10n.reviewWorkspaceLabel(), value: vm.recipe.workspacePath, forceLTR: true)
                    ReviewRow(label: L10n.reviewToolsLabel(), value: L10n.reviewToolsValue(vm.toolsAvailable))
                }
            }

            if vm.recipe.effectiveCore {
                GroupBox {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text(L10n.reviewCoreWarningBanner())
                            .font(.callout)
                    }
                    .padding(4)
                }
            }
        }
    }
}

private struct ReviewCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                Label(title, systemImage: icon)
                    .font(.headline)
                Divider()
                content
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

private struct ReviewRow: View {
    let label: String
    let value: String
    var forceLTR: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 118, alignment: .leading)
            Text(value)
                .font(.caption.weight(.medium))
                .lineLimit(2)
                .truncationMode(.middle)
                .environment(\.layoutDirection, forceLTR ? .leftToRight : (L10n.currentLanguage.isRTL ? .rightToLeft : .leftToRight))
            Spacer(minLength: 0)
        }
    }
}

struct BuildProgressView: View {
    @Bindable var vm: BuilderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // 顶部总进度卡片
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(headerTitle)
                                .font(.title3.bold())
                            Text(headerSubtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if vm.isBuilding {
                            Button(role: .destructive) {
                                vm.cancelBuild()
                            } label: {
                                Label(L10n.cancelBuildButton(cancelRequested: vm.cancelRequested), systemImage: "stop.circle.fill")
                            }
                            .disabled(vm.cancelRequested)
                        }
                    }

                    ProgressView(value: vm.buildResult != nil ? 1.0 : vm.overallProgress)
                        .progressViewStyle(.linear)
                        .tint(vm.buildError != nil ? .red : (vm.buildResult != nil ? .green : .accentColor))
                }
                .padding(8)
            }

            // 构建完成庆祝与摘要面板
            if let res = vm.buildResult {
                GroupBox {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.title)
                                .foregroundStyle(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(L10n.buildCompleteBannerTitle())
                                    .font(.headline)
                                Text(res.isoPath)
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                                    .environment(\.layoutDirection, .leftToRight)
                            }
                            Spacer()
                            Button {
                                vm.revealInFinder(path: res.isoPath)
                            } label: {
                                Label(L10n.revealInFinderButton(), systemImage: "folder.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        Divider()

                        HStack(spacing: 24) {
                            StatPill(
                                label: L10n.statOutputSizeLabel(),
                                value: L10n.formatBytes(res.outputBytes)
                            )
                            if res.sourceBytes > res.outputBytes {
                                let savedPct = Int(((Double(res.sourceBytes - res.outputBytes)) / Double(res.sourceBytes)) * 100)
                                StatPill(
                                    label: L10n.statSavedVsSourceLabel(),
                                    value: "-\(L10n.formatBytes(res.sourceBytes - res.outputBytes)) (\(savedPct)%)"
                                )
                            }
                            StatPill(
                                label: L10n.statRemovedAndLockedLabel(),
                                value: L10n.statRemovedAndLockedValue(removed: res.removedEntriesCount, locked: res.deprovisionedAppsCount)
                            )
                            StatPill(
                                label: L10n.statDurationLabel(),
                                value: L10n.statDurationValue(res.durationSeconds)
                            )
                        }

                        HStack(spacing: 8) {
                            Text("SHA-256: \(res.sha256)")
                                .font(.caption2.monospaced())
                                .foregroundStyle(.secondary)
                                .textSelection(.enabled)
                                .environment(\.layoutDirection, .leftToRight)
                            Button(L10n.copyChecksumButton()) {
                                vm.copyToPasteboard(res.sha256)
                            }
                            .controlSize(.mini)
                            Spacer()
                            Button(L10n.openLogDirButton()) {
                                vm.revealInFinder(path: res.workDirectory)
                            }
                            .controlSize(.small)
                        }
                    }
                    .padding(8)
                }
            }

            if let err = vm.buildError {
                GroupBox {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundStyle(.red)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(L10n.buildFailedTitle())
                                .font(.headline)
                            Text(err)
                                .font(.callout)
                                .textSelection(.enabled)
                        }
                        Spacer()
                        Button(L10n.editSettingsRetryButton()) {
                            vm.advanceStep(to: .review)
                        }
                    }
                    .padding(6)
                }
            }

            // 八阶段状态明细
            GroupBox(L10n.pipelineStagesBoxTitle()) {
                VStack(spacing: 8) {
                    ForEach(vm.stageRows) { row in
                        HStack(spacing: 12) {
                            stageIcon(for: row.state)
                                .frame(width: 20)
                            Text(row.phase.title)
                                .font(.subheadline.weight(.medium))
                            Spacer()
                            Text(row.detail ?? row.message)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(6)
            }

            // 实时滚动终端日志
            GroupBox(L10n.liveEngineLogBoxTitle()) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 3) {
                            ForEach(Array(vm.liveLogs.enumerated()), id: \.offset) { idx, line in
                                Text(line)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                    .textSelection(.enabled)
                                    .id(idx)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(6)
                    }
                    .frame(height: 170)
                    .background(Color(nsColor: .textBackgroundColor), in: RoundedRectangle(cornerRadius: 6))
                    .environment(\.layoutDirection, .leftToRight)
                    .onChange(of: vm.liveLogs.count) { _, newCount in
                        if newCount > 0 {
                            proxy.scrollTo(newCount - 1, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }

    private var headerTitle: String {
        L10n.buildHeaderTitle(
            isBuilding: vm.isBuilding,
            cancelRequested: vm.cancelRequested,
            hasResult: vm.buildResult != nil,
            hasError: vm.buildError != nil
        )
    }

    private var headerSubtitle: String {
        if let running = vm.stageRows.first(where: { $0.state == .running }) {
            return running.message
        }
        if vm.buildResult != nil {
            return L10n.buildSubtitleSucceeded()
        }
        return L10n.buildSubtitleReadOnly()
    }

    @ViewBuilder
    private func stageIcon(for state: BuildOperationState) -> some View {
        switch state {
        case .pending:
            Image(systemName: "circle.dotted")
                .foregroundStyle(.tertiary)
        case .running:
            ProgressView()
                .controlSize(.small)
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .skipped:
            Image(systemName: "arrow.uturn.right.circle")
                .foregroundStyle(.secondary)
        case .failed:
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
        case .cancelled:
            Image(systemName: "minus.circle.fill")
                .foregroundStyle(.orange)
        }
    }
}

private struct StatPill: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.bold())
        }
    }
}
