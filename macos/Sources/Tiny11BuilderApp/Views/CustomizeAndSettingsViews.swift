import SwiftUI
import Tiny11Core

struct CustomizationView: View {
    @Bindable var vm: BuilderViewModel

    private var allCategories: [String] {
        ["全部"] + CleanupCatalog.categories
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("组件裁剪与系统策略清单")
                        .font(.title2.bold())
                    Text("当前模式：\(vm.recipe.mode.title) · 已启用 \(vm.recipe.selectedOptions.count) / \(CleanupCatalog.options.count) 项规则（修改任意开关会自动转为自定义模式）。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Menu("快速套用预设") {
                    Button("套用 Mac 虚拟机优化预设") { vm.applyMode(.macVM) }
                    Button("套用 Tiny11 标准版预设") { vm.applyMode(.tiny11) }
                    Button("清空全部勾选") { vm.applyMode(.custom) }
                }
                .fixedSize()
            }

            // 分类筛选与搜索栏
            HStack(spacing: 12) {
                Picker("分类", selection: $vm.selectedCategory) {
                    ForEach(allCategories, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
                .pickerStyle(.segmented)

                TextField("搜索组件或策略...", text: $vm.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 210)
            }

            // Core 深度裁剪独立开关
            GroupBox {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.shield.fill")
                        .foregroundStyle(vm.recipe.effectiveCore ? .orange : .secondary)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("启用 Tiny11 Core 级不可逆组件库裁剪 (WinSxS + WinRE + 禁用更新)")
                            .font(.subheadline.weight(.semibold))
                        Text("进一步缩减数百 MB 体积，但系统将彻底无法安装安全更新、语言包或可选功能。日常主力虚拟机请保持关闭。")
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
                Text("镜像压缩率与部署选项")
                    .font(.title2.bold())
                Text("利用 Apple Silicon 多核性能压缩系统卷，并配置安装阶段体验与输出文件位置。")
                    .foregroundStyle(.secondary)
            }

            GroupBox("最终镜像压缩方式") {
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

            GroupBox("安装与虚拟机增强开关") {
                VStack(alignment: .leading, spacing: 12) {
                    SettingToggleRow(
                        title: "优先使用本地离线账户并启用断网直通 (BypassNRO)",
                        subtitle: "隐藏开机强制登录微软账号界面，彻底解决 UTM / VMware Fusion 初装缺少网卡驱动时无法跳过联网界面的死锁问题。",
                        isOn: $vm.recipe.preferLocalAccount
                    )
                    Divider()
                    SettingToggleRow(
                        title: "启用 CompactOS 紧凑系统部署",
                        subtitle: "在无人值守应答配置中启用 NTFS 透明系统文件压缩，虚拟机安装后额外节省约 2~3 GB 磁盘占用。",
                        isOn: $vm.recipe.compactInstallation
                    )
                    Divider()
                    SettingToggleRow(
                        title: "清理离线更新缓存与崩溃日志",
                        subtitle: "安全清空 SoftwareDistribution 下载缓存、临时目录与错误报告归档。",
                        isOn: $vm.recipe.removeRedundantData
                    )
                    Divider()
                    SettingToggleRow(
                        title: "部署期间自动启用 .NET Framework 3.5",
                        subtitle: vm.inspection?.hasNetFx3Payload == false
                            ? "当前导入的 ISO 不含 sources/sxs 载荷，不可用。"
                            : (vm.recipe.effectiveCore ? "Tiny11 Core 模式下不可启用可选功能。" : "从安装盘自带的 sources/sxs 离线启用传统软件所需的 .NET 2.0/3.5 运行库。"),
                        isOn: $vm.recipe.enableNetFx3,
                        disabled: vm.inspection?.hasNetFx3Payload == false || vm.recipe.effectiveCore
                    )
                    Divider()
                    SettingToggleRow(
                        title: "从输出 ISO 中省略 .NET 3.5 安装载荷 (sources/sxs)",
                        subtitle: "若不需要离线安装 .NET 3.5，省略该目录可使生成的 ISO 进一步减小约 70 MB。",
                        isOn: $vm.recipe.omitNetFx3Payload,
                        disabled: vm.recipe.enableNetFx3
                    )
                    Divider()
                    SettingToggleRow(
                        title: "构建成功后保留临时工作目录文件",
                        subtitle: "默认在发布校验通过后自动清理数 GB 的中间缓存（仅保留日志与报告）。调试排障时可开启。",
                        isOn: $vm.recipe.keepWorkingFiles
                    )
                }
                .padding(8)
            }

            GroupBox("输出 ISO 与工作缓存路径") {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("精简版 ISO 保存路径（绝不覆盖已有文件）：")
                            .font(.caption.weight(.medium))
                        HStack {
                            TextField("输出 .iso 路径", text: $vm.recipe.outputPath)
                                .textFieldStyle(.roundedBorder)
                                .font(.caption.monospaced())
                            Button("浏览...") { vm.pickOutputISO() }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("构建临时工作目录（需至少约 20 GiB 可用空间，支持普通 APFS 分区）：")
                            .font(.caption.weight(.medium))
                        HStack {
                            TextField("工作缓存目录", text: $vm.recipe.workspacePath)
                                .textFieldStyle(.roundedBorder)
                                .font(.caption.monospaced())
                            Button("选择目录...") { vm.pickWorkspaceFolder() }
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
