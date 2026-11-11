import Foundation

public enum CleanupCategory: String, Codable, CaseIterable, Sendable, Identifiable {
    case bundledApps = "bundled_apps"
    case systemFiles = "system_files"
    case featuresAndLanguages = "features_languages"
    case privacyAndVM = "privacy_vm"

    public var id: String { rawValue }

    public var title: String {
        title(in: L10n.currentLanguage)
    }

    public func title(in lang: AppLanguage) -> String {
        switch self {
        case .bundledApps:
            return L10n.tr(
                lang: lang,
                zh: "预装臃肿应用",
                en: "Bundled Apps",
                fr: "Apps préinstallées",
                es: "Apps preinstaladas",
                ru: "Предустановленные",
                ar: "التطبيقات المدمجة"
            )
        case .systemFiles:
            return L10n.tr(
                lang: lang,
                zh: "系统级文件与组件",
                en: "System Files",
                fr: "Fichiers système",
                es: "Archivos del sistema",
                ru: "Системные файлы",
                ar: "ملفات النظام"
            )
        case .featuresAndLanguages:
            return L10n.tr(
                lang: lang,
                zh: "可选功能与语言包",
                en: "Features & Lang",
                fr: "Fonctionnalités",
                es: "Características",
                ru: "Компоненты",
                ar: "الميزات واللغات"
            )
        case .privacyAndVM:
            return L10n.tr(
                lang: lang,
                zh: "系统隐私与虚拟机调优",
                en: "Privacy & VM",
                fr: "Confidentialité & VM",
                es: "Privacidad y VM",
                ru: "Приватность и ВМ",
                ar: "الخصوصية والآلة الافتراضية"
            )
        }
    }
}

