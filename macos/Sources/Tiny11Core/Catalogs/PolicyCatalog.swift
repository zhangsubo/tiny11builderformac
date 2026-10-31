import Foundation

public enum PolicyCatalog {
    public static func values(forOptionId id: String) -> [PolicyValue] {
        var result: [PolicyValue] = []

        func machine(_ key: String, _ name: String, _ dword: UInt32) {
            result.append(PolicyValue(hive: .software, keyPath: key, name: name, data: .dword(dword)))
        }
        func user(_ key: String, _ name: String, _ dword: UInt32) {
            result.append(PolicyValue(hive: .defaultUser, keyPath: key, name: name, data: .dword(dword)))
        }
        func system(_ key: String, _ name: String, _ dword: UInt32) {
            result.append(PolicyValue(hive: .system, keyPath: key, name: name, data: .dword(dword)))
        }

        let cloud = #"Policies\Microsoft\Windows\CloudContent"#
        let userCloud = #"Software\Policies\Microsoft\Windows\CloudContent"#
        let content = #"Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"#

        switch id {
        case "ads":
            for name in ["DisableWindowsConsumerFeatures", "DisableConsumerAccountStateContent", "DisableCloudOptimizedContent"] {
                machine(cloud, name, 1)
            }
            for name in ["DisableWindowsSpotlightFeatures", "DisableThirdPartySuggestions", "DisableTailoredExperiencesWithDiagnosticData"] {
                user(userCloud, name, 1)
            }
            for name in [
                "ContentDeliveryAllowed", "OemPreInstalledAppsEnabled", "PreInstalledAppsEnabled",
                "SilentInstalledAppsEnabled", "SoftLandingEnabled", "SubscribedContentEnabled", "SystemPaneSuggestionsEnabled",
                "SubscribedContent-310093Enabled", "SubscribedContent-338388Enabled", "SubscribedContent-338389Enabled",
                "SubscribedContent-338393Enabled", "SubscribedContent-353694Enabled", "SubscribedContent-353696Enabled"
            ] {
                user(content, name, 0)
            }
            user(#"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"#, "ShowSyncProviderNotifications", 0)
            machine(#"Policies\Microsoft\PushToInstall"#, "DisablePushToInstall", 1)
            machine(#"Policies\Microsoft\Teams"#, "DisableInstallation", 1)
            machine(#"Policies\Microsoft\Windows\Windows Mail"#, "PreventRun", 1)

        case "privacy":
            machine(#"Policies\Microsoft\Windows\DataCollection"#, "AllowTelemetry", 1)
            machine(#"Policies\Microsoft\Windows\AdvertisingInfo"#, "DisabledByGroupPolicy", 1)
            user(#"Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"#, "Enabled", 0)
            user(#"Software\Microsoft\Windows\CurrentVersion\Privacy"#, "TailoredExperiencesWithDiagnosticDataEnabled", 0)
            user(#"Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"#, "HasAccepted", 0)
            user(#"Software\Microsoft\Input\TIPC"#, "Enabled", 0)
            user(#"Software\Microsoft\InputPersonalization"#, "RestrictImplicitInkCollection", 1)
            user(#"Software\Microsoft\InputPersonalization"#, "RestrictImplicitTextCollection", 1)
            user(#"Software\Microsoft\InputPersonalization\TrainedDataStore"#, "HarvestContacts", 0)

        case "copilot":
            machine(#"Policies\Microsoft\Windows\WindowsCopilot"#, "TurnOffWindowsCopilot", 1)
            user(#"Software\Policies\Microsoft\Windows\WindowsCopilot"#, "TurnOffWindowsCopilot", 1)
            machine(#"Policies\Microsoft\Windows\WindowsAI"#, "DisableAIDataAnalysis", 1)
            user(#"Software\Microsoft\Windows\WindowsAI"#, "DisableAIDataAnalysis", 1)
            user(#"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"#, "ShowCopilotButton", 0)

        case "widgets":
            machine(#"Policies\Microsoft\Dsh"#, "AllowNewsAndInterests", 0)

        case "search":
            user(#"Software\Policies\Microsoft\Windows\Explorer"#, "DisableSearchBoxSuggestions", 1)
            machine(#"Policies\Microsoft\Windows\Windows Search"#, "AllowCloudSearch", 0)
            machine(#"Policies\Microsoft\Windows\Windows Search"#, "EnableDynamicContentInWSB", 0)

        case "onedrive":
            machine(#"Policies\Microsoft\Windows\OneDrive"#, "DisableFileSyncNGSC", 1)

        case "edge":
            machine(#"Policies\Microsoft\Edge"#, "HideFirstRunExperience", 1)
            for name in [
                "HubsSidebarEnabled",
                "ShowRecommendationsEnabled",
                "UserFeedbackAllowed",
                "SpotlightExperiencesAndRecommendationsEnabled"
            ] {
                machine(#"Policies\Microsoft\Edge"#, name, 0)
            }

        case "oobe":
            machine(#"Policies\Microsoft\Windows\OOBE"#, "DisablePrivacyExperience", 1)
            user(#"Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement"#, "ScoobeSystemSettingEnabled", 0)
            user(content, "SubscribedContent-310093Enabled", 0)
            user(#"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"#, "TaskbarMn", 0)
            machine(#"Policies\Microsoft\Windows\Windows Chat"#, "ChatIcon", 3)

        case "hardware-bypass":
            for name in [
                "BypassCPUCheck", "BypassRAMCheck", "BypassSecureBootCheck",
                "BypassStorageCheck", "BypassTPMCheck"
            ] {
                system(#"Setup\LabConfig"#, name, 1)
            }
            system(#"Setup\MoSetup"#, "AllowUpgradesWithUnsupportedTPMOrCPU", 1)
            user(#"Control Panel\UnsupportedHardwareNotificationCache"#, "SV1", 0)
            user(#"Control Panel\UnsupportedHardwareNotificationCache"#, "SV2", 0)

        case "reserved-storage":
            machine(#"Microsoft\Windows\CurrentVersion\ReserveManager"#, "ShippedWithReserves", 0)

        case "device-encryption":
            system(#"{ControlSet}\Control\BitLocker"#, "PreventDeviceEncryption", 1)

        default:
            break
        }

        return result
    }

    public static let coreDisabledServices: [String] = [
        "wuauserv", "UsoSvc", "WaaSMedicSvc",
        "WinDefend", "WdNisSvc", "WdNisDrv", "WdFilter", "Sense"
    ]

    public static var coreSoftwarePolicies: [PolicyValue] {
        [
            PolicyValue(hive: .software, keyPath: #"Policies\Microsoft\Windows\WindowsUpdate\AU"#, name: "NoAutoUpdate", data: .dword(1)),
            PolicyValue(hive: .software, keyPath: #"Policies\Microsoft\Windows\WindowsUpdate"#, name: "DisableWindowsUpdateAccess", data: .dword(1)),
            PolicyValue(hive: .software, keyPath: #"Policies\Microsoft\Windows Defender"#, name: "DisableAntiSpyware", data: .dword(1)),
            PolicyValue(hive: .software, keyPath: #"Policies\Microsoft\Windows Defender\Real-Time Protection"#, name: "DisableRealtimeMonitoring", data: .dword(1))
        ]
    }
}
