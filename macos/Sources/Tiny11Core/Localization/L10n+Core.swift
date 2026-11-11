import Foundation

public extension L10n {
    // MARK: - BuildMode

    static func buildModeTitle(_ mode: BuildMode, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch mode {
        case .macVM:
            return tr(
                lang: lang,
                zh: "Tiny11 · Mac 虚拟机优化版",
                en: "Tiny11 · Mac VM Optimized",
                fr: "Tiny11 · Optimisé VM Mac",
                es: "Tiny11 · Optimizado para VM Mac",
                ru: "Tiny11 · Оптимизация для ВМ Mac",
                ar: "Tiny11 · محسّن للأجهزة الافتراضية على Mac"
            )
        case .tiny11:
            return tr(
                lang: lang,
                zh: "Tiny11 · 标准精简版",
                en: "Tiny11 · Standard",
                fr: "Tiny11 · Édition standard",
                es: "Tiny11 · Edición estándar",
                ru: "Tiny11 · Стандартная сборка",
                ar: "Tiny11 · الإصدار القياسي"
            )
        case .tiny11Core:
            return tr(
                lang: lang,
                zh: "Tiny11 Core · 极限测试版",
                en: "Tiny11 Core · Extreme Sandbox",
                fr: "Tiny11 Core · Édition extrême",
                es: "Tiny11 Core · Edición extrema",
                ru: "Tiny11 Core · Экстремальная сборка",
                ar: "Tiny11 Core · الإصدار المصغّر الأقصى"
            )
        case .custom:
            return tr(
                lang: lang,
                zh: "Custom · 自定义构建",
                en: "Custom · Tailored Build",
                fr: "Custom · Configuration sur mesure",
                es: "Custom · Compilación personalizada",
                ru: "Custom · Пользовательская сборка",
                ar: "Custom · بناء مخصّص"
            )
        }
    }

    static func buildModeBadge(_ mode: BuildMode, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch mode {
        case .macVM:
            return tr(
                lang: lang,
                zh: "推荐 · Parallels / Fusion / UTM",
                en: "Recommended · Parallels / Fusion / UTM",
                fr: "Recommandé · Parallels / Fusion / UTM",
                es: "Recomendado · Parallels / Fusion / UTM",
                ru: "Рекомендуется · Parallels / Fusion / UTM",
                ar: "موصى به · Parallels / Fusion / UTM"
            )
        case .tiny11:
            return tr(
                lang: lang,
                zh: "PC 装机通用",
                en: "General PC & VM",
                fr: "PC & usage général",
                es: "Uso general en PC",
                ru: "Универсальный для ПК",
                ar: "عام للحواسيب الشخصية"
            )
        case .tiny11Core:
            return tr(
                lang: lang,
                zh: "不可更新 · 仅限测试",
                en: "No Updates · Testing Only",
                fr: "Sans mises à jour · Test seul",
                es: "Sin actualizaciones · Solo pruebas",
                ru: "Без обновлений · Только тесты",
                ar: "بلا تحديثات · للاختبار فقط"
            )
        case .custom:
            return tr(
                lang: lang,
                zh: "按需勾选",
                en: "Pick & Choose",
                fr: "À la carte",
                es: "A medida",
                ru: "Выбор вручную",
                ar: "اختيار حر"
            )
        }
    }

    static func buildModeSummary(_ mode: BuildMode, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch mode {
        case .macVM:
            return tr(
                lang: lang,
                zh: "专为 Apple Silicon 虚拟机调优：移除 20+ 预装臃肿应用与广告遥测，自动绕过 TPM/内存限制与 OOBE 无网卡强制联网死锁，关闭自动加密与预留空间（立省约 7GB 虚拟磁盘），完整保留 Guest Tools 驱动与系统更新能力。",
                en: "Tuned for Apple Silicon VMs: removes 20+ preinstalled bloatware apps and telemetry, bypasses TPM/RAM checks and offline OOBE deadlocks, disables BitLocker & ~7 GB reserved storage, while preserving Guest Tools compatibility and Windows Update.",
                fr: "Conçu pour les VM Apple Silicon : supprime plus de 20 applications superflues et la télémétrie, contourne les limites TPM/RAM et le blocage réseau OOBE, économise ~7 Go de disque virtuel et préserve les Guest Tools ainsi que Windows Update.",
                es: "Optimizado para VMs en Apple Silicon: elimina más de 20 apps preinstaladas y telemetría, omite bloqueos de TPM/RAM y red en OOBE, ahorra ~7 GB de disco virtual y mantiene total compatibilidad con Guest Tools y Windows Update.",
                ru: "Оптимизировано для ВМ на Apple Silicon: удаляет более 20 предустановленных программ и телеметрию, обходит проверки TPM/ОЗУ и блокировку OOBE без сети, экономит ~7 ГБ диска и сохраняет поддержку Guest Tools и Windows Update.",
                ar: "مُحسَّن للأجهزة الافتراضية على Apple Silicon: يزيل أكثر من 20 تطبيقًا مدمجًا والتتبع، ويتجاوز قيود TPM والذاكرة وإجبار الاتصال بالإنترنت، ويوفر نحو 7 غيغابايت من القرص مع الحفاظ على التحديثات وأدوات الضيف."
            )
        case .tiny11:
            return tr(
                lang: lang,
                zh: "复刻原版 Tiny11 规则：彻底移除预装应用与 OneDrive 安装程序，可按需选择是否精简 Microsoft Edge，完整保留 Windows Update、Defender 与系统恢复能力。",
                en: "Follows classic Tiny11 rules: removes bundled apps and OneDrive installers, lets you choose whether to strip Microsoft Edge, and preserves Windows Update, Defender, and system recovery.",
                fr: "Reprend les règles classiques de Tiny11 : supprime les applications préinstallées et l’installateur OneDrive, permet de choisir ou non l’allègement d’Edge, et conserve Windows Update, Defender et la récupération.",
                es: "Sigue las reglas clásicas de Tiny11: elimina apps preinstaladas y el instalador de OneDrive, permite elegir si recortar Microsoft Edge, y conserva Windows Update, Defender y la recuperación.",
                ru: "Классические правила Tiny11: удаляет предустановленные приложения и установщик OneDrive, позволяет выбрать, удалять ли Microsoft Edge, сохраняя Windows Update, Defender и среду восстановления.",
                ar: "يطبق قواعد Tiny11 القياسية: يزيل التطبيقات المدمجة ومثبت OneDrive، مع خيار تحديد إزالة متصفح Edge أو الإبقاء عليه، مع الحفاظ على التحديثات وDefender واسترداد النظام."
            )
        case .tiny11Core:
            return tr(
                lang: lang,
                zh: "在标准版基础上进一步裁剪 WinSxS 组件库、移除 WinRE 恢复镜像并禁用 Windows Update 与 Defender。体积最小，但安装后无法打补丁或添加功能。",
                en: "Aggressively prunes the WinSxS component store, removes WinRE recovery, and disables Windows Update and Defender. Smallest footprint, but cannot install updates or optional features afterward.",
                fr: "Élague en profondeur le magasin WinSxS, supprime l’environnement WinRE et désactive Windows Update ainsi que Defender. Taille minimale, mais aucune mise à jour ni fonctionnalité ne pourra être installée.",
                es: "Recorta profundamente el almacén WinSxS, elimina la recuperación WinRE y desactiva Windows Update y Defender. Tamaño mínimo, pero no podrá instalar parches ni características adicionales.",
                ru: "Глубоко урезает хранилище компонентов WinSxS, удаляет среду восстановления WinRE и отключает Windows Update и Defender. Минимальный размер, но установка обновлений невозможна.",
                ar: "يقلّص مخزن مكونات WinSxS بعمق ويزيل بيئة الاسترداد WinRE ويعطّل Windows Update وDefender. أصغر حجم ممكن لكن لا يمكن تثبيت تحديثات أو ميزات لاحقًا."
            )
        case .custom:
            return tr(
                lang: lang,
                zh: "从空白方案起步，自由勾选要移除的预装应用、可选功能、系统文件、隐私策略以及是否启用 Core 级深度组件裁剪。",
                en: "Start from a clean slate and freely select which bundled apps, optional features, system binaries, privacy policies, or Core component pruning to apply.",
                fr: "Partez d’une feuille blanche et cochez librement les applications, fonctionnalités facultatives, fichiers système, stratégies de confidentialité et options Core souhaités.",
                es: "Empieza desde cero y selecciona libremente qué aplicaciones, características opcionales, archivos del sistema, directivas de privacidad o recorte Core aplicar.",
                ru: "Начните с чистого листа и вручную отметьте удаляемые приложения, дополнительные компоненты, системные файлы, политики конфиденциальности и режим Core.",
                ar: "ابدأ من مخطط فارغ واختر بحرية التطبيقات والميزات الاختيارية وملفات النظام وسياسات الخصوصية أو تقليص Core العميق."
            )
        }
    }

