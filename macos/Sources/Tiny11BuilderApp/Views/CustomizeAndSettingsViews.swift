import SwiftUI
import Tiny11Core

struct CustomizationView: View {
    @Bindable var vm: BuilderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.customizeViewTitle())
                        .font(.title2.bold())
                    Text(
                        L10n.customizeViewSubtitle(
                            modeTitle: vm.recipe.mode.title,
                            selectedCount: vm.recipe.selectedOptions.count,
                            totalCount: CleanupCatalog.options.count
                        )
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                Spacer()
                Menu(L10n.quickPresetMenuTitle()) {
                    Button(L10n.applyMacVmPresetButton()) { vm.applyMode(.macVM) }
                    Button(L10n.applyTiny11PresetButton()) { vm.applyMode(.tiny11) }
                    Button(L10n.clearAllSelectionsButton()) { vm.applyMode(.custom) }
                }
                .fixedSize()
            }

            // 分类筛选与搜索栏
            HStack(spacing: 12) {
                Picker(L10n.categoryPickerLabel(), selection: $vm.selectedCategory) {
                    Text(L10n.allCategoriesLabel()).tag(CleanupCategory?.none)
                    ForEach(CleanupCategory.allCases) { cat in
                        Text(cat.title).tag(CleanupCategory?.some(cat))
                    }
                }
                .pickerStyle(.segmented)

                TextField(L10n.searchPlaceholder(), text: $vm.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
            }

            // 标准精简版专属 Edge 可选项
            if vm.recipe.mode == .tiny11 {
                GroupBox {
                    HStack(spacing: 12) {
                        Image(systemName: "globe")
                            .foregroundStyle(.indigo)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L10n.tiny11EdgeBoxTitle())
                                .font(.subheadline.weight(.semibold))
                            Text(L10n.tiny11EdgeBoxSubtitle())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { vm.recipe.tiny11RemoveEdge },
                            set: { vm.setTiny11RemoveEdge($0) }
                        ))
                        .toggleStyle(.switch)
                        .labelsHidden()
                    }
                    .padding(4)
                }
            }

            // Core 深度裁剪独立开关
            GroupBox {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.shield.fill")
                        .foregroundStyle(vm.recipe.effectiveCore ? .orange : .secondary)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.coreToggleBoxTitle())
                            .font(.subheadline.weight(.semibold))
                        Text(L10n.coreToggleBoxSubtitle())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { vm.recipe.effectiveCore },
                        set: { enabled in
                            if vm.recipe.mode == .tiny11Core && !enabled {
                                vm.applyMode(.macVM)
                            } else {
                                if vm.recipe.mode != .custom && enabled {
                                    vm.recipe.mode = .custom
                                }
                                vm.requestCustomCoreToggle(enabled)
                            }
                        }
                    ))
                    .toggleStyle(.switch)
                    .labelsHidden()
                }
                .padding(4)
            }

            // 规则条目列表
            VStack(spacing: 8) {
                ForEach(vm.filteredOptions) { option in
                    HStack(alignment: .center, spacing: 14) {
                        Toggle("", isOn: Binding(
                            get: { vm.isOptionSelected(option.id) },
                            set: { vm.toggleOption(option.id, isOn: $0) }
                        ))
                        .toggleStyle(.checkbox)
                        .labelsHidden()

                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 8) {
                                Text(option.title)
                                    .font(.subheadline.weight(.medium))
                                Text(option.category)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.secondary.opacity(0.12), in: Capsule())
                                    .foregroundStyle(.secondary)
                                if option.customOnly {
                                    Text(L10n.customOnlyBadge())
                                        .font(.caption2.weight(.medium))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange.opacity(0.16), in: Capsule())
                                        .foregroundStyle(.orange)
                                }
                            }
                            Text(option.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(Color(nsColor: .controlBackgroundColor), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                    )
                }
            }
        }
    }
}