public extension L10n {
    static func allCategoriesLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "全部",
            en: "All",
            fr: "Tout",
            es: "Todo",
            ru: "Все",
            ar: "الكل"
        )
    }

    static func optionCopy(for id: String, lang: AppLanguage = L10n.currentLanguage) -> (title: String, description: String) {
        switch id {
        case "copilot-app":
            return (
                tr(
                    lang: lang,
                    zh: "Copilot 与 Cortana 应用",
                    en: "Copilot & Cortana Apps",
                    fr: "Applications Copilot et Cortana",
                    es: "Aplicaciones Copilot y Cortana",
                    ru: "Приложения Copilot и Cortana",
                    ar: "تطبيقات Copilot وCortana"
                ),
                tr(
                    lang: lang,
                    zh: "移除预装的 Copilot 与遗留助手应用，保留系统底层壳组件。",
                    en: "Remove preinstalled Copilot and legacy assistant apps while keeping core shell components.",
                    fr: "Supprime Copilot préinstallé et les anciens assistants tout en conservant les composants système.",
                    es: "Elimina las apps preinstaladas de Copilot y asistentes heredados conservando componentes base del shell.",
                    ru: "Удаляет предустановленные приложения Copilot и старых ассистентов, сохраняя системные компоненты оболочки.",
                    ar: "إزالة تطبيقات Copilot والمساعدات القديمة المثبتة مسبقًا مع الاحتفاظ بمكونات النظام الأساسية."
                )
            )

        case "outlook":
            return (
                tr(
                    lang: lang,
                    zh: "新版 Outlook 与邮件日历",
                    en: "New Outlook & Mail / Calendar",
                    fr: "Nouvel Outlook et Courrier / Calendrier",
                    es: "Nuevo Outlook y Correo / Calendario",
                    ru: "Новый Outlook и Почта / Календарь",
                    ar: "تطبيق Outlook الجديد والبريد والتقويم"
                ),
                tr(
                    lang: lang,
                    zh: "移除新版网页套壳 Outlook 及旧版 Mail/Calendar 应用。",
                    en: "Remove the web-based New Outlook and retired Mail / Calendar apps.",
                    fr: "Supprime le nouvel Outlook web ainsi que les anciennes applications Courrier et Calendrier.",
                    es: "Elimina el nuevo Outlook basado en web y las antiguas aplicaciones de Correo y Calendario.",
                    ru: "Удаляет веб-клиент нового Outlook, а также устаревшие приложения «Почта» и «Календарь».",
                    ar: "إزالة تطبيق Outlook الجديد المبني على الويب وتطبيقات البريد والتقويم القديمة."
                )
            )

        case "teams":
            return (
                tr(
                    lang: lang,
                    zh: "个人版 Microsoft Teams",
                    en: "Microsoft Teams (Personal)",
                    fr: "Microsoft Teams (personnel)",
                    es: "Microsoft Teams (personal)",
                    ru: "Microsoft Teams (персональный)",
                    ar: "تطبيق Microsoft Teams الشخصي"
                ),
                tr(
                    lang: lang,
                    zh: "移除消费级预装 Teams 客户端与聊天入口。",
                    en: "Remove consumer preinstalled Teams clients and chat integration.",
                    fr: "Supprime le client Teams grand public préinstallé et son entrée de discussion.",
                    es: "Elimina el cliente Teams personal preinstalado y su acceso directo de chat.",
                    ru: "Удаляет предустановленный потребительский клиент Teams и интеграцию чата.",
                    ar: "إزالة عميل Teams الاستهلاكي المثبت مسبقًا واختصار المحادثة."
                )
            )

        case "xbox":
            return (
                tr(
                    lang: lang,
                    zh: "Xbox 游戏套件与悬浮栏",
                    en: "Xbox Apps & Game Bar Overlays",
                    fr: "Suite Xbox et Game Bar",
                    es: "Suite Xbox y barra de juegos",
                    ru: "Приложения Xbox и игровая панель",
                    ar: "حزمة ألعاب Xbox وشريط الألعاب"
                ),
                tr(
                    lang: lang,
                    zh: "移除 Xbox 应用及 Game Bar（虚拟机通常无需 Xbox 录屏悬浮窗）。",
                    en: "Remove Xbox apps and Game Bar overlays (rarely needed inside virtual machines).",
                    fr: "Supprime les applications Xbox et la superposition Game Bar (inutile en machine virtuelle).",
                    es: "Elimina las apps de Xbox y la superposición de Game Bar (innecesarias en máquinas virtuales).",
                    ru: "Удаляет приложения Xbox и оверлей Game Bar (обычно не требуются в виртуальной машине).",
                    ar: "إزالة تطبيقات Xbox وشريط Game Bar العائم (غير ضروري عادةً في الأجهزة الافتراضية)."
                )
            )

        case "news-weather":
            return (
                tr(
                    lang: lang,
                    zh: "资讯、天气与必应推广应用",
                    en: "News, Weather & Bing Apps",
                    fr: "Actualités, Météo et applications Bing",
                    es: "Noticias, El Tiempo y apps de Bing",
                    ru: "Новости, Погода и приложения Bing",
                    ar: "تطبيقات الأخبار والطقس وBing"
                ),
                tr(
                    lang: lang,
                    zh: "移除信息流卡片、天气与必应搜索应用，保留本地搜索功能。",
                    en: "Remove packaged feed, weather, and Bing apps while preserving local Windows Search.",
                    fr: "Supprime les flux d’actualités, Météo et Bing tout en conservant la recherche locale.",
                    es: "Elimina las apps de noticias, clima y Bing conservando la búsqueda local de Windows.",
                    ru: "Удаляет новостные ленты, Погоду и приложения Bing, сохраняя локальный поиск Windows.",
                    ar: "إزالة تطبيقات الأخبار والطقس وBing مع الحفاظ على البحث المحلي في النظام."
                )
            )

        case "office-promos":
            return (
                tr(
                    lang: lang,
                    zh: "Microsoft 365 促销中心",
                    en: "Microsoft 365 Promotional Hub",
                    fr: "Promotions Microsoft 365",
                    es: "Centro promocional de Microsoft 365",
                    ru: "Промо-центр Microsoft 365",
                    ar: "مركز عروض Microsoft 365 الترويجي"
                ),
                tr(
                    lang: lang,
                    zh: "移除 Office Hub 订阅推广与通知组件。",
                    en: "Remove Office Hub subscription promotions and push-notification utilities.",
                    fr: "Supprime Office Hub ainsi que les notifications promotionnelles d’abonnement.",
                    es: "Elimina Office Hub y las utilidades de notificaciones promocionales de suscripción.",
                    ru: "Удаляет Office Hub и утилиты рекламных уведомлений о подписке.",
                    ar: "إزالة مركز Office Hub الترويجي وأدوات الإشعارات التسويقية."
                )
            )

        case "clipchamp":
            return (
                tr(
                    lang: lang,
                    zh: "Clipchamp 视频编辑器",
                    en: "Clipchamp Video Editor",
                    fr: "Éditeur vidéo Clipchamp",
                    es: "Editor de vídeo Clipchamp",
                    ru: "Видеоредактор Clipchamp",
                    ar: "محرر الفيديو Clipchamp"
                ),
                tr(
                    lang: lang,
                    zh: "移除预装的在线视频剪辑套件。",
                    en: "Remove the bundled online video editing suite.",
                    fr: "Supprime l’éditeur vidéo en ligne préinstallé.",
                    es: "Elimina el editor de vídeo en línea preinstalado.",
                    ru: "Удаляет предустановленный онлайн-видеоредактор.",
                    ar: "إزالة محرر الفيديو السحابي المثبت مسبقًا."
                )
            )

        case "solitaire":
            return (
                tr(
                    lang: lang,
                    zh: "纸牌合集游戏",
                    en: "Microsoft Solitaire Collection",
                    fr: "Microsoft Solitaire Collection",
                    es: "Colección de juegos Solitaire",
                    ru: "Коллекция пасьянсов Solitaire",
                    ar: "مجموعة ألعاب الورق Solitaire"
                ),
                tr(
                    lang: lang,
                    zh: "移除预装休闲纸牌游戏与内嵌广告。",
                    en: "Remove bundled casual card games and embedded ads.",
                    fr: "Supprime les jeux de cartes préinstallés et leurs publicités intégrées.",
                    es: "Elimina los juegos de cartas preinstalados y sus anuncios integrados.",
                    ru: "Удаляет предустановленные карточные игры со встроенной рекламой.",
                    ar: "إزالة ألعاب الورق المثبتة مسبقًا وما تتضمنه من إعلانات."
                )
            )

        case "phone":
            return (
                tr(
                    lang: lang,
                    zh: "手机连接 (Phone Link) 与跨设备组件",
                    en: "Phone Link & Cross-Device Apps",
                    fr: "Mobile connecté et composants multi-appareils",
                    es: "Enlace Móvil y componentes multidispositivo",
                    ru: "Связь с телефоном и межсетевые компоненты",
                    ar: "تطبيق رابط الهاتف ومكونات الأجهزة المتعددة"
                ),
                tr(
                    lang: lang,
                    zh: "移除手机协同应用，减少虚拟机后台常驻进程。",
                    en: "Remove phone integration apps to reduce background processes.",
                    fr: "Supprime les applications de synchronisation mobile pour réduire les processus en arrière-plan.",
                    es: "Elimina las apps de integración móvil para reducir procesos residentes en segundo plano.",
                    ru: "Удаляет приложения синхронизации со смартфоном, снижая число фоновых процессов.",
                    ar: "إزالة تطبيقات مزامنة الهاتف لتقليل العمليات الخلفية المستمرة."
                )
            )

        case "feedback":
            return (
                tr(
                    lang: lang,
                    zh: "反馈中心、入门提示与获取帮助",
                    en: "Feedback Hub, Tips & Get Help",
                    fr: "Hub de commentaires, Astuces et Obtenir de l’aide",
                    es: "Centro de opiniones, Sugerencias y Obtener ayuda",
                    ru: "Центр отзывов, Советы и Техподдержка",
                    ar: "مركز الملاحظات والنصائح والحصول على المساعدة"
                ),
                tr(
                    lang: lang,
                    zh: "移除 Feedback Hub、Get Help 与新手引导应用。",
                    en: "Remove Feedback Hub, Get Help, and introductory onboarding apps.",
                    fr: "Supprime le Hub de commentaires, Obtenir de l’aide et les guides d’accueil.",
                    es: "Elimina Feedback Hub, Obtener ayuda y las aplicaciones de introducción.",
                    ru: "Удаляет Центр отзывов, приложение «Техподдержка» и вводные советы.",
                    ar: "إزالة تطبيقات Feedback Hub وGet Help وتطبيقات الإرشاد التمهيدية."
                )
            )

        case "devhome":
            return (
                tr(
                    lang: lang,
                    zh: "Dev Home 与 Power Automate",
                    en: "Dev Home & Power Automate",
                    fr: "Dev Home et Power Automate",
                    es: "Dev Home y Power Automate",
                    ru: "Dev Home и Power Automate",
                    ar: "تطبيقا Dev Home وPower Automate"
                ),
                tr(
                    lang: lang,
                    zh: "移除体积庞大的预装自动化流程与开发看板应用。",
                    en: "Remove bulky preinstalled desktop automation and developer dashboard apps.",
                    fr: "Supprime les volumineuses applications préinstallées d’automatisation et de tableau de bord.",
                    es: "Elimina las pesadas aplicaciones preinstaladas de automatización y panel de desarrollo.",
                    ru: "Удаляет объёмные предустановленные приложения автоматизации и панели разработчика.",
                    ar: "إزالة تطبيقات الأتمتة ولوحة المطورين الضخمة المثبتة مسبقًا."
                )
            )

        case "social":
            return (
                tr(
                    lang: lang,
                    zh: "人脉、To Do、家庭安全与 Skype",
                    en: "People, To Do, Family Safety & Skype",
                    fr: "Contacts, To Do, Contrôle parental et Skype",
                    es: "Contactos, To Do, Familia y Skype",
                    ru: "Люди, To Do, Семейная безопасность и Skype",
                    ar: "جهات الاتصال وTo Do والعائلة وSkype"
                ),
                tr(
                    lang: lang,
                    zh: "移除可选社交与待办应用。",
                    en: "Remove optional social, family, and task organizer apps.",
                    fr: "Supprime les applications sociales et de gestion de tâches facultatives.",
                    es: "Elimina aplicaciones opcionales de comunicación, familia y listas de tareas.",
                    ru: "Удаляет необязательные социальные приложения и планировщики задач.",
                    ar: "إزالة تطبيقات التواصل وتنظيم المهام الاختيارية."
                )
            )

        case "maps":
            return (
                tr(
                    lang: lang,
                    zh: "地图与混合现实门户",
                    en: "Maps & Mixed Reality Portal",
                    fr: "Cartes et Portail de réalité mixte",
                    es: "Mapas y Portal de realidad mixta",
                    ru: "Карты и Портал смешанной реальности",
                    ar: "الخرائط وبوابة الواقع المختلط"
                ),
                tr(
                    lang: lang,
                    zh: "移除已停更的离线地图与 Mixed Reality VR 门户。",
                    en: "Remove deprecated Windows Maps and Mixed Reality VR portal clients.",
                    fr: "Supprime Cartes hors ligne obsolète ainsi que le portail VR Mixed Reality.",
                    es: "Elimina las aplicaciones obsoletas de Mapas y el portal VR de Mixed Reality.",
                    ru: "Удаляет устаревшие Карты и VR-портал Mixed Reality.",
                    ar: "إزالة تطبيق الخرائط المتوقف وبوابة الواقع المختلط VR."
                )
            )

        case "media":
            return (
                tr(
                    lang: lang,
                    zh: "媒体播放器与电影电视",
                    en: "Media Player & Movies & TV",
                    fr: "Lecteur multimédia et Films et TV",
                    es: "Reproductor multimedia y Películas y TV",
                    ru: "Медиаплеер и Кино и ТВ",
                    ar: "مشغل الوسائط والأفلام والتلفزيون"
                ),
                tr(
                    lang: lang,
                    zh: "移除预装音视频商店应用，保留系统底层解码器。",
                    en: "Remove Store media playback apps while retaining system codecs and frameworks.",
                    fr: "Supprime les lecteurs multimédias du Store tout en conservant les codecs système.",
                    es: "Elimina los reproductores de la Tienda manteniendo los códecs base del sistema.",
                    ru: "Удаляет магазинные плееры, сохраняя системные аудио- и видеокодеки.",
                    ar: "إزالة تطبيقات تشغيل الوسائط من المتجر مع الاحتفاظ ببرامج الترميز الأساسية."
                )
            )

        case "utilities":
            return (
                tr(
                    lang: lang,
                    zh: "闹钟、录音机与便笺",
                    en: "Clock, Sound Recorder & Sticky Notes",
                    fr: "Horloge, Magnétophone et Pense-bêtes",
                    es: "Reloj, Grabadora de sonido y Notas rápidas",
                    ru: "Часы, Звукозапись и Записки",
                    ar: "الساعة ومسجل الصوت والملاحظات الملصقة"
                ),
                tr(
                    lang: lang,
                    zh: "移除个人小工具（可在需要时从商店重装）。",
                    en: "Remove optional personal utilities (can be reinstalled from Store if needed).",
                    fr: "Supprime ces petits utilitaires personnels (réinstallables depuis le Store).",
                    es: "Elimina utilidades personales opcionales (reinstalables desde la Tienda si se necesitan).",
                    ru: "Удаляет личные мини-утилиты (при необходимости их можно вернуть из Store).",
                    ar: "إزالة الأدوات الشخصية الاختيارية (يمكن إعادة تثبيتها من المتجر عند الحاجة)."
                )
            )

        case "quickassist":
            return (
                tr(
                    lang: lang,
                    zh: "快速助手 (Quick Assist)",
                    en: "Quick Assist",
                    fr: "Assistance rapide (Quick Assist)",
                    es: "Asistencia rápida (Quick Assist)",
                    ru: "Быстрая помощь (Quick Assist)",
                    ar: "المساعدة السريعة (Quick Assist)"
                ),
                tr(
                    lang: lang,
                    zh: "移除微软远程协助客户端。",
                    en: "Remove Microsoft's remote-assistance client app.",
                    fr: "Supprime le client d’assistance à distance de Microsoft.",
                    es: "Elimina el cliente de asistencia remota de Microsoft.",
                    ru: "Удаляет клиент удалённой помощи Microsoft.",
                    ar: "إزالة عميل المساعدة عن بُعد من Microsoft."
                )
            )

        case "paint":
            return (
                tr(
                    lang: lang,
                    zh: "画图、3D 查看器与 OneNote",
                    en: "Paint, 3D Viewer & OneNote",
                    fr: "Paint, Visionneuse 3D et OneNote",
                    es: "Paint, Visor 3D y OneNote",
                    ru: "Paint, Средство 3D-просмотра и OneNote",
                    ar: "الرسام وعارض 3D وOneNote"
                ),
                tr(
                    lang: lang,
                    zh: "默认在 Mac VM 模式下保留画图以便截图标注；原版 Tiny11 默认移除。",
                    en: "Kept by default in Mac VM mode for quick annotations; removed by default in Standard Tiny11.",
                    fr: "Conservé par défaut en mode VM Mac pour annoter les captures ; supprimé en mode Tiny11 Standard.",
                    es: "Se conserva por defecto en modo VM Mac para anotaciones; se elimina en Tiny11 Estándar.",
                    ru: "По умолчанию сохраняется в режиме Mac VM для пометок на скриншотах; удаляется в стандарте Tiny11.",
                    ar: "يُحتفظ به افتراضيًا في وضع الجهاز الافتراضي لـ Mac؛ ويُزال افتراضيًا في وضع Tiny11 القياسي."
                )
            )

        case "camera":
            return (
                tr(
                    lang: lang,
                    zh: "相机应用",
                    en: "Camera App",
                    fr: "Application Caméra",
                    es: "Aplicación Cámara",
                    ru: "Приложение «Камера»",
                    ar: "تطبيق الكاميرا"
                ),
                tr(
                    lang: lang,
                    zh: "移除相机 UWP 应用（不影响摄像头驱动）。",
                    en: "Remove the Camera UWP app without affecting webcam drivers.",
                    fr: "Supprime l’application UWP Caméra sans affecter les pilotes de webcam.",
                    es: "Elimina la aplicación UWP de Cámara sin afectar los controladores de webcam.",
                    ru: "Удаляет UWP-приложение «Камера», не затрагивая драйверы веб-камеры.",
                    ar: "إزالة تطبيق الكاميرا دون التأثير على تعريفات الكاميرا."
                )
            )

        case "terminal":
            return (
                tr(
                    lang: lang,
                    zh: "Windows 终端 (Terminal)",
                    en: "Windows Terminal",
                    fr: "Windows Terminal",
                    es: "Windows Terminal",
                    ru: "Терминал Windows (Terminal)",
                    ar: "طرفية Windows (Terminal)"
                ),
                tr(
                    lang: lang,
                    zh: "移除现代化多标签终端（保留传统 PowerShell 与 CMD）。默认保留以方便开发。",
                    en: "Remove modern tabbed Terminal while keeping classic PowerShell and Command Prompt.",
                    fr: "Supprime le Terminal moderne à onglets tout en gardant PowerShell et l’Invite de commandes.",
                    es: "Elimina la Terminal moderna con pestañas manteniendo PowerShell y Símbolo del sistema.",
                    ru: "Удаляет современный многовкладочный Терминал, оставляя классические PowerShell и CMD.",
                    ar: "إزالة الطرفية الحديثة متعددة التبويبات مع الإبقاء على PowerShell وموجه الأوامر التقليدي."
                )
            )

        case "oem":
            return (
                tr(
                    lang: lang,
                    zh: "OEM 硬件推广应用",
                    en: "OEM Hardware Promotional Apps",
                    fr: "Applications promotionnelles OEM",
                    es: "Aplicaciones promocionales OEM",
                    ru: "Промо-приложения производителей (OEM)",
                    ar: "التطبيقات الترويجية للشركات المصنعة (OEM)"
                ),
                tr(
                    lang: lang,
                    zh: "移除 Intel 状态面板与杜比音效推广应用（不删驱动）。",
                    en: "Remove Intel status panels and Dolby promotional apps without removing hardware drivers.",
                    fr: "Supprime les panneaux Intel et promotions Dolby sans supprimer les pilotes matériels.",
                    es: "Elimina paneles promocionales de Intel y Dolby sin borrar controladores de hardware.",
                    ru: "Удаляет промо-панели Intel и Dolby, не затрагивая аппаратные драйверы.",
                    ar: "إزالة لوحات Intel وتطبيقات Dolby الترويجية دون حذف تعريفات العتاد."
                )
            )

        case "onedrive-files":
            return (
                tr(
                    lang: lang,
                    zh: "删除 OneDrive 安装器程序",
                    en: "Remove OneDrive Setup Binaries",
                    fr: "Supprimer l’installateur OneDrive",
                    es: "Eliminar instalador de OneDrive",
                    ru: "Удалить установщик OneDrive",
                    ar: "حذف برنامج تثبيت OneDrive"
                ),
                tr(
                    lang: lang,
                    zh: "删除离线镜像中的 OneDriveSetup.exe，避免新建用户首次登录时在后台自动静默安装 OneDrive。",
                    en: "Delete OneDriveSetup.exe from the offline image to prevent silent background installation on first sign-in.",
                    fr: "Supprime OneDriveSetup.exe de l’image hors ligne pour éviter l’installation silencieuse au premier démarrage.",
                    es: "Elimina OneDriveSetup.exe de la imagen sin conexión para evitar su instalación silenciosa al iniciar sesión.",
                    ru: "Удаляет OneDriveSetup.exe из образа, предотвращая тихую автоустановку OneDrive при первом входе.",
                    ar: "حذف ملف OneDriveSetup.exe من الصورة لمنع تثبيت OneDrive تلقائيًا في الخلفية عند أول تسجيل دخول."
                )
            )

        case "edge-files":
            return (
                tr(
                    lang: lang,
                    zh: "彻底删除 Edge 浏览器与 WebView2 文件",
                    en: "Remove Microsoft Edge & WebView2 Files",
                    fr: "Supprimer les fichiers Microsoft Edge et WebView2",
                    es: "Eliminar archivos de Microsoft Edge y WebView2",
                    ru: "Полностью удалить файлы Edge и WebView2",
                    ar: "حذف ملفات متصفح Edge وWebView2 بالكامل"
                ),
                tr(
                    lang: lang,
                    zh: "物理删除 Edge 与 WebView2 运行时目录。注意：部分软件与安装器依赖 WebView2，Mac VM 模式默认保留运行库而仅用策略关闭其弹窗。",
                    en: "Physically delete Edge and WebView2 runtime directories. Note: apps requiring WebView2 may need it reinstalled; Mac VM mode keeps it by default.",
                    fr: "Supprime physiquement les dossiers Edge et WebView2. Attention : certains logiciels dépendent de WebView2 (conservé par défaut en mode VM Mac).",
                    es: "Elimina físicamente los directorios de Edge y WebView2. Nota: algunas apps dependen de WebView2 (el modo VM Mac lo conserva por defecto).",
                    ru: "Физически удаляет каталоги Edge и среды WebView2. Примечание: ряд программ зависит от WebView2, поэтому режим Mac VM сохраняет его по умолчанию.",
                    ar: "حذف مجلدات متصفح Edge وبيئة WebView2 فعليًا. ملاحظة: بعض البرامج تعتمد على WebView2 لذا يحتفظ به وضع الجهاز الافتراضي لـ Mac افتراضيًا."
                )
            )

        case "language-extras":
            return (
                tr(
                    lang: lang,
                    zh: "精简语音识别、OCR 与手写输入包",
                    en: "Trim Speech, OCR & Handwriting Payloads",
                    fr: "Alléger reconnaissance vocale, OCR et écriture manuscrite",
                    es: "Reducir paquetes de voz, OCR y escritura manual",
                    ru: "Удалить пакеты речи, OCR и рукописного ввода",
                    ar: "تقليص حزم التعرف الصوتي وOCR والكتابة اليدوية"
                ),
                tr(
                    lang: lang,
                    zh: "在部署阶段移除额外的离线语音合成、手写与 OCR 载荷，保留基础系统显示语言与键盘输入法。",
                    en: "Remove extra offline speech, handwriting, and OCR capabilities during deployment while retaining display language and keyboard input.",
                    fr: "Supprime les composants hors ligne de voix, d’écriture manuscrite et d’OCR tout en gardant la langue d’affichage et les claviers.",
                    es: "Elimina capacidades adicionales de voz, escritura manual y OCR durante el despliegue manteniendo el idioma y teclados básicos.",
                    ru: "Удаляет дополнительные пакеты синтеза речи, рукописного ввода и OCR при развёртывании, сохраняя язык интерфейса и раскладки.",
                    ar: "إزالة حزم النطق والكتابة اليدوية والتعرف الضوئي الإضافية أثناء التثبيت مع الاحتفاظ بلغة العرض ولوحات المفاتيح."
                )
            )

        case "legacy-capabilities":
            return (
                tr(
                    lang: lang,
                    zh: "移除写字板、步骤记录器等退役附件",
                    en: "Remove Retired Accessories & Extended Wallpapers",
                    fr: "Supprimer WordPad et accessoires obsolètes",
                    es: "Eliminar WordPad y accesorios retirados",
                    ru: "Удалить WordPad и устаревшие стандартные средства",
                    ar: "إزالة الدفتر (WordPad) والملحقات المتوقفة"
                ),
                tr(
                    lang: lang,
                    zh: "移除 WordPad、Steps Recorder、数学输入面板、旧版 Windows Media Player 与扩展壁纸。",
                    en: "Remove WordPad, Steps Recorder, Math Recognizer, legacy Windows Media Player, and extended wallpaper packs.",
                    fr: "Supprime WordPad, l’Enregistreur d’actions, le panneau mathématique, l’ancien lecteur Windows Media et les fonds d’écran étendus.",
                    es: "Elimina WordPad, Grabación de acciones, entrada matemática, Windows Media Player clásico y fondos extendidos.",
                    ru: "Удаляет WordPad, Запись действий, панель математического ввода, старый проигрыватель Windows Media и доп. обои.",
                    ar: "إزالة WordPad ومسجل الخطوات ولوحة الإدخال الرياضي ومشغل الوسائط القديم والخلفيات الإضافية."
                )
            )

        case "xps":
            return (
                tr(
                    lang: lang,
                    zh: "禁用 XPS 文档打印服务",
                    en: "Disable XPS Document Printing",
                    fr: "Désactiver l’impression de documents XPS",
                    es: "Desactivar impresión de documentos XPS",
                    ru: "Отключить службу печати документов XPS",
                    ar: "تعطيل خدمة طباعة مستندات XPS"
                ),
                tr(
                    lang: lang,
                    zh: "禁用并移除老旧的 XPS 虚拟打印机功能。",
                    en: "Disable and remove the legacy XPS virtual printer optional feature.",
                    fr: "Désactive et supprime la fonction obsolète d’imprimante virtuelle XPS.",
                    es: "Desactiva y elimina la antigua característica opcional de impresora virtual XPS.",
                    ru: "Отключает и удаляет устаревший компонент виртуального принтера XPS.",
                    ar: "تعطيل وإزالة ميزة الطابعة الافتراضية XPS القديمة."
                )
            )

        case "workfolders":
            return (
                tr(
                    lang: lang,
                    zh: "禁用企业工作文件夹 (Work Folders)",
                    en: "Disable Enterprise Work Folders",
                    fr: "Désactiver les Dossiers de travail (Work Folders)",
                    es: "Desactivar Carpetas de trabajo (Work Folders)",
                    ru: "Отключить Рабочие папки (Work Folders)",
                    ar: "تعطيل مجلدات العمل المؤسسية (Work Folders)"
                ),
                tr(
                    lang: lang,
                    zh: "禁用不常用的企业同步客户端功能。",
                    en: "Disable the rarely used enterprise Work Folders sync client feature.",
                    fr: "Désactive la fonctionnalité rarement utilisée de synchronisation d’entreprise Work Folders.",
                    es: "Desactiva el cliente empresarial de sincronización Carpetas de trabajo poco utilizado.",
                    ru: "Отключает редко используемый корпоративный клиент синхронизации Work Folders.",
                    ar: "تعطيل ميزة عميل مزامنة مجلدات العمل المؤسسية نادرة الاستخدام."
                )
            )

        case "legacy":
            return (
                tr(
                    lang: lang,
                    zh: "禁用传统 Internet Explorer 兼容模式",
                    en: "Disable Legacy Internet Explorer Mode",
                    fr: "Désactiver le mode Internet Explorer hérité",
                    es: "Desactivar modo heredado de Internet Explorer",
                    ru: "Отключить устаревший режим Internet Explorer",
                    ar: "تعطيل وضع توافق Internet Explorer القديم"
                ),
                tr(
                    lang: lang,
                    zh: "移除退役的 IE 可选功能载荷。",
                    en: "Disable and remove the retired Internet Explorer optional feature payload.",
                    fr: "Supprime la charge utile de la fonctionnalité facultative Internet Explorer retirée.",
                    es: "Elimina la carga útil de la característica opcional retirada de Internet Explorer.",
                    ru: "Отключает и удаляет файлы устаревшего компонента Internet Explorer.",
                    ar: "إزالة حمولة ميزة Internet Explorer الاختيارية المتوقفة."
                )
            )

        case "recall-feature":
            return (
                tr(
                    lang: lang,
                    zh: "禁用并移除 Windows Recall 快照载荷",
                    en: "Disable & Remove Windows Recall Payload",
                    fr: "Désactiver et supprimer Windows Recall",
                    es: "Desactivar y eliminar Windows Recall",
                    ru: "Отключить и удалить компонент Windows Recall",
                    ar: "تعطيل وإزالة ميزة اللقطات الذكية Windows Recall"
                ),
                tr(
                    lang: lang,
                    zh: "彻底禁用 AI 屏幕快照记录组件并移除其存储载荷。",
                    en: "Disable the AI screen snapshot recording feature and remove its feature payload.",
                    fr: "Désactive complètement l’enregistrement de captures IA Recall et supprime ses fichiers.",
                    es: "Desactiva por completo el registro de capturas por IA Recall y elimina sus archivos.",
                    ru: "Полностью отключает ИИ-запись снимков экрана Recall и удаляет её хранилище.",
                    ar: "تعطيل مكون تسجيل لقطات الشاشة بالذكاء الاصطناعي بالكامل وإزالة ملفاته."
                )
            )

        case "hardware-bypass":
            return (
                tr(
                    lang: lang,
                    zh: "绕过 TPM 2.0 / 内存 / CPU / 安全启动硬件检测",
                    en: "Bypass TPM 2.0 / RAM / CPU / Secure Boot Checks",
                    fr: "Contourner les vérifications TPM 2.0 / RAM / CPU / Secure Boot",
                    es: "Omitir requisitos de TPM 2.0 / RAM / CPU / Arranque seguro",
                    ru: "Обход проверок TPM 2.0 / ОЗУ / ЦП / Secure Boot",
                    ar: "تجاوز فحوصات TPM 2.0 والذاكرة والمعالج والإقلاع الآمن"
                ),
                tr(
                    lang: lang,
                    zh: "在安装引导盘与系统中同时写入 LabConfig 绕过策略。UTM 小内存或未开虚拟 TPM 的虚拟机及老旧 PC 装机必选。",
                    en: "Write LabConfig bypass keys into both boot media and Windows. Essential for VMs without virtual TPM/large RAM and older PCs.",
                    fr: "Injecte les clés LabConfig dans le média d’installation et le système. Indispensable pour UTM sans vTPM et les anciens PC.",
                    es: "Escribe las claves LabConfig en el medio de arranque y el sistema. Esencial para VMs sin vTPM y PCs antiguos.",
                    ru: "Прописывает ключи обхода LabConfig в загрузочный и системный образы. Необходимо для ВМ без vTPM и старых ПК.",
                    ar: "كتابة مفاتيح التجاوز LabConfig في وسيط الإقلاع والنظام معًا؛ ضروري للأجهزة الافتراضية بدون TPM والحواسيب القديمة."
                )
            )

        case "ads":
            return (
                tr(
                    lang: lang,
                    zh: "禁止系统广告、开始菜单推荐与静默推广应用",
                    en: "Block System Ads, Start Recommendations & Silent Promos",
                    fr: "Bloquer publicités système, recommandations et apps sponsorisées",
                    es: "Bloquear anuncios del sistema, recomendaciones y apps patrocinadas",
                    ru: "Блокировать системную рекламу и тихую установку промо-приложений",
                    ar: "حظر إعلانات النظام وتوصيات قائمة ابدأ والتطبيقات الترويجية الصامتة"
                ),
                tr(
                    lang: lang,
                    zh: "关闭 ContentDeliveryManager 静默自动下载第三方推广软件（如 TikTok/Spotify 快捷方式）与锁屏聚焦广告。",
                    en: "Stop ContentDeliveryManager from silently downloading sponsored shortcuts and suppress Spotlight/Explorer ads.",
                    fr: "Empêche ContentDeliveryManager de télécharger silencieusement des applications tierces sponsorisées et des pubs d’écran de verrouillage.",
                    es: "Impide que ContentDeliveryManager descargue silenciosamente apps patrocinadas de terceros y anuncios en pantalla de bloqueo.",
                    ru: "Отключает фоновую загрузку рекламных ярлыков через ContentDeliveryManager и рекламу на экране блокировки.",
                    ar: "إيقاف التنزيل الصامت للتطبيقات الترويجية الخارجية وإعلانات شاشة القفل عبر ContentDeliveryManager."
                )
            )

        case "privacy":
            return (
                tr(
                    lang: lang,
                    zh: "关闭广告 ID、输入法云收集与个性化遥测",
                    en: "Disable Advertising ID, Input Cloud Collection & Telemetry",
                    fr: "Désactiver l’ID publicitaire, la collecte de saisie et la télémétrie",
                    es: "Desactivar ID de publicidad, recolección de escritura y telemetría",
                    ru: "Отключить рекламный ID, облачный сбор ввода и телеметрию",
                    ar: "تعطيل معرّف الإعلانات وجمع بيانات الإدخال السحابي والتتبع"
                ),
                tr(
                    lang: lang,
                    zh: "将诊断数据降至最低必需级别，关闭墨迹与键入文本隐式采集。",
                    en: "Reduce diagnostic data to the minimum required level and turn off implicit ink/typing personalization.",
                    fr: "Réduit les données de diagnostic au strict minimum et désactive la collecte implicite de frappe et d’encre.",
                    es: "Reduce los datos de diagnóstico al mínimo obligatorio y desactiva la recopilación implícita de texto y trazos.",
                    ru: "Снижает уровень диагностических данных до минимально необходимого и отключает сбор рукописного и клавиатурного ввода.",
                    ar: "تقليل بيانات التشخيص إلى الحد الأدنى المطلوب وإيقاف جمع نصوص الكتابة والحبر الرقمي."
                )
            )

        case "copilot":
            return (
                tr(
                    lang: lang,
                    zh: "策略级禁用 Windows Copilot 与 AI 分析",
                    en: "Disable Windows Copilot & AI Analysis via Policy",
                    fr: "Désactiver Windows Copilot et l’analyse IA par stratégie",
                    es: "Desactivar Windows Copilot y análisis de IA por directiva",
                    ru: "Отключить Windows Copilot и ИИ-анализ политиками",
                    ar: "تعطيل Windows Copilot وتحليلات الذكاء الاصطناعي عبر السياسات"
                ),
                tr(
                    lang: lang,
                    zh: "写入组策略关闭任务栏 Copilot 按钮与 Windows AI 数据分析。",
                    en: "Apply group policies to hide the taskbar Copilot button and disable Windows AI data analysis.",
                    fr: "Applique des stratégies de groupe masquant le bouton Copilot et désactivant l’analyse de données Windows AI.",
                    es: "Aplica directivas de grupo para ocultar el botón de Copilot y desactivar el análisis de datos de Windows AI.",
                    ru: "Применяет групповые политики для скрытия кнопки Copilot и отключения анализа данных Windows AI.",
                    ar: "تطبيق سياسات المجموعة لإخفاء زر Copilot من شريط المهام وتعطيل تحليل بيانات الذكاء الاصطناعي."
                )
            )

        case "widgets":
            return (
                tr(
                    lang: lang,
                    zh: "禁用任务栏小组件与新闻源 (Widgets)",
                    en: "Disable Taskbar Widgets & News Feeds",
                    fr: "Désactiver les Widgets et flux d’actualités de la barre des tâches",
                    es: "Desactivar Widgets y noticias de la barra de tareas",
                    ru: "Отключить мини-приложения (Widgets) и новостную ленту",
                    ar: "تعطيل الأدوات المصغرة (Widgets) وموجز الأخبار في شريط المهام"
                ),
                tr(
                    lang: lang,
                    zh: "通过策略彻底关闭高内存占用的后台 WebExperience 新闻信息流。",
                    en: "Turn off memory-heavy background WebExperience widgets and taskbar feeds via policy.",
                    fr: "Désactive par stratégie le flux WebExperience en arrière-plan gourmand en mémoire vive.",
                    es: "Desactiva mediante directiva el servicio de noticias WebExperience que consume memoria en segundo plano.",
                    ru: "Полностью отключает политикой фоновую ленту новостей WebExperience, потребляющую оперативную память.",
                    ar: "إيقاف خدمة موجز الأخبار الخلفية WebExperience كثيفة استهلاك الذاكرة عبر السياسات."
                )
            )

        case "search":
            return (
                tr(
                    lang: lang,
                    zh: "关闭搜索框网页联网建议与热点推荐",
                    en: "Disable Web Search Suggestions & Search Highlights",
                    fr: "Désactiver les suggestions web et tendances de recherche",
                    es: "Desactivar sugerencias web y puntos destacados de búsqueda",
                    ru: "Отключить веб-подсказки Bing и рекомендации в поиске",
                    ar: "إيقاف اقتراحات البحث عبر الويب وأبرز نتائج البحث"
                ),
                tr(
                    lang: lang,
                    zh: "保留极速本地文件搜索，禁止开始菜单搜索将关键词发往 Bing。",
                    en: "Keep fast local file search while stopping Start menu queries from being sent to Bing.",
                    fr: "Conserve une recherche locale rapide tout en empêchant l’envoi des requêtes du menu Démarrer vers Bing.",
                    es: "Mantiene una búsqueda local rápida evitando que las consultas del menú Inicio se envíen a Bing.",
                    ru: "Сохраняет быстрый локальный поиск файлов, запрещая отправку поисковых запросов из меню «Пуск» в Bing.",
                    ar: "الاحتفاظ بالبحث المحلي السريع عن الملفات ومنع إرسال عبارات البحث في قائمة ابدأ إلى Bing."
                )
            )

        case "onedrive":
            return (
                tr(
                    lang: lang,
                    zh: "组策略禁止 OneDrive 文件同步提示",
                    en: "Disable OneDrive Sync & Backup Prompts via Policy",
                    fr: "Désactiver la synchronisation OneDrive par stratégie",
                    es: "Desactivar avisos de sincronización de OneDrive por directiva",
                    ru: "Запретить синхронизацию и уведомления OneDrive политикой",
                    ar: "تعطيل مطالبات مزامنة OneDrive والنسخ الاحتياطي عبر السياسات"
                ),
                tr(
                    lang: lang,
                    zh: "禁用资源管理器侧边栏与备份弹窗干扰。",
                    en: "Prevent Explorer sidebar clutter and cloud backup nag prompts.",
                    fr: "Évite les rappels intrusifs de sauvegarde cloud dans l’Explorateur de fichiers.",
                    es: "Evita recordatorios molestos de copia en la nube en el Explorador de archivos.",
                    ru: "Убирает навязчивые предложения резервного копирования OneDrive в Проводнике.",
                    ar: "منع إشعارات النسخ الاحتياطي السحابي المزعجة في مستكشف الملفات."
                )
            )

        case "edge":
            return (
                tr(
                    lang: lang,
                    zh: "净化 Edge 首次启动向导、侧边栏与推荐流",
                    en: "Suppress Edge First-Run Wizard, Sidebar & Promos",
                    fr: "Masquer l’assistant de premier lancement et la barre latérale d’Edge",
                    es: "Ocultar asistente inicial, barra lateral y promociones de Edge",
                    ru: "Скрыть мастер первого запуска, боковую панель и рекламу Edge",
                    ar: "إخفاء معالج التشغيل الأول والشريط الجانبي والتوصيات في Edge"
                ),
                tr(
                    lang: lang,
                    zh: "隐藏 Edge 烦人的首次运行导入向导、购物侧边栏与后台推荐，同时保持 WebView2 兼容性。",
                    en: "Hide Edge's first-run import wizard, shopping sidebar, and background recommendations while keeping WebView2 compatible.",
                    fr: "Masque l’assistant d’importation initial, la barre latérale et les recommandations d’Edge tout en préservant WebView2.",
                    es: "Oculta el asistente inicial, la barra lateral de compras y recomendaciones de Edge manteniendo compatibilidad con WebView2.",
                    ru: "Отключает навязчивый мастер первого запуска, боковую панель и рекомендации Edge, сохраняя совместимость с WebView2.",
                    ar: "إخفاء معالج الاستيراد المزعج والشريط الجانبي والتوصيات في Edge مع الحفاظ على توافق WebView2."
                )
            )

        case "oobe":
            return (
                tr(
                    lang: lang,
                    zh: "精简首次开机隐私盘问与完成设置骚扰弹窗",
                    en: "Skip OOBE Privacy Prompts & Post-Setup Nag Screens",
                    fr: "Ignorer les écrans de confidentialité OOBE et rappels de configuration",
                    es: "Omitir pantallas de privacidad OOBE y avisos posteriores al inicio",
                    ru: "Убрать опросы конфиденциальности OOBE и навязчивые окна настройки",
                    ar: "تخطي أسئلة الخصوصية عند التشغيل الأول ونوافذ استكمال الإعداد المزعجة"
                ),
                tr(
                    lang: lang,
                    zh: "跳过冗长的开机隐私推广问答，隐藏任务栏聊天图标（不自动替你创建账户或同意许可协议）。",
                    en: "Suppress lengthy OOBE privacy/promotional screens and hide the taskbar Chat icon without auto-accepting the EULA.",
                    fr: "Ignore les longs questionnaires promotionnels au premier démarrage et masque l’icône Conversation sans accepter le CLUF à votre place.",
                    es: "Omite los extensos cuestionarios promocionales iniciales y oculta el icono de Chat sin aceptar la licencia por ti.",
                    ru: "Пропускает длинные рекламные опросы при первом запуске и скрывает значок чата без автопринятия лицензии.",
                    ar: "تخطي شاشات الخصوصية الترويجية الطويلة وإخفاء أيقونة الدردشة دون إنشاء حساب تلقائي أو قبول الاتفاقية نيابةً عنك."
                )
            )

        case "reserved-storage":
            return (
                tr(
                    lang: lang,
                    zh: "禁用 7GB 系统更新预留空间 (Reserved Storage)",
                    en: "Disable ~7 GB Reserved Storage",
                    fr: "Désactiver l’espace réservé de ~7 Go (Reserved Storage)",
                    es: "Desactivar ~7 GB de almacenamiento reservado",
                    ru: "Отключить резервирование ~7 ГБ диска (Reserved Storage)",
                    ar: "تعطيل المساحة المحجوزة للتحديثات (~7 غيغابايت)"
                ),
                tr(
                    lang: lang,
                    zh: "禁止 Windows 预先强占约 7GB 虚拟磁盘空间，显著降低 Mac 虚拟机磁盘文件膨胀。",
                    en: "Prevent Windows from pre-allocating ~7 GB of disk space, dramatically reducing Mac virtual disk bloat.",
                    fr: "Empêche Windows de pré-allouer environ 7 Go d’espace disque, réduisant fortement la taille du disque virtuel Mac.",
                    es: "Evita que Windows reserve unos 7 GB de espacio, reduciendo notablemente el tamaño del disco virtual en Mac.",
                    ru: "Запрещает Windows заранее резервировать около 7 ГБ места, существенно уменьшая размер виртуального диска на Mac.",
                    ar: "منع Windows من حجز نحو 7 غيغابايت من مساحة القرص مسبقًا مما يقلل تضخم القرص الافتراضي على Mac."
                )
            )

        case "device-encryption":
            return (
                tr(
                    lang: lang,
                    zh: "禁止自动开启 BitLocker 全盘加密",
                    en: "Disable Automatic BitLocker Device Encryption",
                    fr: "Désactiver le chiffrement automatique BitLocker",
                    es: "Desactivar cifrado automático de dispositivo BitLocker",
                    ru: "Отключить автоматическое шифрование диска BitLocker",
                    ar: "منع التشفير التلقائي للقرص عبر BitLocker"
                ),
                tr(
                    lang: lang,
                    zh: "防止无人值守安装后自动加密虚拟磁盘，降低 Apple Silicon 虚拟化 I/O 开销并方便宿主机挂载排查。",
                    en: "Prevent automatic virtual disk encryption after setup, lowering Apple Silicon virtualization I/O overhead.",
                    fr: "Empêche le chiffrement automatique du disque virtuel après l’installation, réduisant la surcharge E/S sous Apple Silicon.",
                    es: "Evita el cifrado automático del disco virtual tras la instalación, reduciendo la sobrecarga de E/S en Apple Silicon.",
                    ru: "Предотвращает автошифрование виртуального диска после установки, снижая нагрузку ввода-вывода на Apple Silicon.",
                    ar: "منع تشفير القرص الافتراضي تلقائيًا بعد التثبيت لتقليل عبء الإدخال والإخراج على معالجات Apple Silicon."
                )
            )

        case "remove-wow64":
            return (
                tr(
                    lang: lang,
                    zh: "移除 32 位应用兼容层 (SysWOW64 / SysArm32)",
                    en: "Remove 32-Bit Application Support (WOW64)",
                    fr: "Supprimer la prise en charge des applications 32 bits (WOW64)",
                    es: "Eliminar soporte de aplicaciones de 32 bits (WOW64)",
                    ru: "Удалить поддержку 32-разрядных приложений (WOW64)",
                    ar: "إزالة دعم تطبيقات 32 بت (SysWOW64)"
                ),
                tr(
                    lang: lang,
                    zh: "直接删除 SysWOW64 / SysArm32 与 32 位公共目录。仅限自定义模式，移除后所有 32 位软件与安装器将无法运行。",
                    en: "Remove SysWOW64 / SysArm32 and 32-bit shared files. Custom only; 32-bit applications and installers will not work.",
                    fr: "Supprime SysWOW64 / SysArm32 et les fichiers partagés 32 bits. Mode Custom uniquement ; les logiciels 32 bits ne fonctionneront plus.",
                    es: "Elimina SysWOW64 / SysArm32 y archivos compartidos de 32 bits. Solo en Custom; las apps de 32 bits dejarán de funcionar.",
                    ru: "Удаляет SysWOW64 / SysArm32 и общие 32-битные файлы. Только в Custom; 32-разрядные программы работать не будут.",
                    ar: "إزالة مجلدات SysWOW64 وملفات 32 بت المشتركة. للوضع المخصّص فقط؛ لن تعمل تطبيقات 32 بت بعد ذلك."
                )
            )

        case "remove-desktop-netfx":
            return (
                tr(
                    lang: lang,
                    zh: "移除桌面版 .NET Framework 运行库",
                    en: "Remove Desktop .NET Framework Payloads",
                    fr: "Supprimer le .NET Framework de bureau",
                    es: "Eliminar cargas de .NET Framework de escritorio",
                    ru: "Удалить настольный .NET Framework",
                    ar: "إزالة حزم .NET Framework لسطح المكتب"
                ),
                tr(
                    lang: lang,
                    zh: "删除 Windows\\Microsoft.NET 与全局程序集缓存 (assembly)。依赖 .NET Framework 的传统桌面程序与 PowerShell 模块可能无法运行。",
                    en: "Remove Windows\\Microsoft.NET and native assembly caches. Managed desktop applications may stop working.",
                    fr: "Supprime Windows\\Microsoft.NET et les caches d’assemblages. Les applications .NET classiques risquent de ne plus fonctionner.",
                    es: "Elimina Windows\\Microsoft.NET y cachés de ensamblados. Las aplicaciones de escritorio .NET pueden dejar de funcionar.",
                    ru: "Удаляет Windows\\Microsoft.NET и кэши сборок. Программы на базе классического .NET могут перестать запускаться.",
                    ar: "حذف مجلدات Windows\\Microsoft.NET وذاكرة التجميعات؛ قد تتوقف تطبيقات سطح المكتب المعتمدة على .NET عن العمل."
                )
            )

        case "remove-ime-files":
            return (
                tr(
                    lang: lang,
                    zh: "移除内置亚洲语言输入法引擎 (IME)",
                    en: "Remove Asian-Language Input Method Files (IME)",
                    fr: "Supprimer les méthodes de saisie asiatiques (IME)",
                    es: "Eliminar métodos de entrada de idiomas asiáticos (IME)",
                    ru: "Удалить файлы азиатских методов ввода (IME)",
                    ar: "إزالة ملفات طرق الإدخال الآسيوية (IME)"
                ),
                tr(
                    lang: lang,
                    zh: "直接删除 Windows\\IME 与 System32\\InputMethod 目录。若您需要使用中文、日文或韩文输入法，请勿勾选此项！",
                    en: "Remove Windows\\IME and InputMethod payloads. Keep this unchecked if you need Chinese, Japanese, or Korean input methods.",
                    fr: "Supprime Windows\\IME et InputMethod. Ne cochez pas cette option si vous utilisez la saisie chinoise, japonaise ou coréenne.",
                    es: "Elimina Windows\\IME e InputMethod. No marques esta opción si necesitas métodos de entrada chino, japonés o coreano.",
                    ru: "Удаляет каталоги Windows\\IME и InputMethod. Не отмечайте, если вам нужен ввод на китайском, японском или корейском.",
                    ar: "حذف مجلدات Windows\\IME وInputMethod. اترك هذا الخيار غير محدد إذا كنت بحاجة إلى طرق الإدخال الصينية أو اليابانية أو الكورية."
                )
            )

        case "remove-speech-files":
            return (
                tr(
                    lang: lang,
                    zh: "移除离线语音引擎与 OCR 目录",
                    en: "Remove Speech Synthesis & OCR Engine Files",
                    fr: "Supprimer les moteurs vocaux et fichiers OCR",
                    es: "Eliminar motores de voz y archivos OCR",
                    ru: "Удалить голосовые движки и файлы OCR",
                    ar: "إزالة محركات النطق وملفات التعرف الضوئي OCR"
                ),
                tr(
                    lang: lang,
                    zh: "直接删除 Windows\\Speech、Speech_OneCore 与 Windows\\OCR 目录。语音听写、屏幕朗读与离线文字识别将不可用。",
                    en: "Delete Windows\\Speech, Speech_OneCore, and Windows\\OCR directly. Voice typing, narrator voices, and OCR may stop working.",
                    fr: "Supprime directement Windows\\Speech, Speech_OneCore et Windows\\OCR. La dictée vocale et la lecture d’écran ne fonctionneront plus.",
                    es: "Elimina directamente Windows\\Speech, Speech_OneCore y Windows\\OCR. El dictado por voz, narrador y OCR dejarán de funcionar.",
                    ru: "Напрямую удаляет Windows\\Speech, Speech_OneCore и Windows\\OCR. Голосовой ввод, диктор и распознавание текста перестанут работать.",
                    ar: "حذف مجلدات Windows\\Speech وSpeech_OneCore وWindows\\OCR مباشرةً؛ قد يتوقف الإملاء الصوتي وقارئ الشاشة عن العمل."
                )
            )

        case "remove-print-drivers":
            return (
                tr(
                    lang: lang,
                    zh: "移除内置打印机与扫描仪驱动库",
                    en: "Remove Printer & Scanner Driver-Store Payloads",
                    fr: "Supprimer les pilotes d’imprimantes et de scanners intégrés",
                    es: "Eliminar controladores de impresoras y escáneres incluidos",
                    ru: "Удалить встроенные драйверы принтеров и сканеров",
                    ar: "إزالة تعريفات الطابعات والماسحات الضوئية المدمجة"
                ),
                tr(
                    lang: lang,
                    zh: "删除 DriverStore 中 prn/scan/mfd 开头的打印扫描驱动包（保留磁盘、USB、显卡与网卡驱动），大幅缩减驱动库体积。",
                    en: "Remove prn/scan/mfd driver-store packages while keeping storage, USB, display, and network drivers.",
                    fr: "Supprime les paquets prn/scan/mfd du magasin de pilotes tout en conservant les pilotes stockage, USB, affichage et réseau.",
                    es: "Elimina paquetes prn/scan/mfd del almacén de controladores conservando almacenamiento, USB, pantalla y red.",
                    ru: "Удаляет пакеты prn/scan/mfd из хранилища драйверов, сохраняя драйверы дисков, USB, видео и сети.",
                    ar: "إزالة حزم تعريفات الطباعة والمسح من مخزن التعريفات مع الحفاظ على تعريفات التخزين وUSB والشاشة والشبكة."
                )
            )

        case "remove-extra-media":
            return (
                tr(
                    lang: lang,
                    zh: "移除自带壁纸、系统提示音、帮助与附加指针",
                    en: "Remove Bundled Wallpapers, Sounds, Help & Cursors",
                    fr: "Supprimer fonds d’écran, sons système, aide et curseurs",
                    es: "Eliminar fondos de pantalla, sonidos, ayuda y cursores",
                    ru: "Удалить стандартные обои, звуки, справку и курсоры",
                    ar: "إزالة الخلفيات المدمجة وأصوات النظام وملفات المساعدة والمؤشرات"
                ),
                tr(
                    lang: lang,
                    zh: "直接删除 Windows\\Web（壁纸）、Windows\\Media（音效）、Windows\\Help 与 Windows\\Cursors 以极致压缩镜像体积。",
                    en: "Delete Windows\\Web, Windows\\Media, Windows\\Help, and Windows\\Cursors for maximum image size reduction.",
                    fr: "Supprime Windows\\Web, Windows\\Media, Windows\\Help et Windows\\Cursors pour réduire au maximum la taille de l’image.",
                    es: "Elimina Windows\\Web, Windows\\Media, Windows\\Help y Windows\\Cursors para reducir al máximo el tamaño de la imagen.",
                    ru: "Удаляет каталоги Windows\\Web, Windows\\Media, Windows\\Help и Windows\\Cursors для максимального уменьшения образа.",
                    ar: "حذف مجلدات Windows\\Web وWindows\\Media وWindows\\Help وWindows\\Cursors لتقليص حجم الصورة إلى أقصى حد."
                )
            )

        default:
            return (id, id)
        }
    }
}
