import Foundation

public enum CleanupCatalog {
    public static var categories: [String] {
        CleanupCategory.allCases.map(\.title)
    }

    public static let options: [CleanupOption] = [
        // 1. Bundled Apps
        app("copilot-app", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.Copilot", "Microsoft.Windows.Copilot", "Microsoft.549981C3F5F10"]),
        app("outlook", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.OutlookForWindows", "microsoft.windowscommunicationsapps"]),
        app("teams", macVM: true, tiny11: true, core: true,
            targets: ["MSTeams", "MicrosoftTeams", "Microsoft.Windows.Teams"]),
        app("xbox", macVM: true, tiny11: true, core: true,
            targets: [
                "Microsoft.GamingApp", "Microsoft.XboxApp", "Microsoft.Xbox.TCUI",
                "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay",
                "Microsoft.XboxIdentityProvider", "Microsoft.XboxSpeechToTextOverlay"
            ]),
        app("news-weather", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.BingNews", "Microsoft.BingWeather", "Microsoft.BingSearch"]),
        app("office-promos", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.MicrosoftOfficeHub", "Microsoft.OfficePushNotificationUtility"]),
        app("clipchamp", macVM: true, tiny11: true, core: true,
            targets: ["Clipchamp.Clipchamp"]),
        app("solitaire", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.MicrosoftSolitaireCollection"]),
        app("phone", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.YourPhone", "Microsoft.Windows.CrossDevice"]),
        app("feedback", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.WindowsFeedbackHub", "Microsoft.GetHelp", "Microsoft.Getstarted"]),
        app("devhome", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.Windows.DevHome", "Microsoft.PowerAutomateDesktop"]),
        app("social", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.People", "Microsoft.Todos", "Microsoft.SkypeApp", "MicrosoftCorporationII.MicrosoftFamily"]),
        app("maps", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.WindowsMaps", "Microsoft.MixedReality.Portal"]),
        app("media", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.ZuneMusic", "Microsoft.ZuneVideo"]),
        app("utilities", macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.WindowsAlarms", "Microsoft.WindowsSoundRecorder", "Microsoft.MicrosoftStickyNotes"]),
        app("quickassist", macVM: true, tiny11: true, core: true,
            targets: ["MicrosoftCorporationII.QuickAssist"]),
        app("paint", macVM: false, tiny11: true, core: false,
            targets: ["Microsoft.Paint", "Microsoft.MSPaint", "Microsoft.Microsoft3DViewer", "Microsoft.Office.OneNote"]),
        app("camera", macVM: true, tiny11: true, core: false,
            targets: ["Microsoft.WindowsCamera"]),
        app("terminal", macVM: false, tiny11: true, core: false,
            targets: ["Microsoft.WindowsTerminal"]),
        app("oem", macVM: true, tiny11: true, core: false,
            targets: [
                "AppUp.IntelManagementandSecurityStatus",
                "DolbyLaboratories.DolbyAccess",
                "DolbyLaboratories.DolbyDigitalPlusDecoderOEM"
            ]),

        // 2. System Files
        CleanupOption(
            id: "onedrive-files",
            categoryId: .systemFiles,
            kind: .file,
            macVMDefault: true,
            tiny11Default: true,
            coreDefault: true
        ),
        CleanupOption(
            id: "edge-files",
            categoryId: .systemFiles,
            kind: .file,
            macVMDefault: false,
            tiny11Default: true,
            coreDefault: true
        ),

        // 3. Features & Capabilities
        CleanupOption(
            id: "language-extras",
            categoryId: .featuresAndLanguages,
            kind: .capability,
            macVMDefault: false,
            tiny11Default: false,
            coreDefault: true,
            targets: ["Language.Handwriting", "Language.OCR", "Language.Speech", "Language.TextToSpeech"]
        ),
        CleanupOption(
            id: "legacy-capabilities",
            categoryId: .featuresAndLanguages,
            kind: .capability,
            macVMDefault: true,
            tiny11Default: false,
            coreDefault: true,
            targets: [
                "Microsoft.Windows.WordPad", "App.StepsRecorder",
                "MathRecognizer", "Media.WindowsMediaPlayer", "Microsoft.Windows.Wallpaper.Extended"
            ]
        ),
        feature("xps", macVM: true, tiny11: true, core: true,
            targets: ["Printing-XPSServices-Features"]),
        feature("workfolders", macVM: true, tiny11: true, core: true,
            targets: ["WorkFolders-Client"]),
        feature("legacy", macVM: true, tiny11: true, core: true,
            targets: ["Internet-Explorer-Optional-amd64", "Internet-Explorer-Optional-arm64"]),
        feature("recall-feature", macVM: true, tiny11: true, core: true,
            targets: ["Recall"]),

        // 4. Privacy & VM Policies
        policy("hardware-bypass", macVM: true, tiny11: true, core: true),
        policy("ads", macVM: true, tiny11: true, core: true),
        policy("privacy", macVM: true, tiny11: true, core: true),
        policy("copilot", macVM: true, tiny11: true, core: true),
        policy("widgets", macVM: true, tiny11: true, core: true),
        policy("search", macVM: true, tiny11: true, core: true),
        policy("onedrive", macVM: true, tiny11: true, core: true),
        policy("edge", macVM: true, tiny11: true, core: true),
        policy("oobe", macVM: true, tiny11: true, core: true),
        policy("reserved-storage", macVM: true, tiny11: true, core: true),
        policy("device-encryption", macVM: true, tiny11: true, core: true)
    ]

    private static func app(
        _ id: String,
        macVM: Bool, tiny11: Bool, core: Bool, targets: [String]
    ) -> CleanupOption {
        CleanupOption(
            id: id,
            categoryId: .bundledApps,
            kind: .app,
            macVMDefault: macVM,
            tiny11Default: tiny11,
            coreDefault: core,
            targets: targets
        )
    }

    private static func feature(
        _ id: String,
        macVM: Bool, tiny11: Bool, core: Bool, targets: [String]
    ) -> CleanupOption {
        CleanupOption(
            id: id,
            categoryId: .featuresAndLanguages,
            kind: .feature,
            macVMDefault: macVM,
            tiny11Default: tiny11,
            coreDefault: core,
            targets: targets
        )
    }

    private static func policy(
        _ id: String,
        macVM: Bool, tiny11: Bool, core: Bool
    ) -> CleanupOption {
        CleanupOption(
            id: id,
            categoryId: .privacyAndVM,
            kind: .policy,
            macVMDefault: macVM,
            tiny11Default: tiny11,
            coreDefault: core
        )
    }

    public static func optionIds(for mode: BuildMode, tiny11RemoveEdge: Bool = true) -> [String] {
        switch mode {
        case .macVM:
            return options.filter(\.macVMDefault).map(\.id)
        case .tiny11:
            return options
                .filter { $0.tiny11Default && (tiny11RemoveEdge || $0.id != "edge-files") }
                .map(\.id)
        case .tiny11Core:
            return options.filter(\.coreDefault).map(\.id)
        case .custom:
            return []
        }
    }

    /// 判断离线镜像中的包目录名或包标识是否命中某个 App 清理规则
    /// 例如目录名 `Clipchamp.Clipchamp_3.0.10020.0_neutral_~_yxz26nhyzhsrt` 或注册表子键名
    public static func matchesAppPackageName(_ packageOrFolderName: String, selectedOptionIds: Set<String>) -> CleanupOption? {
        let activeAppOptions = options.filter { $0.kind == .app && selectedOptionIds.contains($0.id) }
        for option in activeAppOptions {
            for target in option.targets {
                if packageOrFolderName.caseInsensitiveCompare(target) == .orderedSame {
                    return option
                }
                let prefix = target + "_"
                if packageOrFolderName.range(of: prefix, options: [.anchored, .caseInsensitive]) != nil {
                    return option
                }
            }
        }
        return nil
    }
}
