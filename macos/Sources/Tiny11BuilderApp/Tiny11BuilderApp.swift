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
                    Text(L10n.sidebarSubtitle())
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
                        Label(L10n.importRecipeButton(), systemImage: "square.and.arrow.down")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .disabled(vm.isBuilding)

                    Button {
                        vm.exportRecipe()
                    } label: {
                        Label(L10n.exportRecipeButton(), systemImage: "square.and.arrow.up")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .padding(10)
            .navigationSplitViewColumnWidth(min: 210, ideal: 235, max: 270)
        } detail: {
            VStack(spacing: 0) {
                if let banner = vm.bannerMessage {
                    HStack {
                        Image(systemName: vm.bannerIsError ? "exclamationmark.triangle.fill" : "info.circle.fill")
                            .foregroundStyle(vm.bannerIsError ? .red : .blue)
                        Text(banner)
                            .font(.callout)
                        Spacer()
                        Button(L10n.closeBannerButton()) { vm.bannerMessage = nil }
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
                            Label(L10n.backButton(), systemImage: "chevron.backward")
                        }
                        .keyboardShortcut("[", modifiers: [.command])
                    }

                    Spacer()

                    if vm.currentStep == .review {
                        Button {
                            vm.startBuild()
                        } label: {
                            Label(L10n.startBuildButton(), systemImage: "play.fill")
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
                                Text(L10n.nextButton())
                                Image(systemName: "chevron.forward")
                            }
                            .padding(.horizontal, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(!vm.canGoNext)
                    } else if !vm.isBuilding && vm.buildResult != nil {
                        Button(L10n.newAnotherBuildButton()) {
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
                    Text(L10n.coreSheetTitle())
                        .font(.title3.bold())
                }

                Text(L10n.coreSheetDescription())
                    .font(.body)

                VStack(alignment: .leading, spacing: 6) {
                    Text(L10n.coreSheetBullet1())
                    Text(L10n.coreSheetBullet2())
                    Text(L10n.coreSheetBullet3())
                }
                .font(.callout)
                .foregroundStyle(.secondary)

                HStack {
                    Spacer()
                    Button(L10n.coreSheetCancelButton()) {
                        vm.cancelCoreRisk()
                    }
                    .keyboardShortcut(.cancelAction)

                    Button(L10n.coreSheetConfirmButton()) {
                        vm.confirmCoreRisk()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .padding(.top, 8)
            }
            .padding(24)
            .frame(width: 520)
            .environment(\.locale, vm.language.locale)
            .environment(\.layoutDirection, vm.language.isRTL ? .rightToLeft : .leftToRight)
        }
        .environment(\.locale, vm.language.locale)
        .environment(\.layoutDirection, vm.language.isRTL ? .rightToLeft : .leftToRight)
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
        alert.messageText = L10n.quitAlertTitle()
        alert.informativeText = L10n.quitAlertMessage()
        alert.addButton(withTitle: L10n.quitAlertContinueButton())
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
        WindowGroup(L10n.windowTitle()) {
            MainWizardView(vm: viewModel)
                .frame(minWidth: 980, minHeight: 660)
                .onAppear {
                    appDelegate.viewModel = viewModel
                }
        }
        .defaultSize(width: 1120, height: 760)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