struct SettingsView: View {
    @Bindable var vm: BuilderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.settingsViewTitle())
                    .font(.title2.bold())
                Text(L10n.settingsViewSubtitle())
                    .foregroundStyle(.secondary)
            }

            GroupBox(L10n.compressionBoxTitle()) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(CompressionMode.allCases) { comp in
                        Button {
                            vm.recipe.compression = comp
                        } label: {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: vm.recipe.compression == comp ? "largecircle.fill.circle" : "circle")
                                    .foregroundStyle(vm.recipe.compression == comp ? Color.accentColor : .secondary)
                                    .padding(.top, 2)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(comp.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Text(comp.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(vm.recipe.compression == comp ? Color.accentColor.opacity(0.08) : Color.clear)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(6)
            }

            GroupBox(L10n.installEnhancementsBoxTitle()) {
                VStack(alignment: .leading, spacing: 12) {
                    SettingToggleRow(
                        title: L10n.preferLocalAccountTitle(),
                        subtitle: L10n.preferLocalAccountSubtitle(),
                        isOn: $vm.recipe.preferLocalAccount
                    )
                    Divider()
                    SettingToggleRow(
                        title: L10n.compactOsTitle(),
                        subtitle: L10n.compactOsSubtitle(),
                        isOn: $vm.recipe.compactInstallation
                    )
                    Divider()
                    SettingToggleRow(
                        title: L10n.cleanCacheTitle(),
                        subtitle: L10n.cleanCacheSubtitle(),
                        isOn: $vm.recipe.removeRedundantData
                    )
                    Divider()
                    SettingToggleRow(
                        title: L10n.enableNetFx3Title(),
                        subtitle: L10n.enableNetFx3Subtitle(
                            hasPayload: vm.inspection?.hasNetFx3Payload,
                            isCore: vm.recipe.effectiveCore
                        ),
                        isOn: $vm.recipe.enableNetFx3,
                        disabled: vm.inspection?.hasNetFx3Payload == false || vm.recipe.effectiveCore
                    )
                    Divider()
                    SettingToggleRow(
                        title: L10n.omitNetFx3Title(),
                        subtitle: L10n.omitNetFx3Subtitle(),
                        isOn: $vm.recipe.omitNetFx3Payload,
                        disabled: vm.recipe.enableNetFx3
                    )
                    Divider()
                    SettingToggleRow(
                        title: L10n.shrinkBootImageTitle(),
                        subtitle: L10n.shrinkBootImageSubtitle(),
                        isOn: $vm.recipe.shrinkBootImage
                    )
                    Divider()
                    SettingToggleRow(
                        title: L10n.keepWorkingFilesTitle(),
                        subtitle: L10n.keepWorkingFilesSubtitle(),
                        isOn: $vm.recipe.keepWorkingFiles
                    )
                }
                .padding(8)
            }

            if let limit = vm.recipe.isoSizeLimitBytes {
                GroupBox {
                    HStack(spacing: 12) {
                        Image(systemName: "scalemass.fill")
                            .foregroundStyle(.orange)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L10n.isoSizeLimitBoxTitle(L10n.formatBytes(limit)))
                                .font(.subheadline.weight(.semibold))
                            Text(L10n.isoSizeLimitSubtitle())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(L10n.clearLimitButton()) {
                            vm.recipe.isoSizeLimitBytes = nil
                        }
                        .controlSize(.small)
                    }
                    .padding(6)
                }
            }

            GroupBox(L10n.pathsBoxTitle()) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.outputIsoPathLabel())
                            .font(.caption.weight(.medium))
                        HStack {
                            TextField(L10n.outputIsoPlaceholder(), text: $vm.recipe.outputPath)
                                .textFieldStyle(.roundedBorder)
                                .font(.caption.monospaced())
                                .environment(\.layoutDirection, .leftToRight)
                            Button(L10n.browseButton()) { vm.pickOutputISO() }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.workspacePathLabel())
                            .font(.caption.weight(.medium))
                        HStack {
                            TextField(L10n.workspacePlaceholder(), text: $vm.recipe.workspacePath)
                                .textFieldStyle(.roundedBorder)
                                .font(.caption.monospaced())
                                .environment(\.layoutDirection, .leftToRight)
                            Button(L10n.selectFolderButton()) { vm.pickWorkspaceFolder() }
                        }
                    }
                }
                .padding(8)
            }
        }
    }
}

private struct SettingToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    var disabled: Bool = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(disabled ? .secondary : .primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .labelsHidden()
                .disabled(disabled)
        }
    }
}
