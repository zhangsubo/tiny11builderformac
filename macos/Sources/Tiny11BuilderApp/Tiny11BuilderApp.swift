import SwiftUI
import AppKit
import Tiny11Core

struct MainWizardView: View {
    @Bindable var vm: BuilderViewModel

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tiny11 Builder")
                        .font(.headline)
                    Text("for Mac Apple Silicon")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .padding(.bottom, 10)

                ForEach(WizardStep.allCases) { step in
                    let reachable = step.rawValue <= vm.maxReachedStep && !vm.isBuilding
                    let active = vm.currentStep == step
                    Button {
                        vm.jumpToStep(step)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: step.iconName)
                                .frame(width: 20)
                                .foregroundStyle(active ? Color.accentColor : (reachable ? Color.primary : Color.secondary.opacity(0.45)))
                            Text("\(step.rawValue + 1). \(step.title)")
                                .font(.subheadline.weight(active ? .semibold : .regular))
                                .foregroundStyle(active ? .primary : (reachable ? .primary : .tertiary))
                            Spacer()
                            if step.rawValue < vm.currentStep.rawValue {
                                Image(systemName: "checkmark")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(active ? Color.accentColor.opacity(0.14) : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!reachable)
                }

                Spacer()

                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Button {
                        vm.importRecipe()
                    } label: {
                        Label("导入配方 (.json)", systemImage: "square.and.arrow.down")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .disabled(vm.isBuilding)

                    Button {
                        vm.exportRecipe()
                    } label: {
                        Label("导出当前配方", systemImage: "square.and.arrow.up")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .padding(10)
            .navigationSplitViewColumnWidth(min: 200, ideal: 215, max: 240)
        } detail: {
            VStack(spacing: 0) {
                if let banner = vm.bannerMessage {
                    HStack {
                        Image(systemName: vm.bannerIsError ? "exclamationmark.triangle.fill" : "info.circle.fill")
                            .foregroundStyle(vm.bannerIsError ? .red : .blue)
                        Text(banner)
                            .font(.callout)
                        Spacer()
                        Button("关闭") { vm.bannerMessage = nil }
                            .buttonStyle(.borderless)
                            .font(.caption)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(vm.bannerIsError ? Color.red.opacity(0.1) : Color.blue.opacity(0.08))
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        stepContent
                    }
                    .padding(28)
                    .frame(maxWidth: 920, alignment: .leading)
                }

                Divider()

                // 底部操作栏
                HStack {
                    if vm.canGoBack {
                        Button {
                            vm.goBack()
                        } label: {
                            Label("上一步", systemImage: "chevron.left")
                        }
                        .keyboardShortcut("[", modifiers: [.command])
                    }

                    Spacer()

                    if vm.currentStep == .review {
                        Button {
                            vm.startBuild()
                        } label: {
                            Label("开始制作精简版 ISO", systemImage: "play.fill")
                                .padding(.horizontal, 10)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(!vm.canGoNext)
                    } else if vm.currentStep != .build {
                        Button {
                            vm.advanceStep()
                        } label: {
                            HStack(spacing: 4) {
                                Text("下一步")
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(!vm.canGoNext)
                    } else if !vm.isBuilding && vm.buildResult != nil {
                        Button("新建另一个构建") {
                            vm.updateDefaultOutputPath()
                            vm.advanceStep(to: .mode)
                        }
                        .controlSize(.large)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(.bar)
            }
        }
        .sheet(isPresented: $vm.showCoreRiskSheet) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text("确认启用 Tiny11 Core 极限裁剪？")
                        .font(.title3.bold())
                }

                Text("Tiny11 Core 会物理删除 WinSxS 组件库中的非核心文件、移除 WinRE 恢复环境，并禁用 Windows Update 与 Microsoft Defender。")
                    .font(.body)

                VStack(alignment: .leading, spacing: 6) {
                    Text("• 安装后系统无法打任何安全补丁、累计更新或开启新系统功能；")
                    Text("• 若你的目标是在 Parallels Desktop / VMware Fusion / UTM 中作为日常办公主力机，强烈建议改选「Mac 虚拟机优化版」；")
                    Text("• Core 仅适合一次性软件测试或极限低配沙盒虚拟机。")
                }
                .font(.callout)
                .foregroundStyle(.secondary)

                HStack {
                    Spacer()
                    Button("返回安全模式") {
                        vm.cancelCoreRisk()
                    }
                    .keyboardShortcut(.cancelAction)

                    Button("我已知悉风险，继续启用 Core") {
                        vm.confirmCoreRisk()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .padding(.top, 8)
            }
            .padding(24)
            .frame(width: 480)
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch vm.currentStep {
        case .mode:
            ModeSelectionView(vm: vm)
        case .source:
            SourceImportView(vm: vm)
        case .customize:
            CustomizationView(vm: vm)
        case .settings:
            SettingsView(vm: vm)
        case .review:
            ReviewView(vm: vm)
        case .build:
            BuildProgressView(vm: vm)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    var viewModel: BuilderViewModel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let vm = viewModel, vm.isBuilding else {
            return .terminateNow
        }
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "正在构建 Windows 11 镜像"
        alert.informativeText = "当前仍有镜像处理任务正在运行。请先点击「安全取消」等待临时挂载点清理完成后再退出应用。"
        alert.addButton(withTitle: "继续构建")
        alert.runModal()
        return .terminateCancel
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

@main
struct Tiny11BuilderMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var viewModel = BuilderViewModel()

    var body: some Scene {
        WindowGroup("Tiny11 Builder for Mac") {
            MainWizardView(vm: viewModel)
                .frame(minWidth: 960, minHeight: 660)
                .onAppear {
                    appDelegate.viewModel = viewModel
                }
        }
        .defaultSize(width: 1100, height: 760)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
