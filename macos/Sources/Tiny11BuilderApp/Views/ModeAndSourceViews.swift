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
                Text("选择你的 Windows 11 精简模式")
                    .font(.title2.bold())
                Text("在 Apple Silicon Mac 上无需虚拟机、无需管理员密码，流式裁剪并生成干净轻量的可引导 ISO。")
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(BuildMode.allCases) { mode in
                    ModeCard(
                        mode: mode,
                        isSelected: vm.recipe.mode == mode,
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
                        Text("全程在用户态直接操作 WIM 归档与离线注册表二进制文件，100% 隔离宿主机 macOS 系统。")
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

                Spacer(minLength: 4)

                HStack {
                    Text(isSelected ? "当前已选模式" : "点击选择并下一步")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(isSelected ? accentColor : .secondary)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(isSelected ? accentColor : .secondary.opacity(0.5))
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, minHeight: 205, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? accentColor : Color.primary.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct SourceImportView: View {
    @Bindable var vm: BuilderViewModel
    @State private var isDropTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("导入本地 Windows 11 安装镜像")
                    .font(.title2.bold())
                Text("支持 Windows 11 22H2 / 23H2 / 24H2 / 25H2 及更新版本（ARM64 或 x64 官方 ISO）。源镜像仅以只读方式读取，绝不会被修改。")
                    .foregroundStyle(.secondary)
            }

            // 拖拽与文件选择区
            VStack(spacing: 14) {
                Image(systemName: vm.isInspecting ? "arrow.triangle.2.circlepath.circle.fill" : "opticaldisc.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(isDropTargeted ? .blue : .accentColor)

                if vm.isInspecting {
                    ProgressView("正在只读挂载并解析 WIM/ESD 版本信息...")
                        .controlSize(.regular)
                } else {
                    Text("将 Windows 11 .iso 文件拖放到此处")
                        .font(.headline)
                    Text("或者点击下方按钮选择本地 .iso 镜像 / 已解压安装目录")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button {
                        vm.pickSourceISO()
                    } label: {
                        Label("选择本地 ISO 文件...", systemImage: "folder.badge.plus")
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
                GroupBox("检测到的镜像详情与版本选择") {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label(
                                "介质格式：\(info.installFileRelativePath) (\(ByteCountFormatter.string(fromByteCount: info.installFileBytes, countStyle: .file)))",
                                systemImage: "internaldrive"
                            )
                            Spacer()
                            Label(
                                info.hasNetFx3Payload ? "包含 .NET 3.5 离线包" : "不含 sxs 载荷",
                                systemImage: info.hasNetFx3Payload ? "checkmark.circle.fill" : "minus.circle"
                            )
                            .foregroundStyle(info.hasNetFx3Payload ? .green : .secondary)
                        }
                        .font(.caption)

                        Divider()

                        Picker("选择要提取并精简的 Windows 版本 (SKU)：", selection: $vm.recipe.imageIndex) {
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
                                    Text("逻辑展开大小：\(ByteCountFormatter.string(fromByteCount: selected.totalBytes, countStyle: .file)) · 将仅导出此单一版本，自动剔除其他冗余 SKU。")
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
                                    Text("提示：当前导入的是 x64 镜像。若用于 Apple Silicon 上的 Parallels Desktop 或 VMware Fusion 高速虚拟化，建议使用 ARM64 版 Windows 11 ISO；x64 镜像适用于 PC 真机装机或 UTM 跨架构模拟。")
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
