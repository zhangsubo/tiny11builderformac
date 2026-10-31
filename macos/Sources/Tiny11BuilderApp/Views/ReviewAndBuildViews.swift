import SwiftUI
import Tiny11Core

struct ReviewView: View {
    @Bindable var vm: BuilderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("复核构建方案")
                    .font(.title2.bold())
                Text("确认以下配置无误后，点击右下角「开始制作 ISO」启动原生流水线。")
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                ReviewCard(title: "目标系统版本", icon: "opticaldisc") {
                    if let img = vm.selectedImage {
                        ReviewRow(label: "系统名称", value: img.name)
                        ReviewRow(label: "处理器架构", value: img.architecture.displayName)
                        ReviewRow(label: "版本号", value: img.versionString)
                        ReviewRow(label: "系统语言", value: img.languages.isEmpty ? "默认" : img.languages.joined(separator: ", "))
                    } else {
                        Text("尚未选择有效的源镜像").foregroundStyle(.red)
                    }
                }

                ReviewCard(title: "精简策略概览", icon: "scissors") {
                    ReviewRow(label: "当前模式", value: vm.recipe.mode.title)
                    ReviewRow(label: "启用规则数", value: "\(vm.recipe.selectedOptions.count) 项")
                    ReviewRow(label: "Core 组件库裁剪", value: vm.recipe.effectiveCore ? "开启（不可更新系统）" : "关闭（保留更新与 Guest Tools 兼容）")
                    ReviewRow(label: "硬件限制绕过", value: vm.recipe.selectedOptions.contains("hardware-bypass") ? "已启用 (TPM/RAM/CPU)" : "未启用")
                }

                ReviewCard(title: "安装与压缩参数", icon: "archivebox") {
                    ReviewRow(label: "压缩等级", value: vm.recipe.compression.title)
                    ReviewRow(label: "本地账户直通", value: vm.recipe.preferLocalAccount ? "开启 (BypassNRO + 隐藏联网页)" : "关闭")
                    ReviewRow(label: "CompactOS 部署", value: vm.recipe.compactInstallation ? "开启" : "关闭")
                    ReviewRow(label: ".NET Framework 3.5", value: vm.recipe.enableNetFx3 ? "自动离线启用" : (vm.recipe.omitNetFx3Payload ? "不启用且省略载荷" : "按默认保留载荷"))
                }

                ReviewCard(title: "输入与输出位置", icon: "folder") {
                    ReviewRow(label: "源镜像", value: URL(fileURLWithPath: vm.recipe.sourcePath).lastPathComponent)
                    ReviewRow(label: "输出文件", value: vm.recipe.outputPath)
                    ReviewRow(label: "工作缓存", value: vm.recipe.workspacePath)
                    ReviewRow(label: "工具引擎", value: vm.toolsAvailable ? "就绪" : "缺失工具")
                }
            }

            if vm.recipe.effectiveCore {
                GroupBox {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text("注意：当前已开启 Tiny11 Core 极限裁剪。生成的系统不支持安装累计更新、安全补丁或额外语言包，建议仅在隔离的测试虚拟机中使用。")
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

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 96, alignment: .leading)
            Text(value)
                .font(.caption.weight(.medium))
                .lineLimit(2)
                .truncationMode(.middle)
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
                                Label(vm.cancelRequested ? "正在取消..." : "安全取消", systemImage: "stop.circle.fill")
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
                                Text("精简版 Windows 11 ISO 构建完成！")
                                    .font(.headline)
                                Text(res.isoPath)
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button {
                                vm.revealInFinder(path: res.isoPath)
                            } label: {
                                Label("在 Finder 中显示 ISO", systemImage: "folder.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        Divider()

                        HStack(spacing: 24) {
                            StatPill(
                                label: "输出镜像体积",
                                value: ByteCountFormatter.string(fromByteCount: res.outputBytes, countStyle: .file)
                            )
                            if res.sourceBytes > res.outputBytes {
                                let savedPct = Int(((Double(res.sourceBytes - res.outputBytes)) / Double(res.sourceBytes)) * 100)
                                StatPill(
                                    label: "相比原盘缩减",
                                    value: "-\(ByteCountFormatter.string(fromByteCount: res.sourceBytes - res.outputBytes, countStyle: .file)) (\(savedPct)%)"
                                )
                            }
                            StatPill(label: "移除条目 / 锁定应用", value: "\(res.removedEntriesCount) 处 / \(res.deprovisionedAppsCount) 款")
                            StatPill(label: "总耗时", value: String(format: "%.1f 秒", res.durationSeconds))
                        }

                        HStack(spacing: 8) {
                            Text("SHA-256: \(res.sha256)")
                                .font(.caption2.monospaced())
                                .foregroundStyle(.secondary)
                                .textSelection(.enabled)
                            Button("复制校验和") {
                                vm.copyToPasteboard(res.sha256)
                            }
                            .controlSize(.mini)
                            Spacer()
                            Button("打开日志目录") {
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
                            Text("构建未能完成")
                                .font(.headline)
                            Text(err)
                                .font(.callout)
                                .textSelection(.enabled)
                        }
                        Spacer()
                        Button("修改设置重试") {
                            vm.advanceStep(to: .review)
                        }
                    }
                    .padding(6)
                }
            }

            // 八阶段状态明细
            GroupBox("构建流水线阶段") {
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
            GroupBox("实时引擎日志") {
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
        if vm.isBuilding {
            return vm.cancelRequested ? "正在安全停止操作..." : "正在构建精简版 Windows 11 ISO..."
        }
        if vm.buildResult != nil {
            return "构建成功"
        }
        if vm.buildError != nil {
            return "构建已停止"
        }
        return "准备就绪"
    }

    private var headerSubtitle: String {
        if let running = vm.stageRows.first(where: { $0.state == .running }) {
            return running.message
        }
        if vm.buildResult != nil {
            return "可直接挂载至 Parallels Desktop、VMware Fusion、UTM 或刻录装机。"
        }
        return "源安装介质全程只读保护。"
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
