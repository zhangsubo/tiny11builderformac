import Foundation

public enum CleanupCatalog {
    public static let categories: [String] = [
        "预装臃肿应用",
        "系统级文件与组件",
        "可选功能与语言包",
        "系统隐私与虚拟机调优"
    ]

    public static let options: [CleanupOption] = [
        // 1. 预装臃肿应用 (Bundled Apps)
        app("copilot-app", "Copilot 与 Cortana 应用", "移除预装的 Copilot 与遗留助手应用，保留系统底层壳组件。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.Copilot", "Microsoft.Windows.Copilot", "Microsoft.549981C3F5F10"]),
        app("outlook", "新版 Outlook 与邮件日历", "移除新版网页套壳 Outlook 及旧版 Mail/Calendar 应用。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.OutlookForWindows", "microsoft.windowscommunicationsapps"]),
        app("teams", "个人版 Microsoft Teams", "移除消费级预装 Teams 客户端与聊天入口。",
            macVM: true, tiny11: true, core: true,
            targets: ["MSTeams", "MicrosoftTeams", "Microsoft.Windows.Teams"]),
        app("xbox", "Xbox 游戏套件与悬浮栏", "移除 Xbox 应用及 Game Bar（虚拟机通常无需 Xbox 录屏悬浮窗）。",
            macVM: true, tiny11: true, core: true,
            targets: [
                "Microsoft.GamingApp", "Microsoft.XboxApp", "Microsoft.Xbox.TCUI",
                "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay",
                "Microsoft.XboxIdentityProvider", "Microsoft.XboxSpeechToTextOverlay"
            ]),
        app("news-weather", "资讯、天气与必应推广应用", "移除信息流卡片、天气与必应搜索应用，保留本地搜索功能。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.BingNews", "Microsoft.BingWeather", "Microsoft.BingSearch"]),
        app("office-promos", "Microsoft 365 促销中心", "移除 Office Hub 订阅推广与通知组件。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.MicrosoftOfficeHub", "Microsoft.OfficePushNotificationUtility"]),
        app("clipchamp", "Clipchamp 视频编辑器", "移除预装的在线视频剪辑套件。",
            macVM: true, tiny11: true, core: true,
            targets: ["Clipchamp.Clipchamp"]),
        app("solitaire", "纸牌合集游戏", "移除预装休闲纸牌游戏与内嵌广告。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.MicrosoftSolitaireCollection"]),
        app("phone", "手机连接 (Phone Link) 与跨设备组件", "移除手机协同应用，减少虚拟机后台常驻进程。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.YourPhone", "Microsoft.Windows.CrossDevice"]),
        app("feedback", "反馈中心、入门提示与获取帮助", "移除 Feedback Hub、Get Help 与新手引导应用。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.WindowsFeedbackHub", "Microsoft.GetHelp", "Microsoft.Getstarted"]),
        app("devhome", "Dev Home 与 Power Automate", "移除体积庞大的预装自动化流程与开发看板应用。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.Windows.DevHome", "Microsoft.PowerAutomateDesktop"]),
        app("social", "人脉、To Do、家庭安全与 Skype", "移除可选社交与待办应用。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.People", "Microsoft.Todos", "Microsoft.SkypeApp", "MicrosoftCorporationII.MicrosoftFamily"]),
        app("maps", "地图与混合现实门户", "移除已停更的离线地图与 Mixed Reality VR 门户。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.WindowsMaps", "Microsoft.MixedReality.Portal"]),
        app("media", "媒体播放器与电影电视", "移除预装音视频商店应用，保留系统底层解码器。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.ZuneMusic", "Microsoft.ZuneVideo"]),
        app("utilities", "闹钟、录音机与便笺", "移除个人小工具（可在需要时从商店重装）。",
            macVM: true, tiny11: true, core: true,
            targets: ["Microsoft.WindowsAlarms", "Microsoft.WindowsSoundRecorder", "Microsoft.MicrosoftStickyNotes"]),
        app("quickassist", "快速助手 (Quick Assist)", "移除微软远程协助客户端。",
            macVM: true, tiny11: true, core: true,
            targets: ["MicrosoftCorporationII.QuickAssist"]),
        app("paint", "画图、3D 查看器与 OneNote", "默认在 Mac VM 模式下保留画图以便截图标注；原版 Tiny11 默认移除。",
            macVM: false, tiny11: true, core: false,
            targets: ["Microsoft.Paint", "Microsoft.MSPaint", "Microsoft.Microsoft3DViewer", "Microsoft.Office.OneNote"]),
        app("camera", "相机应用", "移除相机 UWP 应用（不影响摄像头驱动）。",
            macVM: true, tiny11: true, core: false,
            targets: ["Microsoft.WindowsCamera"]),
        app("terminal", "Windows 终端 (Terminal)", "移除现代化多标签终端（保留传统 PowerShell 与 CMD）。默认保留以方便开发。",
            macVM: false, tiny11: true, core: false,
            targets: ["Microsoft.WindowsTerminal"]),
        app("oem", "OEM 硬件推广应用", "移除 Intel 状态面板与杜比音效推广应用（不删驱动）。",
            macVM: true, tiny11: true, core: false,
            targets: [
                "AppUp.IntelManagementandSecurityStatus",
                "DolbyLaboratories.DolbyAccess",
                "DolbyLaboratories.DolbyDigitalPlusDecoderOEM"
            ]),

        // 2. 系统级文件与组件 (Files)
        CleanupOption(
            id: "onedrive-files",
            title: "删除 OneDrive 安装器程序",
            description: "删除离线镜像中的 OneDriveSetup.exe，避免新建用户首次登录时在后台自动静默安装 OneDrive。",
            category: "系统级文件与组件",
            kind: .file,
            macVMDefault: true,
            tiny11Default: true,
            coreDefault: true
        ),
        CleanupOption(
            id: "edge-files",
            title: "彻底删除 Edge 浏览器与 WebView2 文件",
            description: "物理删除 Edge 与 WebView2 运行时目录。注意：部分软件与安装器依赖 WebView2，Mac VM 模式默认保留运行库而仅用策略关闭其弹窗。",
            category: "系统级文件与组件",
            kind: .file,
            macVMDefault: false,
            tiny11Default: true,
            coreDefault: true
        ),

        // 3. 可选功能与语言包 (Features & Capabilities - 安装期 specialize 协同卸载)
        CleanupOption(
            id: "language-extras",
            title: "精简语音识别、OCR 与手写输入包",
            description: "在部署阶段移除额外的离线语音合成、手写与 OCR 载荷，保留基础系统显示语言与键盘输入法。",
            category: "可选功能与语言包",
            kind: .capability,
            macVMDefault: false,
            tiny11Default: false,
            coreDefault: true,
            targets: ["Language.Handwriting", "Language.OCR", "Language.Speech", "Language.TextToSpeech"]
        ),
        CleanupOption(
            id: "legacy-capabilities",
            title: "移除写字板、步骤记录器等退役附件",
            description: "移除 WordPad、Steps Recorder、数学输入面板、旧版 Windows Media Player 与扩展壁纸。",
            category: "可选功能与语言包",
            kind: .capability,
            macVMDefault: true,
            tiny11Default: false,
            coreDefault: true,
            targets: [
                "Microsoft.Windows.WordPad", "App.StepsRecorder",
                "MathRecognizer", "Media.WindowsMediaPlayer", "Microsoft.Windows.Wallpaper.Extended"
            ]
        ),
        feature("xps", "禁用 XPS 文档打印服务", "禁用并移除老旧的 XPS 虚拟打印机功能。",
            macVM: true, tiny11: true, core: true,
            targets: ["Printing-XPSServices-Features"]),
        feature("workfolders", "禁用企业工作文件夹 (Work Folders)", "禁用不常用的企业同步客户端功能。",
            macVM: true, tiny11: true, core: true,
            targets: ["WorkFolders-Client"]),
        feature("legacy", "禁用传统 Internet Explorer 兼容模式", "移除退役的 IE 可选功能载荷。",
            macVM: true, tiny11: true, core: true,
            targets: ["Internet-Explorer-Optional-amd64", "Internet-Explorer-Optional-arm64"]),
        feature("recall-feature", "禁用并移除 Windows Recall 快照载荷", "彻底禁用 AI 屏幕快照记录组件并移除其存储载荷。",
            macVM: true, tiny11: true, core: true,
            targets: ["Recall"]),

        // 4. 系统隐私与虚拟机调优 (Policies)
        policy("hardware-bypass", "绕过 TPM 2.0 / 内存 / CPU / 安全启动硬件检测",
            "在安装引导盘与系统中同时写入 LabConfig 绕过策略。UTM 小内存或未开虚拟 TPM 的虚拟机及老旧 PC 装机必选。",
            macVM: true, tiny11: true, core: true),
        policy("ads", "禁止系统广告、开始菜单推荐与静默推广应用",
            "关闭 ContentDeliveryManager 静默自动下载第三方推广软件（如 TikTok/Spotify 快捷方式）与锁屏聚焦广告。",
            macVM: true, tiny11: true, core: true),
        policy("privacy", "关闭广告 ID、输入法云收集与个性化遥测",
            "将诊断数据降至最低必需级别，关闭墨迹与键入文本隐式采集。",
            macVM: true, tiny11: true, core: true),
        policy("copilot", "策略级禁用 Windows Copilot 与 AI 分析",
            "写入组策略关闭任务栏 Copilot 按钮与 Windows AI 数据分析。",
            macVM: true, tiny11: true, core: true),
        policy("widgets", "禁用任务栏小组件与新闻源 (Widgets)",
            "通过策略彻底关闭高内存占用的后台 WebExperience 新闻信息流。",
            macVM: true, tiny11: true, core: true),
        policy("search", "关闭搜索框网页联网建议与热点推荐",
            "保留极速本地文件搜索，禁止开始菜单搜索将关键词发往 Bing。",
            macVM: true, tiny11: true, core: true),
        policy("onedrive", "组策略禁止 OneDrive 文件同步提示",
            "禁用资源管理器侧边栏与备份弹窗干扰。",
            macVM: true, tiny11: true, core: true),
        policy("edge", "净化 Edge 首次启动向导、侧边栏与推荐流",
            "隐藏 Edge 烦人的首次运行导入向导、购物侧边栏与后台推荐，同时保持 WebView2 兼容性。",
            macVM: true, tiny11: true, core: true),
        policy("oobe", "精简首次开机隐私盘问与完成设置骚扰弹窗",
            "跳过冗长的开机隐私推广问答，隐藏任务栏聊天图标（不自动替你创建账户或同意许可协议）。",
            macVM: true, tiny11: true, core: true),
        policy("reserved-storage", "禁用 7GB 系统更新预留空间 (Reserved Storage)",
            "禁止 Windows 预先强占约 7GB 虚拟磁盘空间，显著降低 Mac 虚拟机磁盘文件膨胀。",
            macVM: true, tiny11: true, core: true),
        policy("device-encryption", "禁止自动开启 BitLocker 全盘加密",
            "防止无人值守安装后自动加密虚拟磁盘，降低 Apple Silicon 虚拟化 I/O 开销并方便宿主机挂载排查。",
            macVM: true, tiny11: true, core: true)
    ]

    private static func app(
        _ id: String, _ title: String, _ description: String,
        macVM: Bool, tiny11: Bool, core: Bool, targets: [String]
    ) -> CleanupOption {
        CleanupOption(
            id: id, title: title, description: description,
            category: "预装臃肿应用", kind: .app,
            macVMDefault: macVM, tiny11Default: tiny11, coreDefault: core,
            targets: targets
        )
    }

    private static func feature(
        _ id: String, _ title: String, _ description: String,
        macVM: Bool, tiny11: Bool, core: Bool, targets: [String]
    ) -> CleanupOption {
        CleanupOption(
            id: id, title: title, description: description,
            category: "可选功能与语言包", kind: .feature,
            macVMDefault: macVM, tiny11Default: tiny11, coreDefault: core,
            targets: targets
        )
    }

    private static func policy(
        _ id: String, _ title: String, _ description: String,
        macVM: Bool, tiny11: Bool, core: Bool
    ) -> CleanupOption {
        CleanupOption(
            id: id, title: title, description: description,
            category: "系统隐私与虚拟机调优", kind: .policy,
            macVMDefault: macVM, tiny11Default: tiny11, coreDefault: core
        )
    }

    public static func optionIds(for mode: BuildMode) -> [String] {
        switch mode {
        case .macVM:
            return options.filter(\.macVMDefault).map(\.id)
        case .tiny11:
            return options.filter(\.tiny11Default).map(\.id)
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