    // MARK: - CompressionMode & Architecture & Phase

    static func compressionTitle(_ mode: CompressionMode, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch mode {
        case .recoveryESD:
            return tr(
                lang: lang,
                zh: "极限固态压缩 (Recovery ESD)",
                en: "Solid Maximum Compression (Recovery ESD)",
                fr: "Compression solide maximale (Recovery ESD)",
                es: "Compresión sólida máxima (Recovery ESD)",
                ru: "Максимальное непрерывное сжатие (Recovery ESD)",
                ar: "ضغط صلب أقصى (Recovery ESD)"
            )
        case .maximumWIM:
            return tr(
                lang: lang,
                zh: "高压缩可挂载 (Maximum WIM)",
                en: "High Compression Mountable (Maximum WIM)",
                fr: "Haute compression montable (Maximum WIM)",
                es: "Alta compresión montable (Maximum WIM)",
                ru: "Высокое сжатие с поддержкой монтирования (Maximum WIM)",
                ar: "ضغط عالٍ قابل للتركيب (Maximum WIM)"
            )
        case .fastWIM:
            return tr(
                lang: lang,
                zh: "极速构建 (Fast WIM)",
                en: "Fastest Build (Fast WIM)",
                fr: "Création ultra-rapide (Fast WIM)",
                es: "Compilación rápida (Fast WIM)",
                ru: "Быстрая сборка (Fast WIM)",
                ar: "بناء فائق السرعة (Fast WIM)"
            )
        }
    }

    static func compressionSubtitle(_ mode: CompressionMode, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch mode {
        case .recoveryESD:
            return tr(
                lang: lang,
                zh: "输出 install.esd（LZMS 固态压缩），ISO 体积最小（约 2.8~3.3 GiB），多核全力加速但耗时较长。",
                en: "Outputs install.esd (LZMS solid compression) for the smallest ISO (~2.8–3.3 GiB); uses all CPU cores but takes longer.",
                fr: "Génère install.esd (compression solide LZMS) pour l’ISO le plus léger (~2,8–3,3 Gio) ; sollicite tous les cœurs mais prend plus de temps.",
                es: "Genera install.esd (compresión sólida LZMS) logrando el ISO más pequeño (~2,8–3,3 GiB); usa todos los núcleos pero tarda más.",
                ru: "Создаёт install.esd (непрерывное сжатие LZMS) с минимальным размером ISO (~2,8–3,3 ГиБ); нагружает все ядра и занимает больше времени.",
                ar: "يُنتج ملف install.esd بضغط LZMS الصلب للحصول على أصغر حجم ISO (~2.8–3.3 غيغابايت)؛ يستغل جميع الأنوية ويستغرق وقتًا أطول."
            )
        case .maximumWIM:
            return tr(
                lang: lang,
                zh: "输出 install.wim（LZX 压缩），兼顾较小体积与后续二次离线维护。",
                en: "Outputs install.wim (LZX compression), balancing compact size with future offline servicing.",
                fr: "Génère install.wim (compression LZX), équilibrant taille réduite et maintenance hors ligne ultérieure.",
                es: "Genera install.wim (compresión LZX), equilibrando buen tamaño con mantenimiento sin conexión posterior.",
                ru: "Создаёт install.wim (сжатие LZX), сочетая компактный размер с возможностью последующего обслуживания образа.",
                ar: "يُنتج ملف install.wim بضغط LZX، موازنًا بين الحجم المدمج وإمكانية التعديل المستقبلي دون اتصال."
            )
        case .fastWIM:
            return tr(
                lang: lang,
                zh: "输出 install.wim（XPRESS 快速压缩），打包速度最快，适合本地虚拟机快速装机验证。",
                en: "Outputs install.wim (XPRESS fast compression) for the quickest turnaround during local VM testing.",
                fr: "Génère install.wim (compression rapide XPRESS), idéal pour tester rapidement une installation en VM locale.",
                es: "Genera install.wim (compresión rápida XPRESS), la opción más veloz para pruebas rápidas en VM local.",
                ru: "Создаёт install.wim (быстрое сжатие XPRESS) с максимальной скоростью упаковки для быстрой проверки в ВМ.",
                ar: "يُنتج ملف install.wim بضغط XPRESS السريع، وهو الأسرع للتجربة الفورية على الأجهزة الافتراضية المحلية."
            )
        }
    }

    static func architectureDisplayName(_ arch: ImageArchitecture, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch arch {
        case .arm64:
            return tr(
                lang: lang,
                zh: "ARM64 (Apple Silicon 虚拟机原生架构)",
                en: "ARM64 (Native Apple Silicon VM Architecture)",
                fr: "ARM64 (Architecture native VM Apple Silicon)",
                es: "ARM64 (Arquitectura nativa para VM Apple Silicon)",
                ru: "ARM64 (Нативная архитектура ВМ для Apple Silicon)",
                ar: "ARM64 (معمارية أصلية لأجهزة Apple Silicon الافتراضية)"
            )
        case .x64:
            return tr(
                lang: lang,
                zh: "x64 / AMD64 (Intel/AMD PC 架构)",
                en: "x64 / AMD64 (Intel/AMD PC Architecture)",
                fr: "x64 / AMD64 (Architecture PC Intel/AMD)",
                es: "x64 / AMD64 (Arquitectura PC Intel/AMD)",
                ru: "x64 / AMD64 (Архитектура ПК Intel/AMD)",
                ar: "x64 / AMD64 (معمارية حواسيب Intel/AMD)"
            )
        }
    }

