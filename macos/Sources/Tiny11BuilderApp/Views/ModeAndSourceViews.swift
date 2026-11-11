import SwiftUI
import UniformTypeIdentifiers
import Tiny11Core

struct ModeSelectionView: View {
    @Bindable var vm: BuilderViewModel

    private let columns = [
        GridItem(.flexible(minimum: 280), spacing: 16),
        GridItem(.flexible(minimum: 280), spacing: 16)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.modeViewTitle())
                    .font(.title2.bold())
                Text(L10n.modeViewSubtitle())
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(BuildMode.allCases) { mode in
                    ModeCard(
                        mode: mode,
                        isSelected: vm.recipe.mode == mode,
                        tiny11RemoveEdge: mode == .tiny11 ? Binding(
                            get: { vm.recipe.tiny11RemoveEdge },
                            set: { vm.setTiny11RemoveEdge($0, selectModeIfOnModeStep: true) }
                        ) : nil,
                        action: { vm.chooseModeCard(mode) }
                    )
                }
            }

            GroupBox {
                HStack(spacing: 12) {
                    Image(systemName: vm.toolsAvailable ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                        .foregroundStyle(vm.toolsAvailable ? .green : .orange)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(vm.toolStatusText)
                            .font(.subheadline.weight(.medium))
                        Text(L10n.engineIsolationCaption())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(4)
            }
        }
    }
}

private struct ModeCard: View {
    let mode: BuildMode
    let isSelected: Bool
    let tiny11RemoveEdge: Binding<Bool>?
    let action: () -> Void

    private var accentColor: Color {
        switch mode {
        case .macVM: return .blue
        case .tiny11: return .indigo
        case .tiny11Core: return .orange
        case .custom: return .teal
        }
    }

    private var iconName: String {
        switch mode {
        case .macVM: return "desktopcomputer.and.arrow.down"
        case .tiny11: return "sparkles"
        case .tiny11Core: return "flame.fill"
        case .custom: return "slider.horizontal.3"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Image(systemName: iconName)
                            .font(.title2)
                            .foregroundStyle(accentColor)
                            .frame(width: 36, height: 36)
                            .background(accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                        Spacer()

                        if let badge = mode.badge {
                            Text(badge)
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(accentColor.opacity(0.15), in: Capsule())
                                .foregroundStyle(accentColor)
                        }
                    }

                    Text(mode.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(mode.summary)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Spacer(minLength: 4)

            if let edgeBinding = tiny11RemoveEdge {
                HStack(spacing: 8) {
                    Image(systemName: "globe")
                        .font(.caption)
                        .foregroundStyle(accentColor)
                    Text(L10n.tiny11EdgeToggleLabel())
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Spacer(minLength: 4)
                    Toggle("", isOn: edgeBinding)
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                        .labelsHidden()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(accentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
            }

            Button(action: action) {
                HStack {
                    Text(isSelected ? L10n.modeCardSelected() : L10n.modeCardClickToSelect())
                        .font(.caption.weight(.medium))
                        .foregroundStyle(isSelected ? accentColor : .secondary)
                    Spacer()
                    Image(systemName: "arrow.forward.circle.fill")
                        .foregroundStyle(isSelected ? accentColor : .secondary.opacity(0.5))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 225, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? accentColor : Color.primary.opacity(0.1), lineWidth: isSelected ? 2 : 1)
        )
    }
}

struct SourceImportView: View {
    @Bindable var vm: BuilderViewModel
    @State private var isDropTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.sourceViewTitle())
                    .font(.title2.bold())
                Text(L10n.sourceViewSubtitle())
                    .foregroundStyle(.secondary)
            }

            // 拖拽与文件选择区
            VStack(spacing: 14) {
                Image(systemName: vm.isInspecting ? "arrow.triangle.2.circlepath.circle.fill" : "opticaldisc.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(isDropTargeted ? .blue : .accentColor)

                if vm.isInspecting {
                    ProgressView(L10n.inspectingProgressText())
                        .controlSize(.regular)
                } else {
                    Text(L10n.dropZoneHeadline())
                        .font(.headline)
                    Text(L10n.dropZoneSubheadline())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button {
                        vm.pickSourceISO()
                    } label: {
                        Label(L10n.pickLocalIsoButton(), systemImage: "folder.badge.plus")
                            .padding(.horizontal, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }

                if !vm.recipe.sourcePath.isEmpty {
                    Text(vm.recipe.sourcePath)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .padding(.horizontal, 12)
                        .environment(\.layoutDirection, .leftToRight)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isDropTargeted ? Color.accentColor.opacity(0.08) : Color(nsColor: .controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(
                        isDropTargeted ? Color.accentColor : Color.secondary.opacity(0.3),
                        style: StrokeStyle(lineWidth: isDropTargeted ? 2 : 1.5, dash: [6, 4])
                    )
            )
            .onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
                guard let first = providers.first else { return false }
                _ = first.loadObject(ofClass: URL.self) { url, _ in
                    if let url {
                        Task { @MainActor in
                            vm.loadSource(url: url)
                        }
                    }
                }
                return true
            }

            if let error = vm.inspectionError {
                GroupBox {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "xmark.octagon.fill")
                            .foregroundStyle(.red)
                        Text(error)
                            .font(.callout)
                        Spacer()
                    }
                    .padding(4)
                }
            }

            if let info = vm.inspection {
                GroupBox(L10n.detectedMediaBoxTitle()) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label(
                                L10n.mediaFormatLabel(
                                    relativePath: info.installFileRelativePath,
                                    formattedSize: L10n.formatBytes(info.installFileBytes)
                                ),
                                systemImage: "internaldrive"
                            )
                            Spacer()
                            Label(
                                info.hasNetFx3Payload ? L10n.netFx3IncludedLabel() : L10n.netFx3MissingLabel(),
                                systemImage: info.hasNetFx3Payload ? "checkmark.circle.fill" : "minus.circle"
                            )
                            .foregroundStyle(info.hasNetFx3Payload ? .green : .secondary)
                        }
                        .font(.caption)

                        Divider()

                        Picker(L10n.skuPickerLabel(), selection: $vm.recipe.imageIndex) {
                            ForEach(info.images) { img in
                                Text("\(img.index). \(img.name) (\(img.architecture.rawValue.uppercased()) · Build \(img.build).\(img.servicePackBuild))")
                                    .tag(img.index)
                            }
                        }
                        .onChange(of: vm.recipe.imageIndex) { _, _ in
                            vm.updateDefaultOutputPath()
                        }

                        if let selected = vm.selectedImage {
                            HStack(spacing: 12) {
                                Image(systemName: selected.isSupported ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .foregroundStyle(selected.isSupported ? .green : .red)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(selected.summary)
                                        .font(.subheadline.weight(.semibold))
                                    Text(L10n.logicalSizeCaption(L10n.formatBytes(selected.totalBytes)))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.top, 4)

                            if selected.architecture == .x64 && vm.recipe.mode == .macVM {
                                HStack(spacing: 8) {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundStyle(.blue)
                                    Text(L10n.x64OnMacVmTip())
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(8)
                                .background(Color.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .padding(8)
                }
            }
        }
    }
}