    static func buildPhaseTitle(_ phase: BuildPhaseId, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch phase {
        case .prepareMedia:
            return tr(
                lang: lang,
                zh: "1. 解包与暂存安装介质",
                en: "1. Unpack & Stage Installation Media",
                fr: "1. Préparation du média d’installation",
                es: "1. Preparar medios de instalación",
                ru: "1. Подготовка установочного носителя",
                ar: "1. تجهيز ملفات وسيط التثبيت"
            )
        case .exportEdition:
            return tr(
                lang: lang,
                zh: "2. 导出单版本工作镜像",
                en: "2. Export Single-Edition Working Image",
                fr: "2. Exportation de l’édition cible",
                es: "2. Exportar edición de trabajo única",
                ru: "2. Экспорт выбранной редакции в рабочий образ",
                ar: "2. تصدير النسخة المختارة إلى صورة عمل"
            )
        case .modifyRegistry:
            return tr(
                lang: lang,
                zh: "3. 注入离线注册表策略与防重装锁",
                en: "3. Inject Offline Registry Policies & Locks",
                fr: "3. Injection des stratégies du registre hors ligne",
                es: "3. Inyectar directivas de registro sin conexión",
                ru: "3. Инъекция политик офлайн-реестра и блокировок",
                ar: "3. حقن سياسات السجل ومنع إعادة تثبيت التطبيقات"
            )
        case .pruneImage:
            return tr(
                lang: lang,
                zh: "4. 流式裁剪预装应用与冗余文件",
                en: "4. Stream-Prune Bundled Apps & Redundant Files",
                fr: "4. Suppression des applications et fichiers superflus",
                es: "4. Recortar apps preinstaladas y archivos redundantes",
                ru: "4. Потоковое удаление приложений и лишних файлов",
                ar: "4. إزالة التطبيقات المدمجة والملفات الزائدة"
            )
        case .configureBoot:
            return tr(
                lang: lang,
                zh: "5. 配置应答文件与引导环境",
                en: "5. Configure Unattend & Boot Environment",
                fr: "5. Configuration du fichier de réponses et du démarrage",
                es: "5. Configurar respuesta desatendida y arranque",
                ru: "5. Настройка файла ответов и загрузочной среды",
                ar: "5. إعداد ملف التثبيت التلقائي وبيئة الإقلاع"
            )
        case .compressImage:
            return tr(
                lang: lang,
                zh: "6. 多核压缩最终系统镜像",
                en: "6. Multi-Core Compress Final System Image",
                fr: "6. Compression multicœur de l’image finale",
                es: "6. Comprimir imagen final en multinúcleo",
                ru: "6. Многопоточное сжатие итогового образа",
                ar: "6. ضغط صورة النظام النهائية متعدد الأنوية"
            )
        case .createISO:
            return tr(
                lang: lang,
                zh: "7. 封装 UEFI/UDF 可引导 ISO",
                en: "7. Build Bootable UEFI/UDF ISO",
                fr: "7. Création de l’ISO amorçable UEFI/UDF",
                es: "7. Empaquetar ISO arrancable UEFI/UDF",
                ru: "7. Сборка загрузочного UEFI/UDF ISO",
                ar: "7. بناء ملف ISO القابل للإقلاع UEFI/UDF"
            )
        case .verifyOutput:
            return tr(
                lang: lang,
                zh: "8. 校验结构与生成报告",
                en: "8. Verify ISO Structure & Checksum",
                fr: "8. Vérification de l’ISO et somme SHA-256",
                es: "8. Verificar estructura ISO y suma SHA-256",
                ru: "8. Проверка структуры ISO и расчёт SHA-256",
                ar: "8. التحقق من بنية ISO وحساب SHA-256"
            )
        }
    }

    // MARK: - Validation & Errors

    static func unsupportedImageError(name: String, build: Int, installationType: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "仅支持 Windows 11 客户端镜像（Build 22621 / 22H2 及以上，ARM64 或 x64）。当前镜像为 \(name) (Build \(build), \(installationType))。",
            en: "Only Windows 11 Client images (Build 22621 / 22H2 or newer, ARM64 or x64) are supported. Current image: \(name) (Build \(build), \(installationType)).",
            fr: "Seules les images clientes Windows 11 (Build 22621 / 22H2 ou supérieur, ARM64 ou x64) sont prises en charge. Image actuelle : \(name) (Build \(build), \(installationType)).",
            es: "Solo se admiten imágenes cliente de Windows 11 (Build 22621 / 22H2 o superior, ARM64 o x64). Imagen actual: \(name) (Build \(build), \(installationType)).",
            ru: "Поддерживаются только клиентские образы Windows 11 (сборка 22621 / 22H2 и новее, ARM64 или x64). Текущий образ: \(name) (Build \(build), \(installationType)).",
            ar: "تُدعم صور Windows 11 لإصدارات العميل فقط (البنية 22621 / 22H2 أو أحدث، ARM64 أو x64). الصورة الحالية: \(name) (البنية \(build)، \(installationType))."
        )
    }

    static func unsupportedSchemaError(_ version: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "不支持的配方版本：\(version)。",
            en: "Unsupported recipe schema version: \(version).",
            fr: "Version de schéma de recette non prise en charge : \(version).",
            es: "Versión de esquema de receta no compatible: \(version).",
            ru: "Неподдерживаемая версия схемы рецепта: \(version).",
            ar: "إصدار مخطط الوصفة غير مدعوم: \(version)."
        )
    }

    static func emptySourcePathError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "请先选择有效的 Windows 11 ISO 文件或解压后的安装目录。",
            en: "Please select a valid Windows 11 ISO file or extracted setup directory first.",
            fr: "Veuillez d’abord sélectionner un fichier ISO Windows 11 valide ou un dossier d’installation extrait.",
            es: "Selecciona primero un archivo ISO válido de Windows 11 o una carpeta de instalación extraída.",
            ru: "Сначала выберите корректный ISO-файл Windows 11 или распакованную папку установки.",
            ar: "يرجى اختيار ملف ISO صالح لنظام Windows 11 أو مجلد تثبيت مستخرج أولاً."
        )
    }

    static func invalidImageIndexError(_ index: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "镜像版本索引无效：\(index)。",
            en: "Invalid image edition index: \(index).",
            fr: "Index d’édition d’image invalide : \(index).",
            es: "Índice de edición de imagen no válido: \(index).",
            ru: "Недопустимый индекс редакции образа: \(index).",
            ar: "فهرس نسخة الصورة غير صالح: \(index)."
        )
    }

    static func emptyWorkspacePathError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "请指定有效的工作缓存目录。",
            en: "Please specify a valid temporary workspace directory.",
            fr: "Veuillez indiquer un dossier de travail temporaire valide.",
            es: "Especifica un directorio temporal de trabajo válido.",
            ru: "Укажите корректный временный рабочий каталог.",
            ar: "يرجى تحديد مجلد عمل مؤقت صالح."
        )
    }

    static func invalidOutputPathError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "输出路径必须是新的 .iso 文件路径。",
            en: "The output path must point to a new .iso file.",
            fr: "Le chemin de sortie doit pointer vers un nouveau fichier .iso.",
            es: "La ruta de salida debe ser un nuevo archivo .iso.",
            ru: "Путь вывода должен указывать на новый файл .iso.",
            ar: "يجب أن يشير مسار الإخراج إلى ملف .iso جديد."
        )
    }

    static func outputFileAlreadyExistsError(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "输出 ISO 文件已存在（不会覆盖已有文件）：\(path)",
            en: "Output ISO already exists (existing files are never overwritten): \(path)",
            fr: "Le fichier ISO de sortie existe déjà (aucun écrasement) : \(path)",
            es: "El archivo ISO de salida ya existe (nunca se sobrescribe): \(path)",
            ru: "Выходной ISO-файл уже существует (существующие файлы не перезаписываются): \(path)",
            ar: "ملف ISO الناتج موجود مسبقًا (لن يتم استبدال الملفات الحالية): \(path)"
        )
    }

    static func outputSameAsSourceError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "输出文件不能与源镜像路径相同。",
            en: "The output file cannot be the same as the source media path.",
            fr: "Le fichier de sortie ne peut pas être identique au média source.",
            es: "El archivo de salida no puede coincidir con la ruta de origen.",
            ru: "Выходной файл не может совпадать с исходным образом.",
            ar: "لا يمكن أن يطابق ملف الإخراج مسار صورة المصدر."
        )
    }

    static func coreNotAcknowledgedError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "使用 Tiny11 Core 裁剪必须先确认已知悉失去系统更新、恢复环境与 Defender 防护的风险。",
            en: "Tiny11 Core requires acknowledging the permanent loss of Windows Update, recovery environment, and Defender protection.",
            fr: "Tiny11 Core nécessite de confirmer la perte définitive de Windows Update, de la récupération et de Defender.",
            es: "Tiny11 Core requiere confirmar la pérdida permanente de Windows Update, el entorno de recuperación y Defender.",
            ru: "Для режима Tiny11 Core необходимо подтвердить принятие риска отключения обновлений, среды восстановления и Defender.",
            ar: "يتطلب استخدام وضع Tiny11 Core الإقرار بفقدان تحديثات النظام وبيئة الاسترداد وحماية Defender."
        )
    }

    static func unknownOptionIdError(_ id: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "包含未知的清理选项 ID：\(id)",
            en: "Recipe contains an unknown cleanup option ID: \(id)",
            fr: "La recette contient un identifiant d’option inconnu : \(id)",
            es: "La receta contiene un identificador de opción desconocido: \(id)",
            ru: "Рецепт содержит неизвестный идентификатор опции очистки: \(id)",
            ar: "تحتوي الوصفة على معرّف خيار تنظيف غير معروف: \(id)"
        )
    }

    static func invalidIsoSizeLimitError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "自定义 ISO 体积上限必须在 64 MB 到 4 GB（十进制字节）之间。",
            en: "Custom ISO size limits must be between 64 MB and 4 GB (decimal bytes).",
            fr: "La limite de taille ISO doit être comprise entre 64 Mo et 4 Go (octets décimaux).",
            es: "El límite de tamaño ISO debe estar entre 64 MB y 4 GB (bytes decimales).",
            ru: "Лимит размера ISO должен быть в пределах от 64 МБ до 4 ГБ (в десятичных байтах).",
            ar: "يجب أن يكون حد حجم ملف ISO المخصّص بين 64 ميغابايت و4 غيغابايت."
        )
    }

    static func isoSizeLimitExceededError(actualBytes: Int64, limitBytes: Int64, lang: AppLanguage = L10n.currentLanguage) -> String {
        let diff = actualBytes - limitBytes
        return tr(
            lang: lang,
            zh: "生成的完整 ISO 大小为 \(actualBytes) 字节，超出设定的 \(limitBytes) 字节上限 \(diff) 字节，未发布输出。请减少保留的组件或在构建设置中移除体积上限。",
            en: "The complete ISO is \(actualBytes) bytes, exceeding the \(limitBytes)-byte limit by \(diff) bytes. Reduce retained payloads or clear the ISO size limit in Build Settings.",
            fr: "L’ISO complet fait \(actualBytes) octets, dépassant la limite de \(limitBytes) octets de \(diff) octets. Réduisez les composants ou retirez la limite de taille.",
            es: "El ISO completo mide \(actualBytes) bytes, superando el límite de \(limitBytes) bytes por \(diff) bytes. Reduce cargas o elimina el límite de tamaño.",
            ru: "Итоговый ISO весит \(actualBytes) байт, превышая лимит \(limitBytes) байт на \(diff) байт. Уменьшите объём компонентов или снимите лимит размера.",
            ar: "حجم ملف ISO الكامل هو \(actualBytes) بايت، متجاوزًا الحد المسموح (\(limitBytes) بايت) بمقدار \(diff) بايت. قلّل المكونات أو أزل حد الحجم."
        )
    }

    static func toolMissingError(_ detail: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "缺少必要的底层镜像工具：\(detail)",
            en: "Missing required native imaging tool: \(detail)",
            fr: "Outil système d’imagerie manquant : \(detail)",
            es: "Falta una herramienta nativa requerida: \(detail)",
            ru: "Отсутствует необходимый инструмент работы с образами: \(detail)",
            ar: "أداة معالجة الصور الأساسية مفقودة: \(detail)"
        )
    }

    static func processFailedError(execName: String, exitCode: Int32, suffix: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "命令执行失败 (\(execName), 退出码 \(exitCode))。\(suffix)",
            en: "Command failed (\(execName), exit code \(exitCode)).\(suffix)",
            fr: "Échec de la commande (\(execName), code \(exitCode)).\(suffix)",
            es: "Falló la ejecución del comando (\(execName), código \(exitCode)).\(suffix)",
            ru: "Ошибка выполнения команды (\(execName), код возврата \(exitCode)).\(suffix)",
            ar: "فشل تنفيذ الأمر (\(execName)، رمز الخروج \(exitCode)).\(suffix)"
        )
    }

    static func registryError(_ detail: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "离线注册表操作失败：\(detail)",
            en: "Offline registry operation failed: \(detail)",
            fr: "Échec de l’opération sur le registre hors ligne : \(detail)",
            es: "Error en la operación del registro sin conexión: \(detail)",
            ru: "Ошибка операции с офлайн-реестром: \(detail)",
            ar: "فشلت عملية السجل دون اتصال: \(detail)"
        )
    }

    static func cancelledError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "操作已安全取消。",
            en: "Operation safely cancelled.",
            fr: "Opération annulée en toute sécurité.",
            es: "Operación cancelada de forma segura.",
            ru: "Операция безопасно отменена.",
            ar: "تم إلغاء العملية بأمان."
        )
    }

    // MARK: - Tool Locator & Imaging Errors

    static func hdiutilUnavailable(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "/usr/bin/hdiutil 不可用。",
            en: "/usr/bin/hdiutil is unavailable.",
            fr: "/usr/bin/hdiutil est indisponible.",
            es: "/usr/bin/hdiutil no está disponible.",
            ru: "/usr/bin/hdiutil недоступен.",
            ar: "الأداة /usr/bin/hdiutil غير متوفرة."
        )
    }

    static func wimlibMissing(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "未找到 wimlib-imagex。若是开发模式请运行 macos/Scripts/setup-dev-deps.sh，或使用打包好的 Tiny11Builder.app。",
            en: "wimlib-imagex not found. Run macos/Scripts/setup-dev-deps.sh in dev mode, or launch the packaged Tiny11Builder.app.",
            fr: "wimlib-imagex introuvable. En développement, exécutez macos/Scripts/setup-dev-deps.sh ou utilisez Tiny11Builder.app.",
            es: "No se encontró wimlib-imagex. Ejecuta macos/Scripts/setup-dev-deps.sh en desarrollo o usa Tiny11Builder.app.",
            ru: "Не найден wimlib-imagex. Запустите macos/Scripts/setup-dev-deps.sh для разработки или используйте готовый Tiny11Builder.app.",
            ar: "لم يتم العثور على wimlib-imagex. شغّل macos/Scripts/setup-dev-deps.sh في وضع التطوير أو استخدم تطبيق Tiny11Builder.app المجمع."
        )
    }

    static func mkisofsMissing(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "未找到 mkisofs (cdrtools)。若是开发模式请运行 macos/Scripts/setup-dev-deps.sh，或使用打包好的 Tiny11Builder.app。",
            en: "mkisofs (cdrtools) not found. Run macos/Scripts/setup-dev-deps.sh in dev mode, or launch the packaged Tiny11Builder.app.",
            fr: "mkisofs (cdrtools) introuvable. En développement, exécutez macos/Scripts/setup-dev-deps.sh ou utilisez Tiny11Builder.app.",
            es: "No se encontró mkisofs (cdrtools). Ejecuta macos/Scripts/setup-dev-deps.sh en desarrollo o usa Tiny11Builder.app.",
            ru: "Не найден mkisofs (cdrtools). Запустите macos/Scripts/setup-dev-deps.sh для разработки или используйте готовый Tiny11Builder.app.",
            ar: "لم يتم العثور على mkisofs (cdrtools). شغّل macos/Scripts/setup-dev-deps.sh في وضع التطوير أو استخدم تطبيق Tiny11Builder.app المجمع."
        )
    }

    static func isoFileNotFound(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "ISO 文件不存在：\(path)",
            en: "ISO file does not exist: \(path)",
            fr: "Le fichier ISO n’existe pas : \(path)",
            es: "El archivo ISO no existe: \(path)",
            ru: "ISO-файл не существует: \(path)",
            ar: "ملف ISO غير موجود: \(path)"
        )
    }

    static func isoInvalidSectorSize(_ length: Int64, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "文件大小不符合标准 ISO 扇区对齐格式（\(length) 字节）。",
            en: "File size is not aligned to standard 2048-byte ISO sectors (\(length) bytes).",
            fr: "La taille du fichier ne correspond pas à l’alignement secteur ISO standard (\(length) octets).",
            es: "El tamaño del archivo no cumple la alineación estándar de sectores ISO (\(length) bytes).",
            ru: "Размер файла не кратен стандартному сектору ISO (\(length) байт).",
            ar: "حجم الملف لا يتوافق مع محاذاة قطاعات ISO القياسية (\(length) بايت)."
        )
    }

    static func isoDescriptorReadError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法读取 ISO 卷描述符区域。",
            en: "Unable to read the ISO volume descriptor area.",
            fr: "Impossible de lire la zone de descripteur de volume ISO.",
            es: "No se pudo leer el área de descriptores de volumen ISO.",
            ru: "Не удалось прочитать область дескрипторов тома ISO.",
            ar: "تعذّرت قراءة منطقة واصف وحدة تخزين ISO."
        )
    }

    static func isoInvalidVolumeDescriptor(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "未检测到有效的 ISO9660 或 UDF 卷描述符（非标准光盘镜像）。",
            en: "No valid ISO9660 or UDF volume descriptor found (not a standard disc image).",
            fr: "Aucun descripteur de volume ISO9660 ou UDF valide détecté (image disque non standard).",
            es: "No se detectó ningún descriptor de volumen ISO9660 o UDF válido (imagen no estándar).",
            ru: "Не обнаружен корректный дескриптор тома ISO9660 или UDF (нестандартный образ диска).",
            ar: "لم يتم العثور على واصف وحدة تخزين ISO9660 أو UDF صالح (ملف صورة غير قياسي)."
        )
    }

    static func mediaSourceNotFound(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "找不到指定的镜像文件或目录：\(path)",
            en: "The specified image file or directory was not found: \(path)",
            fr: "Le fichier image ou dossier indiqué est introuvable : \(path)",
            es: "No se encontró el archivo de imagen o directorio indicado: \(path)",
            ru: "Указанный файл образа или каталог не найден: \(path)",
            ar: "تعذّر العثور على ملف الصورة أو المجلد المحدد: \(path)"
        )
    }

    static func mediaInvalidExtension(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "请选择有效的 Windows 11 .iso 文件或已解压的安装目录。",
            en: "Please select a valid Windows 11 .iso file or an extracted installation folder.",
            fr: "Veuillez sélectionner un fichier .iso Windows 11 valide ou un dossier d’installation extrait.",
            es: "Selecciona un archivo .iso de Windows 11 válido o una carpeta de instalación extraída.",
            ru: "Выберите корректный файл .iso Windows 11 или распакованную папку установки.",
            ar: "يرجى اختيار ملف .iso صالح لنظام Windows 11 أو مجلد تثبيت مستخرج."
        )
    }

    static func hdiutilParseError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法解析 hdiutil 挂载返回信息。",
            en: "Failed to parse mount output from hdiutil.",
            fr: "Impossible d’analyser les informations de montage renvoyées par hdiutil.",
            es: "No se pudo interpretar la información de montaje devuelta por hdiutil.",
            ru: "Не удалось разобрать ответ hdiutil при монтировании образа.",
            ar: "تعذّر تحليل بيانات التركيب العائدة من hdiutil."
        )
    }

    static func hdiutilNoReadableVolume(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "ISO 已附加，但 macOS 未能挂载可读文件系统卷。",
            en: "The ISO was attached, but macOS could not mount a readable filesystem volume.",
            fr: "L’ISO a été attaché, mais macOS n’a pas pu monter de volume lisible.",
            es: "El ISO se adjuntó, pero macOS no pudo montar un volumen legible.",
            ru: "Образ ISO подключён, но macOS не смогла смонтировать читаемый том.",
            ar: "تم إرفاق ملف ISO، لكن macOS لم يتمكن من تركيب وحدة تخزين قابلة للقراءة."
        )
    }

    static func wimXmlEmpty(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "WIM XML 元数据为空。",
            en: "WIM XML metadata is empty.",
            fr: "Les métadonnées XML WIM sont vides.",
            es: "Los metadatos XML del archivo WIM están vacíos.",
            ru: "XML-метаданные WIM пусты.",
            ar: "بيانات XML الوصفية لملف WIM فارغة."
        )
    }

    static func wimXmlRootParseError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法解析 WIM XML 根节点。",
            en: "Failed to parse the WIM XML root element.",
            fr: "Impossible d’analyser l’élément racine XML du WIM.",
            es: "No se pudo analizar el nodo raíz XML del WIM.",
            ru: "Не удалось разобрать корневой элемент XML файла WIM.",
            ar: "تعذّر تحليل العنصر الجذري لبيانات WIM XML."
        )
    }

    static func wimNoSystemVolumes(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "该 WIM/ESD 文件中未找到任何可用的系统卷。",
            en: "No usable Windows images were found in this WIM/ESD file.",
            fr: "Aucun volume système utilisable n’a été trouvé dans ce fichier WIM/ESD.",
            es: "No se encontró ningún volumen del sistema utilizable en este archivo WIM/ESD.",
            ru: "В этом файле WIM/ESD не найдено ни одного доступного системного тома.",
            ar: "لم يتم العثور على أي نسخة نظام صالحة داخل ملف WIM/ESD هذا."
        )
    }

    // MARK: - Pipeline Messages & Errors

    static func mediaMissingBootWim(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "源介质不是完整的 Windows 安装镜像：缺少 sources/boot.wim。",
            en: "Source media is not a complete Windows installation image: missing sources/boot.wim.",
            fr: "Le média source n’est pas une image d’installation Windows complète : sources/boot.wim est manquant.",
            es: "El medio de origen no es una imagen completa de instalación de Windows: falta sources/boot.wim.",
            ru: "Исходный носитель не является полным установочным образом Windows: отсутствует sources/boot.wim.",
            ar: "وسيط المصدر ليس صورة تثبيت Windows كاملة: الملف sources/boot.wim مفقود."
        )
    }

    static func mediaMissingInstallWim(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "未找到 sources/install.wim 或 install.esd（不支持拆分版 install.swm）。",
            en: "Neither sources/install.wim nor install.esd was found (split install.swm archives are not supported).",
            fr: "Fichier sources/install.wim ou install.esd introuvable (les archives fractionnées install.swm ne sont pas prises en charge).",
            es: "No se encontró sources/install.wim ni install.esd (no se admiten archivos divididos install.swm).",
            ru: "Не найден sources/install.wim или install.esd (разбитые архивы install.swm не поддерживаются).",
            ar: "لم يتم العثور على sources/install.wim أو install.esd (ملفات install.swm المقسمة غير مدعومة)."
        )
    }

    static func mediaMissingEfiBoot(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "源介质缺少 UEFI 引导扇区文件 (efi/microsoft/boot/efisys.bin)。",
            en: "Source media is missing the UEFI boot sector file (efi/microsoft/boot/efisys.bin).",
            fr: "Fichier de secteur d’amorçage UEFI manquant (efi/microsoft/boot/efisys.bin).",
            es: "Falta el archivo de sector de arranque UEFI (efi/microsoft/boot/efisys.bin).",
            ru: "На исходном носителе отсутствует файл загрузочного сектора UEFI (efi/microsoft/boot/efisys.bin).",
            ar: "يفتقر وسيط المصدر إلى ملف قطاع إقلاع UEFI ‏(efi/microsoft/boot/efisys.bin)."
        )
    }

    static func mediaMissingRequiredFiles(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "源介质缺少必需的引导或安装镜像文件 (boot.wim / install.wim / efisys.bin)。",
            en: "Source media is missing required boot or install files (boot.wim / install.wim / efisys.bin).",
            fr: "Fichiers d’amorçage ou d’installation requis manquants (boot.wim / install.wim / efisys.bin).",
            es: "Faltan archivos esenciales de arranque o instalación (boot.wim / install.wim / efisys.bin).",
            ru: "Отсутствуют обязательные файлы загрузки или установки (boot.wim / install.wim / efisys.bin).",
            ar: "يفتقر وسيط المصدر إلى ملفات الإقلاع أو التثبيت الأساسية (boot.wim / install.wim / efisys.bin)."
        )
    }

    static func imageIndexNotFound(_ index: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "源镜像中不存在索引为 \(index) 的系统版本。",
            en: "Source image does not contain an edition with index \(index).",
            fr: "L’image source ne contient aucune édition à l’index \(index).",
            es: "La imagen de origen no contiene ninguna edición con el índice \(index).",
            ru: "В исходном образе нет редакции с индексом \(index).",
            ar: "لا تحتوي صورة المصدر على نسخة بالفهرس \(index)."
        )
    }

    static func netFx3PayloadMissingError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已勾选启用 .NET Framework 3.5，但当前源镜像不包含 sources/sxs 离线安装包。",
            en: ".NET Framework 3.5 is enabled, but the source media does not contain the offline sources/sxs payload.",
            fr: ".NET Framework 3.5 est coché, mais le média source ne contient pas le dossier hors ligne sources/sxs.",
            es: "Se activó .NET Framework 3.5, pero la imagen de origen no incluye la carpeta sin conexión sources/sxs.",
            ru: "Включён .NET Framework 3.5, но исходный образ не содержит офлайн-пакетов sources/sxs.",
            ar: "تم تفعيل .NET Framework 3.5، لكن صورة المصدر لا تتضمن حزمة التثبيت دون اتصال sources/sxs."
        )
    }

    static func corePendingUpdateError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "检测到该镜像包含尚未完成的挂起更新 (pending.xml 或 CBS 挂起状态)。Tiny11 Core 会删除首次开机完成更新所需的组件，已中止裁剪；请改用 Mac 虚拟机优化版或标准版构建。",
            en: "Pending servicing operations (pending.xml or CBS state) were detected in this image. Tiny11 Core would remove components required to complete first-boot servicing; please use Mac VM Optimized or Standard mode instead.",
            fr: "Des mises à jour en attente (pending.xml ou CBS) ont été détectées. Tiny11 Core supprimerait des composants requis au premier démarrage ; veuillez utiliser le mode Optimisé VM Mac ou Standard.",
            es: "Se detectaron actualizaciones pendientes (pending.xml o CBS). Tiny11 Core eliminaría componentes necesarios en el primer arranque; utiliza el modo Optimizado VM Mac o Estándar.",
            ru: "Обнаружены незавершённые операции обновления (pending.xml или CBS). Режим Tiny11 Core удалит компоненты, нужные для первого запуска; выберите режим для ВМ Mac или Стандартный.",
            ar: "تم رصد تحديثات معلّقة (pending.xml أو حالة CBS) في هذه الصورة. سيؤدي وضع Tiny11 Core إلى حذف مكونات لازمة للإقلاع الأول؛ يرجى استخدام وضع Mac المحسّن أو القياسي."
        )
    }

    static func edgeRetainedPendingWarning(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "镜像存在挂起的组件服务操作，为避免首次开机失败，已保留 Edge/WebView2 文件。",
            en: "Pending servicing operations were detected; Edge/WebView2 files were retained to ensure a safe first boot.",
            fr: "Des opérations de maintenance en attente ont été détectées ; les fichiers Edge/WebView2 ont été conservés par sécurité.",
            es: "Se detectaron operaciones de mantenimiento pendientes; se conservaron los archivos de Edge/WebView2 por seguridad.",
            ru: "Обнаружены отложенные операции обслуживания; файлы Edge/WebView2 сохранены во избежание сбоя при первом запуске.",
            ar: "وُجدت عمليات صيانة معلّقة؛ تم الإبقاء على ملفات Edge/WebView2 لضمان سلامة الإقلاع الأول."
        )
    }

    static func coreMissingRuntimeLayoutError(arch: String, family: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Core 模式无法在该构建版本中识别必需的 \(arch) \(family) 运行库布局，已安全停止裁剪。",
            en: "Core mode could not recognize the required \(arch) \(family) runtime layout in this build and safely aborted pruning.",
            fr: "Le mode Core n’a pas pu identifier l’architecture runtime requise \(arch) \(family) dans cette build ; opération interrompue.",
            es: "El modo Core no pudo reconocer el diseño requerido de \(arch) \(family) en esta compilación y detuvo el recorte.",
            ru: "Режим Core не смог распознать обязательную структуру библиотек \(arch) \(family) в этой сборке; обрезка остановлена.",
            ar: "تعذّر على وضع Core التعرّف على تخطيط مكتبات التشغيل المطلوبة \(arch) \(family) في هذه البنية وتم إيقاف التقليص بأمان."
        )
    }

    static func missingCoreHivesError(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "工作镜像缺少核心注册表 Hive 文件 (SOFTWARE / SYSTEM / NTUSER.DAT)。",
            en: "Working image is missing core registry hive files (SOFTWARE / SYSTEM / NTUSER.DAT).",
            fr: "Fichiers de ruches du registre principaux manquants dans l’image (SOFTWARE / SYSTEM / NTUSER.DAT).",
            es: "Faltan archivos principales del registro en la imagen de trabajo (SOFTWARE / SYSTEM / NTUSER.DAT).",
            ru: "В рабочем образе отсутствуют основные файлы кустов реестра (SOFTWARE / SYSTEM / NTUSER.DAT).",
            ar: "صورة العمل تفتقر إلى ملفات السجل الأساسية (SOFTWARE / SYSTEM / NTUSER.DAT)."
        )
    }

    static func bootWimSetupNotFound(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法在 boot.wim 中找到有效的 Windows Setup 引导卷。",
            en: "Could not find a valid Windows Setup volume inside boot.wim.",
            fr: "Impossible de trouver un volume Windows Setup valide dans boot.wim.",
            es: "No se encontró un volumen válido de Windows Setup dentro de boot.wim.",
            ru: "Не удалось найти том Windows Setup внутри boot.wim.",
            ar: "تعذّر العثور على وحدة Windows Setup صالحة داخل boot.wim."
        )
    }

    static func bootWimMissingSystemHive(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "boot.wim 缺少 SYSTEM 注册表文件。",
            en: "boot.wim is missing the SYSTEM registry hive.",
            fr: "La ruche de registre SYSTEM est absente de boot.wim.",
            es: "Falta la colmena de registro SYSTEM en boot.wim.",
            ru: "В boot.wim отсутствует файл куста реестра SYSTEM.",
            ar: "ملف سجل SYSTEM مفقود داخل boot.wim."
        )
    }

    static func bootWimMissingLegacySetup(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Core 模式需要经典安装器 sources\\setup.exe，但当前镜像的 boot.wim 中未包含该文件。",
            en: "Core mode requires the legacy installer sources\\setup.exe, which was not found in boot.wim.",
            fr: "Le mode Core requiert l’installateur classique sources\\setup.exe, absent de boot.wim.",
            es: "El modo Core requiere el instalador clásico sources\\setup.exe, ausente en boot.wim.",
            ru: "Режиму Core требуется классический установщик sources\\setup.exe, отсутствующий в boot.wim.",
            ar: "يتطلب وضع Core المثبت الكلاسيكي sources\\setup.exe وهو غير موجود داخل boot.wim."
        )
    }

    static func stagerEnumerateError(_ root: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法遍历安装介质目录：\(root)",
            en: "Unable to enumerate installation media directory: \(root)",
            fr: "Impossible de parcourir le dossier du média d’installation : \(root)",
            es: "No se pudo recorrer el directorio del medio de instalación: \(root)",
            ru: "Не удалось прочитать каталог установочного носителя: \(root)",
            ar: "تعذّر تصفّح مجلد وسيط التثبيت: \(root)"
        )
    }

    static func stagerUnsupportedSymlink(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "安装介质包含不受支持的符号链接：\(path)",
            en: "Installation media contains an unsupported symbolic link: \(path)",
            fr: "Le média d’installation contient un lien symbolique non pris en charge : \(path)",
            es: "El medio de instalación contiene un enlace simbólico no compatible: \(path)",
            ru: "Установочный носитель содержит неподдерживаемую символическую ссылку: \(path)",
            ar: "يحتوي وسيط التثبيت على رابط رمزي غير مدعوم: \(path)"
        )
    }

    static func stagerUnsupportedSwm(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "不支持分卷拆分的 install.swm 源介质，请使用完整官方 ISO。",
            en: "Split install.swm media is not supported; please use a standard full Windows 11 ISO.",
            fr: "Les archives fractionnées install.swm ne sont pas prises en charge ; utilisez un ISO officiel complet.",
            es: "No se admiten medios divididos install.swm; utiliza un ISO oficial completo.",
            ru: "Разбитые на части файлы install.swm не поддерживаются; используйте полный официальный ISO.",
            ar: "وسائط install.swm المقسمة غير مدعومة؛ يرجى استخدام ملف ISO رسمي كامل."
        )
    }

    static func stagerCopyFailed(relativePath: String, error: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "复制安装介质文件 \(relativePath) 失败：\(error)",
            en: "Failed to copy media file \(relativePath): \(error)",
            fr: "Échec de la copie du fichier \(relativePath) : \(error)",
            es: "Error al copiar el archivo \(relativePath): \(error)",
            ru: "Не удалось скопировать файл носителя \(relativePath): \(error)",
            ar: "فشل نسخ ملف وسيط التثبيت \(relativePath): \(error)"
        )
    }

    static func insufficientDiskSpaceError(freeGiB: Int64, needGiB: Int64, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "工作目录所在磁盘剩余空间不足（当前可用约 \(freeGiB) GiB，建议至少预留 \(needGiB) GiB）。",
            en: "Insufficient free disk space in workspace volume (available: ~\(freeGiB) GiB, recommended: at least \(needGiB) GiB).",
            fr: "Espace disque insuffisant sur le volume de travail (disponible : ~\(freeGiB) Gio, requis : au moins \(needGiB) Gio).",
            es: "Espacio libre insuficiente en el disco de trabajo (disponible: ~\(freeGiB) GiB, recomendado: al menos \(needGiB) GiB).",
            ru: "Недостаточно свободного места на диске рабочего каталога (доступно ~\(freeGiB) ГиБ, требуется минимум \(needGiB) ГиБ).",
            ar: "المساحة الحرة في قرص العمل غير كافية (المتاح حاليًا نحو \(freeGiB) غيغابايت، ويُنصح بتوفير \(needGiB) غيغابايت على الأقل)."
        )
    }

    static func outputAppearedDuringBuildError(_ tempIsoPath: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "目标路径在构建期间出现了同名文件，已保留镜像副本于：\(tempIsoPath)",
            en: "A file appeared at the destination path during the build; your built ISO has been preserved at: \(tempIsoPath)",
            fr: "Un fichier portant le même nom est apparu pendant la création ; l’ISO généré est conservé ici : \(tempIsoPath)",
            es: "Apareció un archivo con el mismo nombre en destino durante el proceso; tu ISO se conservó en: \(tempIsoPath)",
            ru: "Во время сборки по целевому пути появился одноимённый файл; готовый ISO сохранён в: \(tempIsoPath)",
            ar: "ظهر ملف بنفس الاسم في مسار الوجهة أثناء البناء؛ تم الاحتفاظ بنسخة ISO المبنية في: \(tempIsoPath)"
        )
    }

    // MARK: - Live Progress Messages

    static func phasePrepareRunning(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在挂载源镜像并检查系统版本与磁盘剩余空间...",
            en: "Mounting source media and checking edition metadata & free disk space...",
            fr: "Montage du média source et vérification de l’édition et de l’espace disque...",
            es: "Montando imagen de origen y comprobando edición y espacio libre...",
            ru: "Монтирование исходного образа и проверка версии и свободного места...",
            ar: "جارٍ تركيب صورة المصدر والتحقق من إصدار النظام والمساحة المتاحة..."
        )
    }

    static func phasePrepareDone(copiedFiles: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已复制 \(copiedFiles) 个安装支持文件",
            en: "Staged \(copiedFiles) setup support files",
            fr: "\(copiedFiles) fichiers de support d’installation préparés",
            es: "\(copiedFiles) archivos de soporte de instalación preparados",
            ru: "Подготовлено файлов установки: \(copiedFiles)",
            ar: "تم تجهيز \(copiedFiles) من ملفات دعم التثبيت"
        )
    }

    static func phaseExportRunning(imageName: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在导出 \(imageName) 至可读写工作镜像...",
            en: "Exporting \(imageName) into working WIM...",
            fr: "Exportation de \(imageName) vers l’image de travail...",
            es: "Exportando \(imageName) a la imagen de trabajo...",
            ru: "Экспорт \(imageName) в рабочий образ WIM...",
            ar: "جارٍ تصدير \(imageName) إلى صورة العمل..."
        )
    }

    static func phaseExportPercent(_ pct: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在导出单版本工作镜像 (\(pct)%)",
            en: "Exporting single-edition working image (\(pct)%)",
            fr: "Exportation de l’image de travail (\(pct) %)",
            es: "Exportando imagen de trabajo (\(pct) %)",
            ru: "Экспорт рабочего образа (\(pct)%)",
            ar: "جارٍ تصدير صورة العمل (\(pct)%)"
        )
    }

    static func phaseExportDone(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "单版本导出完成 (索引已归一为 1)",
            en: "Single edition exported (normalized to index 1)",
            fr: "Édition unique exportée (index normalisé à 1)",
            es: "Edición única exportada (índice normalizado a 1)",
            ru: "Редакция экспортирована (индекс нормализован к 1)",
            ar: "اكتمل تصدير النسخة المفردة (تم توحيد الفهرس إلى 1)"
        )
    }

    static func phaseRegistryRunning(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在扫描镜像结构并注入离线注册表策略与防重装锁...",
            en: "Scanning image tree and injecting offline registry policies & deprovisioning locks...",
            fr: "Analyse de l’image et injection des stratégies du registre hors ligne...",
            es: "Analizando estructura e inyectando directivas de registro sin conexión...",
            ru: "Сканирование структуры образа и запись политик офлайн-реестра...",
            ar: "جارٍ فحص بنية الصورة وحقن سياسات السجل وأقفال منع إعادة التثبيت..."
        )
    }

    static func phaseRegistryDone(policies: Int, lockedApps: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "写入策略 \(policies) 项 · 锁定预装应用 \(lockedApps) 个",
            en: "\(policies) policies written · \(lockedApps) app families locked",
            fr: "\(policies) stratégies écrites · \(lockedApps) applications verrouillées",
            es: "\(policies) directivas aplicadas · \(lockedApps) apps bloqueadas",
            ru: "Записано политик: \(policies) · заблокировано пакетов: \(lockedApps)",
            ar: "تمت كتابة \(policies) سياسة · قفل \(lockedApps) حزمة تطبيقات"
        )
    }

    static func phasePruneRunning(count: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在执行流式组件裁剪与注册表提交 (共 \(count) 项移除)...",
            en: "Pruning \(count) entries in WIM stream and committing registry hives...",
            fr: "Suppression en flux de \(count) éléments et validation du registre...",
            es: "Eliminando \(count) elementos en flujo y guardando colmenas de registro...",
            ru: "Потоковое удаление элементов (\(count)) и сохранение кустов реестра...",
            ar: "جارٍ إزالة \(count) عنصرًا وحفظ تعديلات السجل..."
        )
    }

    static func phasePruneDone(count: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已移除 \(count) 个目录/文件并提交离线注册表",
            en: "Removed \(count) paths and committed offline registry hives",
            fr: "\(count) chemins supprimés et registre hors ligne validé",
            es: "\(count) rutas eliminadas y registro sin conexión confirmado",
            ru: "Удалено путей: \(count), офлайн-реестр сохранён",
            ar: "تمت إزالة \(count) مسارًا وحفظ السجل دون اتصال"
        )
    }

    static func phaseBootRunning(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在生成无人值守应答配置并处理引导镜像 boot.wim...",
            en: "Generating autounattend.xml and customizing boot.wim...",
            fr: "Génération d’autounattend.xml et personnalisation de boot.wim...",
            es: "Generando autounattend.xml y configurando boot.wim...",
            ru: "Генерация autounattend.xml и настройка загрузочного boot.wim...",
            ar: "جارٍ إنشاء ملف autounattend.xml وتخصيص صورة الإقلاع boot.wim..."
        )
    }

    static func phaseBootDone(legacyInstallerUsed: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if legacyInstallerUsed {
            return tr(
                lang: lang,
                zh: "已配置应答文件、硬件绕过与经典安装器",
                en: "Configured unattend, hardware bypass & legacy setup",
                fr: "Fichier de réponses, contournement matériel et installateur classique configurés",
                es: "Respuesta desatendida, omisión de hardware e instalador clásico listos",
                ru: "Настроены файл ответов, обход проверок и классический установщик",
                ar: "تم إعداد ملف التثبيت التلقائي وتجاوز العتاد والمثبت الكلاسيكي"
            )
        }
        return tr(
            lang: lang,
            zh: "已配置应答文件与引导环境",
            en: "Configured unattend file & boot environment",
            fr: "Fichier de réponses et environnement d’amorçage configurés",
            es: "Archivo desatendido y entorno de arranque configurados",
            ru: "Файл ответов и среда загрузки настроены",
            ar: "تم إعداد ملف التثبيت التلقائي وبيئة الإقلاع"
        )
    }

    static func phaseCompressRunning(leaf: String, modeTitle: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在使用 Apple Silicon 多核压缩生成 \(leaf) (\(modeTitle))...",
            en: "Multi-core compressing \(leaf) (\(modeTitle))...",
            fr: "Compression multicœur vers \(leaf) (\(modeTitle))...",
            es: "Comprimiendo \(leaf) en multinúcleo (\(modeTitle))...",
            ru: "Многопоточное сжатие \(leaf) (\(modeTitle))...",
            ar: "جارٍ ضغط \(leaf) متعدد الأنوية (\(modeTitle))..."
        )
    }

    static func phaseCompressPercent(leaf: String, pct: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在多核压缩 \(leaf) (\(pct)%)",
            en: "Compressing \(leaf) (\(pct)%)",
            fr: "Compression de \(leaf) (\(pct) %)",
            es: "Comprimiendo \(leaf) (\(pct) %)",
            ru: "Сжатие \(leaf) (\(pct)%)",
            ar: "جارٍ ضغط \(leaf) (\(pct)%)"
        )
    }

    static func phaseCompressDone(leaf: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已完成 \(leaf) 压缩校验",
            en: "Compressed and verified \(leaf)",
            fr: "Compression et vérification de \(leaf) terminées",
            es: "Compresión y verificación de \(leaf) completadas",
            ru: "Сжатие и проверка \(leaf) завершены",
            ar: "اكتمل ضغط ملف \(leaf) والتحقق من سلامته"
        )
    }

    static func phaseIsoRunning(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在使用 mkisofs 构建 UEFI/UDF 可引导光盘镜像...",
            en: "Building bootable UEFI/UDF disc image via mkisofs...",
            fr: "Création de l’image ISO amorçable UEFI/UDF via mkisofs...",
            es: "Creando imagen ISO arrancable UEFI/UDF con mkisofs...",
            ru: "Сборка загрузочного образа UEFI/UDF ISO через mkisofs...",
            ar: "جارٍ إنشاء صورة القرص القابلة للإقلاع UEFI/UDF عبر mkisofs..."
        )
    }

    static func phaseIsoDone(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "可引导光盘镜像合成完毕",
            en: "Bootable ISO image created",
            fr: "Image ISO amorçable générée",
            es: "Imagen ISO arrancable generada",
            ru: "Загрузочный образ ISO сформирован",
            ar: "اكتمل إنشاء صورة ISO القابلة للإقلاع"
        )
    }

    static func phaseVerifyRunning(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在校验 ISO 卷结构并计算 SHA-256 校验和...",
            en: "Validating ISO descriptors and computing SHA-256 checksum...",
            fr: "Vérification des descripteurs ISO et calcul du SHA-256...",
            es: "Validando estructura ISO y calculando suma SHA-256...",
            ru: "Проверка структуры ISO и вычисление контрольной суммы SHA-256...",
            ar: "جارٍ التحقق من بنية ISO وحساب بصمة SHA-256..."
        )
    }

    static func phaseVerifyPercent(_ pct: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在计算输出镜像 SHA-256 (\(pct)%)",
            en: "Computing output ISO SHA-256 (\(pct)%)",
            fr: "Calcul du SHA-256 de l’ISO (\(pct) %)",
            es: "Calculando SHA-256 del ISO (\(pct) %)",
            ru: "Расчёт SHA-256 выходного ISO (\(pct)%)",
            ar: "جارٍ حساب SHA-256 لملف ISO (\(pct)%)"
        )
    }

    static func phaseVerifyDone(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "校验通过并已发布 ISO",
            en: "Verified and published ISO",
            fr: "ISO vérifié et publié",
            es: "ISO verificado y publicado",
            ru: "Проверка пройдена, ISO опубликован",
            ar: "تم التحقق من ملف ISO ونشره بنجاح"
        )
    }

    static func phaseCancelledShort(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已取消",
            en: "Cancelled",
            fr: "Annulé",
            es: "Cancelado",
            ru: "Отменено",
            ar: "أُلغي"
        )
    }
}
