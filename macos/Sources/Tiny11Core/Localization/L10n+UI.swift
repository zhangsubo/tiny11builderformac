import Foundation

public extension L10n {
    // MARK: - Window & Sidebar & Navigation

    static func windowTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Tiny11 Builder for Mac",
            en: "Tiny11 Builder for Mac",
            fr: "Tiny11 Builder pour Mac",
            es: "Tiny11 Builder para Mac",
            ru: "Tiny11 Builder для Mac",
            ar: "Tiny11 Builder لنظام Mac"
        )
    }

    static func sidebarSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "适用于 Mac Apple Silicon",
            en: "for Mac Apple Silicon",
            fr: "pour Mac Apple Silicon",
            es: "para Mac Apple Silicon",
            ru: "для Mac на Apple Silicon",
            ar: "لأجهزة Mac بمعالج Apple Silicon"
        )
    }

    static func wizardStepTitle(_ rawIndex: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch rawIndex {
        case 0:
            return tr(lang: lang, zh: "构建模式", en: "Build Mode", fr: "Mode", es: "Modo", ru: "Режим", ar: "وضع البناء")
        case 1:
            return tr(lang: lang, zh: "导入镜像", en: "Source ISO", fr: "Image ISO", es: "Imagen ISO", ru: "Образ ISO", ar: "استيراد ISO")
        case 2:
            return tr(lang: lang, zh: "精简定制", en: "Customize", fr: "Personnaliser", es: "Personalizar", ru: "Настройка", ar: "التخصيص")
        case 3:
            return tr(lang: lang, zh: "压缩与参数", en: "Settings", fr: "Options", es: "Opciones", ru: "Параметры", ar: "الإعدادات")
        case 4:
            return tr(lang: lang, zh: "方案复核", en: "Review", fr: "Vérification", es: "Revisión", ru: "Проверка", ar: "المراجعة")
        default:
            return tr(lang: lang, zh: "执行构建", en: "Build ISO", fr: "Création", es: "Compilar", ru: "Сборка", ar: "بدء البناء")
        }
    }

    static func wizardStepSubtitle(_ rawIndex: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        switch rawIndex {
        case 0:
            return tr(
                lang: lang,
                zh: "选择面向 Mac 虚拟机或 PC 装机的精简预设",
                en: "Choose a preset tailored for Mac VMs or PC installations",
                fr: "Choisissez un profil pour VM Mac ou installation PC",
                es: "Elige un perfil para VM en Mac o instalación en PC",
                ru: "Выберите профиль для ВМ на Mac или установки на ПК",
                ar: "اختر إعدادًا مسبقًا للأجهزة الافتراضية على Mac أو الحواسيب"
            )
        case 1:
            return tr(
                lang: lang,
                zh: "拖入或选择本地 Windows 11 ARM64 / x64 ISO 镜像",
                en: "Drop or select a local Windows 11 ARM64 / x64 ISO image",
                fr: "Glissez ou sélectionnez une image ISO Windows 11 ARM64 / x64",
                es: "Arrastra o selecciona una imagen ISO de Windows 11 ARM64 / x64",
                ru: "Перетащите или выберите локальный ISO Windows 11 ARM64 / x64",
                ar: "اسحب أو اختر ملف ISO محليًا لنظام Windows 11 ‏(ARM64 / x64)"
            )
        case 2:
            return tr(
                lang: lang,
                zh: "查看或按需调整要移除的应用、组件与隐私策略",
                en: "Review or customize removed apps, features, and privacy policies",
                fr: "Vérifiez ou ajustez les applications, composants et stratégies",
                es: "Revisa o ajusta las apps, componentes y directivas a aplicar",
                ru: "Просмотрите или измените удаляемые приложения и политики",
                ar: "راجع أو عدّل التطبيقات والمكونات وسياسات الخصوصية المراد إزالتها"
            )
        case 3:
            return tr(
                lang: lang,
                zh: "配置镜像压缩等级、OOBE 断网直通与输出路径",
                en: "Configure image compression, offline OOBE bypass, and output paths",
                fr: "Configurez la compression, le compte local OOBE et les chemins",
                es: "Configura compresión, cuenta local en OOBE y rutas de salida",
                ru: "Настройте уровень сжатия, локальный вход OOBE и пути вывода",
                ar: "اضبط مستوى الضغط وتجاوز اتصال OOBE ومسارات الحفظ"
            )
        case 4:
            return tr(
                lang: lang,
                zh: "核对所有变更项并确认开始制作",
                en: "Review all planned changes before building",
                fr: "Vérifiez tous les paramètres avant de lancer la création",
                es: "Comprueba todos los cambios antes de iniciar la compilación",
                ru: "Проверьте сводку параметров перед началом сборки",
                ar: "تحقق من جميع التغييرات قبل بدء إنشاء ملف ISO"
            )
        default:
            return tr(
                lang: lang,
                zh: "实时查看八阶段流式裁剪与封装进度",
                en: "Monitor real-time 8-stage streaming pruning and ISO packaging",
                fr: "Suivez en direct les 8 étapes d’allègement et de création ISO",
                es: "Supervisa en tiempo real las 8 fases de recorte y empaquetado",
                ru: "Отслеживайте прогресс 8 этапов потоковой сборки в реальном времени",
                ar: "تابع تقدم مراحل التقليص والتغليف الثماني مباشرةً"
            )
        }
    }

    static func importRecipeButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "导入配方 (.json)",
            en: "Import Recipe (.json)",
            fr: "Importer une recette (.json)",
            es: "Importar receta (.json)",
            ru: "Импорт рецепта (.json)",
            ar: "استيراد وصفة (.json)"
        )
    }

    static func exportRecipeButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "导出当前配方",
            en: "Export Recipe",
            fr: "Exporter la recette",
            es: "Exportar receta",
            ru: "Экспорт рецепта",
            ar: "تصدير الوصفة الحالية"
        )
    }

    static func closeBannerButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "关闭", en: "Dismiss", fr: "Fermer", es: "Cerrar", ru: "Закрыть", ar: "إغلاق")
    }

    static func backButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "上一步", en: "Back", fr: "Précédent", es: "Atrás", ru: "Назад", ar: "السابق")
    }

    static func nextButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "下一步", en: "Next", fr: "Suivant", es: "Siguiente", ru: "Далее", ar: "التالي")
    }

    static func startBuildButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "开始制作精简版 ISO",
            en: "Build Slimmed ISO",
            fr: "Créer l’ISO allégé",
            es: "Crear ISO optimizado",
            ru: "Создать облегчённый ISO",
            ar: "بدء إنشاء ملف ISO المخفّف"
        )
    }

    static func newAnotherBuildButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "新建另一个构建",
            en: "Start Another Build",
            fr: "Nouvelle création",
            es: "Nueva compilación",
            ru: "Новая сборка",
            ar: "إنشاء بناء جديد"
        )
    }

    // MARK: - Core Risk Sheet & Quit Alert

    static func coreSheetTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "确认启用 Tiny11 Core 极限裁剪？",
            en: "Enable Irreversible Tiny11 Core Pruning?",
            fr: "Activer l’allègement extrême Tiny11 Core ?",
            es: "¿Activar el recorte extremo de Tiny11 Core?",
            ru: "Включить экстремальное урезание Tiny11 Core?",
            ar: "هل تريد تفعيل التقليص الأقصى Tiny11 Core؟"
        )
    }

    static func coreSheetDescription(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Tiny11 Core 会物理删除 WinSxS 组件库中的非核心文件、移除 WinRE 恢复环境，并禁用 Windows Update 与 Microsoft Defender。",
            en: "Tiny11 Core physically deletes non-essential files from the WinSxS component store, removes WinRE recovery, and disables Windows Update and Microsoft Defender.",
            fr: "Tiny11 Core supprime physiquement les fichiers non essentiels du magasin WinSxS, retire l’environnement WinRE et désactive Windows Update ainsi que Microsoft Defender.",
            es: "Tiny11 Core elimina físicamente archivos no esenciales del almacén WinSxS, quita la recuperación WinRE y desactiva Windows Update y Microsoft Defender.",
            ru: "Tiny11 Core физически удаляет неосновные файлы хранилища WinSxS, среду восстановления WinRE и отключает Windows Update и Microsoft Defender.",
            ar: "يقوم Tiny11 Core بحذف الملفات غير الأساسية من مخزن WinSxS فعليًا وإزالة بيئة الاسترداد WinRE وتعطيل Windows Update وMicrosoft Defender."
        )
    }

    static func coreSheetBullet1(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "• 安装后系统无法打任何安全补丁、累计更新或开启新系统功能；",
            en: "• Installed systems cannot install security patches, cumulative updates, or optional Windows features;",
            fr: "• Aucun correctif de sécurité, mise à jour cumulative ou fonctionnalité facultative ne pourra être installé ;",
            es: "• El sistema instalado no podrá recibir parches de seguridad, actualizaciones acumulativas ni nuevas funciones;",
            ru: "• После установки система не сможет получать обновления безопасности или добавлять компоненты Windows;",
            ar: "• لن يتمكن النظام بعد التثبيت من تلقي أي تحديثات أمنية أو تراكمية أو إضافة ميزات جديدة؛"
        )
    }

    static func coreSheetBullet2(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "• 若你的目标是在 Parallels Desktop / VMware Fusion / UTM 中作为日常办公主力机，强烈建议改选「Mac 虚拟机优化版」；",
            en: "• For daily use inside Parallels Desktop, VMware Fusion, or UTM, strongly consider \"Mac VM Optimized\" instead;",
            fr: "• Pour un usage quotidien dans Parallels Desktop, VMware Fusion ou UTM, privilégiez « Optimisé VM Mac » ;",
            es: "• Para uso diario en Parallels Desktop, VMware Fusion o UTM, se recomienda elegir «Optimizado para VM Mac»;",
            ru: "• Для повседневной работы в Parallels Desktop, VMware Fusion или UTM настоятельно рекомендуется «Оптимизация для ВМ Mac»;",
            ar: "• للاستخدام اليومي في Parallels Desktop أو VMware Fusion أو UTM، يُنصح بشدة باختيار «محسّن للأجهزة الافتراضية على Mac»؛"
        )
    }

    static func coreSheetBullet3(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "• Core 仅适合一次性软件测试或极限低配沙盒虚拟机。",
            en: "• Core is intended strictly for disposable software testing or ultra-low-resource sandbox VMs.",
            fr: "• Core est réservé aux tests ponctuels ou aux machines virtuelles bacs à sable très limitées.",
            es: "• Core solo es adecuado para pruebas desechables o máquinas virtuales aisladas de bajos recursos.",
            ru: "• Режим Core подходит только для одноразовых тестов ПО или изолированных песочниц.",
            ar: "• وضع Core مناسب فقط لاختبارات البرامج المؤقتة أو بيئات الاختبار المعزولة ذات الموارد المحدودة."
        )
    }

    static func coreSheetCancelButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "返回安全模式",
            en: "Keep Safe Mode",
            fr: "Revenir au mode sûr",
            es: "Volver al modo seguro",
            ru: "Вернуться к безопасному режиму",
            ar: "العودة إلى الوضع الآمن"
        )
    }

    static func coreSheetConfirmButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "我已知悉风险，继续启用 Core",
            en: "I Understand, Enable Core",
            fr: "J’accepte les risques, activer Core",
            es: "Entiendo los riesgos, activar Core",
            ru: "Я понимаю риски, включить Core",
            ar: "أدرك المخاطر، تفعيل Core"
        )
    }

    static func quitAlertTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在构建 Windows 11 镜像",
            en: "Windows 11 ISO Build in Progress",
            fr: "Création de l’ISO Windows 11 en cours",
            es: "Compilación de ISO de Windows 11 en curso",
            ru: "Идёт сборка образа Windows 11",
            ar: "جارٍ بناء صورة Windows 11"
        )
    }

    static func quitAlertMessage(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "当前仍有镜像处理任务正在运行。请先点击「安全取消」等待临时挂载点清理完成后再退出应用。",
            en: "An image build task is currently running. Please click \"Safe Cancel\" and wait for mounted volumes to detach before quitting.",
            fr: "Une tâche de traitement est toujours active. Cliquez d’abord sur « Annulation sécurisée » avant de quitter l’application.",
            es: "Hay una tarea de compilación en ejecución. Haz clic en «Cancelación segura» y espera a que se desmonten los volúmenes antes de salir.",
            ru: "Сейчас выполняется обработка образа. Нажмите «Безопасная отмена» и дождитесь очистки точек монтирования перед выходом.",
            ar: "لا تزال عملية معالجة الصورة قيد التشغيل. يرجى النقر على «إلغاء آمن» والانتظار حتى اكتمال التنظيف قبل إنهاء التطبيق."
        )
    }

    static func quitAlertContinueButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "继续构建",
            en: "Continue Building",
            fr: "Continuer la création",
            es: "Continuar compilación",
            ru: "Продолжить сборку",
            ar: "متابعة البناء"
        )
    }

    // MARK: - ViewModel Panels, Banners & Status

    static func stageWaiting(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "等待执行", en: "Waiting", fr: "En attente", es: "En espera", ru: "Ожидание", ar: "قيد الانتظار")
    }

    static func toolStatusBundled(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "内置原生引擎就绪 (wimlib + libhivex + mkisofs)",
            en: "Bundled Native Engine Ready (wimlib + libhivex + mkisofs)",
            fr: "Moteur natif intégré prêt (wimlib + libhivex + mkisofs)",
            es: "Motor nativo integrado listo (wimlib + libhivex + mkisofs)",
            ru: "Встроенный нативный движок готов (wimlib + libhivex + mkisofs)",
            ar: "المحرك الأصلي المدمج جاهز (wimlib + libhivex + mkisofs)"
        )
    }

    static func toolStatusDev(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "开发环境原生引擎就绪 (Homebrew ARM64)",
            en: "Development Native Engine Ready (Homebrew ARM64)",
            fr: "Moteur natif de développement prêt (Homebrew ARM64)",
            es: "Motor nativo de desarrollo listo (Homebrew ARM64)",
            ru: "Нативный движок разработки готов (Homebrew ARM64)",
            ar: "محرك التطوير الأصلي جاهز (Homebrew ARM64)"
        )
    }

    static func pickSourcePanelTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "选择 Windows 11 官方 ISO 镜像或解压目录",
            en: "Select Official Windows 11 ISO or Extracted Folder",
            fr: "Sélectionner l’ISO officiel Windows 11 ou un dossier extrait",
            es: "Seleccionar ISO oficial de Windows 11 o carpeta extraída",
            ru: "Выберите официальный ISO Windows 11 или распакованную папку",
            ar: "اختر ملف ISO الرسمي لنظام Windows 11 أو مجلدًا مستخرجًا"
        )
    }

    static func pickOutputPanelTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "选择精简版 ISO 保存位置",
            en: "Save Slimmed Windows 11 ISO As",
            fr: "Choisir l’emplacement de sauvegarde de l’ISO allégé",
            es: "Elegir ubicación para guardar el ISO optimizado",
            ru: "Выберите место сохранения облегчённого ISO",
            ar: "اختر موقع حفظ ملف ISO المخفّف"
        )
    }

    static func pickWorkspacePanelTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "选择构建临时工作缓存目录",
            en: "Select Temporary Build Workspace Folder",
            fr: "Choisir le dossier temporaire de travail",
            es: "Seleccionar carpeta temporal de trabajo",
            ru: "Выберите временный рабочий каталог сборки",
            ar: "اختر مجلد العمل المؤقت للبناء"
        )
    }

    static func exportRecipePanelTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "导出 Tiny11 构建配方 (.json)",
            en: "Export Tiny11 Build Recipe (.json)",
            fr: "Exporter la recette Tiny11 (.json)",
            es: "Exportar receta de Tiny11 (.json)",
            ru: "Экспорт рецепта сборки Tiny11 (.json)",
            ar: "تصدير وصفة بناء Tiny11 ‏(.json)"
        )
    }

    static func importRecipePanelTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "导入 Tiny11 构建配方 (.json)",
            en: "Import Tiny11 Build Recipe (.json)",
            fr: "Importer une recette Tiny11 (.json)",
            es: "Importar receta de Tiny11 (.json)",
            ru: "Импорт рецепта сборки Tiny11 (.json)",
            ar: "استيراد وصفة بناء Tiny11 ‏(.json)"
        )
    }

    static func recipeExportedBanner(_ fileName: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "构建配方已保存至 \(fileName)",
            en: "Build recipe saved to \(fileName)",
            fr: "Recette enregistrée sous \(fileName)",
            es: "Receta guardada en \(fileName)",
            ru: "Рецепт сборки сохранён в \(fileName)",
            ar: "تم حفظ وصفة البناء في \(fileName)"
        )
    }

    static func recipeExportFailedBanner(_ error: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "保存配方失败：\(error)",
            en: "Failed to save recipe: \(error)",
            fr: "Échec de l’enregistrement de la recette : \(error)",
            es: "Error al guardar la receta: \(error)",
            ru: "Не удалось сохранить рецепт: \(error)",
            ar: "فشل حفظ الوصفة: \(error)"
        )
    }

    static func recipeImportedBanner(_ fileName: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已导入配方：\(fileName)",
            en: "Imported recipe: \(fileName)",
            fr: "Recette importée : \(fileName)",
            es: "Receta importada: \(fileName)",
            ru: "Импортирован рецепт: \(fileName)",
            ar: "تم استيراد الوصفة: \(fileName)"
        )
    }

    static func recipeImportFailedBanner(_ error: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "导入配方失败：\(error)",
            en: "Failed to import recipe: \(error)",
            fr: "Échec de l’importation de la recette : \(error)",
            es: "Error al importar la receta: \(error)",
            ru: "Не удалось импортировать рецепт: \(error)",
            ar: "فشل استيراد الوصفة: \(error)"
        )
    }

    static func cancelBuildLogLine(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在安全中止当前子进程并清理挂载点...",
            en: "Safely terminating active subprocess and detaching mounted volumes...",
            fr: "Arrêt sécurisé du sous-processus et démontage des volumes...",
            es: "Deteniendo subproceso de forma segura y desmontando volúmenes...",
            ru: "Безопасная остановка подпроцесса и размонтирование томов...",
            ar: "جارٍ إيقاف العملية الفرعية بأمان وفصل وحدات التخزين المركّبة..."
        )
    }

    static func copiedToClipboardBanner(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已复制到剪贴板",
            en: "Copied to clipboard",
            fr: "Copié dans le presse-papiers",
            es: "Copiado al portapapeles",
            ru: "Скопировано в буфер обмена",
            ar: "تم النسخ إلى الحافظة"
        )
    }

    // MARK: - Step 1: Mode Selection & Tiny11 Edge Option

    static func modeViewTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "选择你的 Windows 11 精简模式",
            en: "Choose Your Windows 11 Slimming Mode",
            fr: "Choisissez votre mode d’allègement Windows 11",
            es: "Elige tu modo de optimización de Windows 11",
            ru: "Выберите режим облегчения Windows 11",
            ar: "اختر وضع تخفيف Windows 11 المناسب لك"
        )
    }

    static func modeViewSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "在 Apple Silicon Mac 上无需虚拟机、无需管理员密码，流式裁剪并生成干净轻量的可引导 ISO。",
            en: "Stream-prune and build a clean, lightweight bootable Windows 11 ISO natively on Apple Silicon Mac—no VM or sudo password needed.",
            fr: "Allégez et générez une image ISO Windows 11 propre et amorçable nativement sur Mac Apple Silicon, sans VM ni mot de passe administrateur.",
            es: "Recorta y genera un ISO arrancable limpio y ligero de Windows 11 de forma nativa en Mac con Apple Silicon, sin VM ni contraseña de administrador.",
            ru: "Создавайте чистый и лёгкий загрузочный ISO Windows 11 нативно на Mac с Apple Silicon — без виртуальной машины и прав администратора.",
            ar: "قم بتقليص وبناء ملف ISO نظيف وخفيف قابل للإقلاع لنظام Windows 11 مباشرةً على Mac بمعالج Apple Silicon دون آلة افتراضية أو صلاحيات مسؤول."
        )
    }

    static func engineIsolationCaption(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "全程在用户态直接操作 WIM 归档与离线注册表二进制文件，100% 隔离宿主机 macOS 系统。",
            en: "Operates directly on WIM streams and offline registry binaries in user space—100% isolated from your host macOS system.",
            fr: "Opère directement en espace utilisateur sur les flux WIM et ruches de registre hors ligne, 100 % isolé de macOS.",
            es: "Opera directamente en espacio de usuario sobre archivos WIM y registros sin conexión, 100 % aislado de macOS.",
            ru: "Работает напрямую с архивами WIM и офлайн-реестром в пользовательском режиме — 100% изолированно от macOS.",
            ar: "يعمل مباشرةً في فضاء المستخدم على أرشيفات WIM وملفات السجل دون اتصال بمعزل تام 100% عن نظام macOS."
        )
    }

    static func modeCardSelected(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "当前已选模式",
            en: "Currently Selected",
            fr: "Mode sélectionné",
            es: "Modo seleccionado",
            ru: "Выбранный режим",
            ar: "الوضع المحدد حاليًا"
        )
    }

    static func modeCardClickToSelect(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "点击选择并下一步",
            en: "Click to Select & Continue",
            fr: "Cliquer pour choisir et continuer",
            es: "Clic para elegir y continuar",
            ru: "Нажмите для выбора и продолжения",
            ar: "انقر للاختيار والمتابعة"
        )
    }

    static func tiny11EdgeToggleLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "精简 Microsoft Edge（移除 Edge 与 WebView2）",
            en: "Slim Microsoft Edge (remove Edge & WebView2)",
            fr: "Alléger Microsoft Edge (supprimer Edge et WebView2)",
            es: "Recortar Microsoft Edge (eliminar Edge y WebView2)",
            ru: "Удалить Microsoft Edge (включая WebView2)",
            ar: "تقليص Microsoft Edge (إزالة المتصفح وWebView2)"
        )
    }

    static func tiny11EdgeBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Tiny11 标准精简版可选项：精简 Microsoft Edge 浏览器",
            en: "Tiny11 Standard Option: Slim Microsoft Edge Browser",
            fr: "Option Tiny11 Standard : Alléger Microsoft Edge",
            es: "Opción Tiny11 Estándar: Recortar Microsoft Edge",
            ru: "Опция Tiny11 Стандарт: Удаление браузера Microsoft Edge",
            ar: "خيار الإصدار القياسي Tiny11: تقليص متصفح Microsoft Edge"
        )
    }

    static func tiny11EdgeBoxSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "开启时彻底移除 Edge 与 WebView2 目录；关闭时完整保留浏览器及 WebView2 运行库兼容性（仍默认净化首次启动推广弹窗）。",
            en: "When enabled, physically removes Edge and WebView2 directories; when off, keeps Edge and WebView2 runtime compatibility (first-run promos remain suppressed).",
            fr: "Activé : supprime physiquement Edge et WebView2 ; désactivé : conserve le navigateur et la compatibilité WebView2 (sans fenêtres promotionnelles).",
            es: "Activado: elimina físicamente Edge y WebView2; desactivado: conserva el navegador y la compatibilidad con WebView2 (sin ventanas promocionales).",
            ru: "Включено: физически удаляет каталоги Edge и WebView2; выключено: сохраняет браузер и совместимость с WebView2 (без рекламных окон).",
            ar: "عند التفعيل يتم حذف مجلدات Edge وWebView2 بالكامل؛ وعند الإيقاف يُحتفظ بالمتصفح وتوافق WebView2 مع إخفاء النوافذ الترويجية."
        )
    }

    // MARK: - Step 2: Source Import

    static func sourceViewTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "导入本地 Windows 11 安装镜像",
            en: "Import Local Windows 11 Installation Media",
            fr: "Importer une image d’installation Windows 11 locale",
            es: "Importar medio de instalación local de Windows 11",
            ru: "Импорт локального установочного образа Windows 11",
            ar: "استيراد صورة تثبيت Windows 11 المحلية"
        )
    }

    static func sourceViewSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "支持 Windows 11 22H2 / 23H2 / 24H2 / 25H2 及更新版本（ARM64 或 x64 官方 ISO）。源镜像仅以只读方式读取，绝不会被修改。",
            en: "Supports Windows 11 22H2 / 23H2 / 24H2 / 25H2 and newer (official ARM64 or x64 ISO). Your source ISO is mounted strictly read-only and never modified.",
            fr: "Prend en charge Windows 11 22H2 / 23H2 / 24H2 / 25H2 et versions ultérieures (ISO officiel ARM64 ou x64). L’image source est lue uniquement sans jamais être modifiée.",
            es: "Compatible con Windows 11 22H2 / 23H2 / 24H2 / 25H2 y posteriores (ISO oficial ARM64 o x64). La imagen de origen se abre solo en lectura y nunca se modifica.",
            ru: "Поддерживаются Windows 11 22H2 / 23H2 / 24H2 / 25H2 и новее (официальные ISO ARM64 или x64). Исходный образ открывается только для чтения.",
            ar: "يدعم Windows 11 بإصدارات 22H2 و23H2 و24H2 و25H2 والأحدث (ملفات ISO الرسمية لمعماريتي ARM64 أو x64). تُقرأ صورة المصدر بوضع القراءة فقط دون تعديلها."
        )
    }

    static func inspectingProgressText(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "正在只读挂载并解析 WIM/ESD 版本信息...",
            en: "Mounting read-only and inspecting WIM/ESD editions...",
            fr: "Montage en lecture seule et analyse des éditions WIM/ESD...",
            es: "Montando en solo lectura y analizando ediciones WIM/ESD...",
            ru: "Монтирование только для чтения и анализ редакций WIM/ESD...",
            ar: "جارٍ التركيب للقراءة فقط وتحليل نسخ WIM/ESD..."
        )
    }

    static func dropZoneHeadline(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "将 Windows 11 .iso 文件拖放到此处",
            en: "Drag & Drop Your Windows 11 .iso File Here",
            fr: "Glissez-déposez votre fichier Windows 11 .iso ici",
            es: "Arrastra y suelta aquí tu archivo .iso de Windows 11",
            ru: "Перетащите файл Windows 11 .iso сюда",
            ar: "اسحب وأفلت ملف Windows 11 .iso هنا"
        )
    }

    static func dropZoneSubheadline(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "或者点击下方按钮选择本地 .iso 镜像 / 已解压安装目录",
            en: "Or click below to browse for a local .iso image or extracted setup folder",
            fr: "Ou cliquez ci-dessous pour choisir un fichier .iso ou un dossier d’installation",
            es: "O haz clic abajo para seleccionar un archivo .iso o carpeta extraída",
            ru: "Или нажмите кнопку ниже, чтобы выбрать локальный .iso или папку установки",
            ar: "أو انقر على الزر أدناه لاختيار ملف .iso محلي أو مجلد تثبيت مستخرج"
        )
    }

    static func pickLocalIsoButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "选择本地 ISO 文件...",
            en: "Choose Local ISO File...",
            fr: "Choisir un fichier ISO local...",
            es: "Seleccionar archivo ISO local...",
            ru: "Выбрать локальный ISO-файл...",
            ar: "اختيار ملف ISO محلي..."
        )
    }

    static func detectedMediaBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "检测到的镜像详情与版本选择",
            en: "Detected Image Details & Edition Selection",
            fr: "Détails de l’image détectée et choix de l’édition",
            es: "Detalles detectados y selección de edición",
            ru: "Сведения об образе и выбор редакции",
            ar: "تفاصيل الصورة المكتشفة واختيار النسخة"
        )
    }

    static func mediaFormatLabel(relativePath: String, formattedSize: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "介质格式：\(relativePath) (\(formattedSize))",
            en: "Media payload: \(relativePath) (\(formattedSize))",
            fr: "Format du média : \(relativePath) (\(formattedSize))",
            es: "Formato del medio: \(relativePath) (\(formattedSize))",
            ru: "Формат носителя: \(relativePath) (\(formattedSize))",
            ar: "تنسيق الوسيط: \(relativePath) (\(formattedSize))"
        )
    }

    static func netFx3IncludedLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "包含 .NET 3.5 离线包",
            en: "Includes .NET 3.5 offline payload",
            fr: "Contient le paquet hors ligne .NET 3.5",
            es: "Incluye paquete sin conexión .NET 3.5",
            ru: "Содержит офлайн-пакет .NET 3.5",
            ar: "يتضمن حزمة .NET 3.5 دون اتصال"
        )
    }

    static func netFx3MissingLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "不含 sxs 载荷",
            en: "No sxs payload",
            fr: "Sans dossier sxs",
            es: "Sin carga sxs",
            ru: "Без пакетов sxs",
            ar: "لا توجد حزمة sxs"
        )
    }

    static func skuPickerLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "选择要提取并精简的 Windows 版本 (SKU)：",
            en: "Select Windows Edition (SKU) to Extract & Slim:",
            fr: "Édition Windows (SKU) à extraire et alléger :",
            es: "Edición de Windows (SKU) a extraer y optimizar:",
            ru: "Выберите редакцию Windows (SKU) для обработки:",
            ar: "اختر نسخة Windows المراد استخراجها وتخفيفها:"
        )
    }

    static func logicalSizeCaption(_ formattedSize: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "逻辑展开大小：\(formattedSize) · 将仅导出此单一版本，自动剔除其他冗余 SKU。",
            en: "Expanded size: \(formattedSize) · Only this single edition will be exported, omitting other redundant SKUs.",
            fr: "Taille déployée : \(formattedSize) · Seule cette édition sera exportée, éliminant les autres SKU superflus.",
            es: "Tamaño expandido: \(formattedSize) · Solo se exportará esta edición, descartando las demás SKU redundantes.",
            ru: "Развёрнутый размер: \(formattedSize) · Будет экспортирована только эта редакция без лишних SKU.",
            ar: "الحجم المنشور: \(formattedSize) · سيتم تصدير هذه النسخة فقط واستبعاد النسخ الأخرى الزائدة."
        )
    }

    static func x64OnMacVmTip(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "提示：当前导入的是 x64 镜像。若用于 Apple Silicon 上的 Parallels Desktop 或 VMware Fusion 高速虚拟化，建议使用 ARM64 版 Windows 11 ISO；x64 镜像适用于 PC 真机装机或 UTM 跨架构模拟。",
            en: "Tip: You imported an x64 ISO. For native-speed virtualization on Apple Silicon (Parallels Desktop or VMware Fusion), an ARM64 Windows 11 ISO is recommended; x64 ISOs suit Intel/AMD PCs or UTM emulation.",
            fr: "Conseil : vous avez importé une image x64. Pour une virtualisation rapide sur Apple Silicon (Parallels Desktop / VMware Fusion), préférez un ISO Windows 11 ARM64 ; x64 convient aux PC ou à l’émulation UTM.",
            es: "Consejo: importaste una imagen x64. Para virtualización nativa en Apple Silicon (Parallels Desktop o VMware Fusion), usa un ISO ARM64; x64 es ideal para PC reales o emulación en UTM.",
            ru: "Совет: импортирован образ x64. Для быстрой виртуализации на Apple Silicon (Parallels Desktop / VMware Fusion) рекомендуется ARM64-образ Windows 11; x64 подходит для ПК или эмуляции в UTM.",
            ar: "ملاحظة: الصورة المستوردة بمعمارية x64. للحصول على سرعة افتراضية كاملة على Apple Silicon ‏(Parallels أو VMware Fusion) يُنصح بصورة ARM64؛ بينما تناسب x64 الحواسيب التقليدية أو محاكاة UTM."
        )
    }

    // MARK: - Step 3: Customization

    static func customizeViewTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "组件裁剪与系统策略清单",
            en: "Component Pruning & System Policies",
            fr: "Composants à supprimer et stratégies système",
            es: "Recorte de componentes y directivas del sistema",
            ru: "Удаление компонентов и системные политики",
            ar: "قائمة تقليص المكونات وسياسات النظام"
        )
    }

    static func customizeViewSubtitle(modeTitle: String, selectedCount: Int, totalCount: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "当前模式：\(modeTitle) · 已启用 \(selectedCount) / \(totalCount) 项规则（修改任意非预设开关会自动转为自定义模式）。",
            en: "Current mode: \(modeTitle) · \(selectedCount) / \(totalCount) rules enabled (changing other checkboxes switches to Custom mode).",
            fr: "Mode actuel : \(modeTitle) · \(selectedCount) / \(totalCount) règles activées (modifier d’autres options bascule en mode Custom).",
            es: "Modo actual: \(modeTitle) · \(selectedCount) / \(totalCount) reglas activas (cambiar otras casillas pasa al modo Custom).",
            ru: "Режим: \(modeTitle) · активно правил: \(selectedCount) из \(totalCount) (изменение прочих пунктов переключит в Custom).",
            ar: "الوضع الحالي: \(modeTitle) · تم تفعيل \(selectedCount) من أصل \(totalCount) قاعدة (تعديل الخيارات الأخرى يحوّل إلى الوضع المخصص)."
        )
    }

    static func quickPresetMenuTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "快速套用预设",
            en: "Quick Presets",
            fr: "Profils rapides",
            es: "Perfiles rápidos",
            ru: "Быстрые профили",
            ar: "قوالب سريعة"
        )
    }

    static func applyMacVmPresetButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "套用 Mac 虚拟机优化预设",
            en: "Apply Mac VM Optimized Preset",
            fr: "Appliquer le profil Optimisé VM Mac",
            es: "Aplicar perfil Optimizado para VM Mac",
            ru: "Применить профиль для ВМ Mac",
            ar: "تطبيق قالب الأجهزة الافتراضية على Mac"
        )
    }

    static func applyTiny11PresetButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "套用 Tiny11 标准版预设",
            en: "Apply Tiny11 Standard Preset",
            fr: "Appliquer le profil Tiny11 Standard",
            es: "Aplicar perfil Tiny11 Estándar",
            ru: "Применить стандартный профиль Tiny11",
            ar: "تطبيق قالب Tiny11 القياسي"
        )
    }

    static func clearAllSelectionsButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "清空全部勾选",
            en: "Clear All Selections",
            fr: "Tout décocher",
            es: "Desmarcar todo",
            ru: "Снять все отметки",
            ar: "إلغاء تحديد الكل"
        )
    }

    static func categoryPickerLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "分类", en: "Category", fr: "Catégorie", es: "Categoría", ru: "Категория", ar: "الفئة")
    }

    static func searchPlaceholder(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "搜索组件或策略...",
            en: "Search apps or policies...",
            fr: "Rechercher...",
            es: "Buscar componente...",
            ru: "Поиск компонентов...",
            ar: "ابحث عن مكون أو سياسة..."
        )
    }

    static func coreToggleBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "启用 Tiny11 Core 级不可逆组件库裁剪 (WinSxS + WinRE + 禁用更新)",
            en: "Enable Irreversible Tiny11 Core Component Store Pruning (WinSxS + WinRE + Disable Updates)",
            fr: "Activer l’allègement irréversible Tiny11 Core (WinSxS + WinRE + mises à jour désactivées)",
            es: "Activar recorte irreversible Tiny11 Core (WinSxS + WinRE + desactivar actualizaciones)",
            ru: "Включить необратимую очистку Tiny11 Core (WinSxS + WinRE + отключение обновлений)",
            ar: "تفعيل تقليص Tiny11 Core غير القابل للتراجع (WinSxS + WinRE + تعطيل التحديثات)"
        )
    }

    static func coreToggleBoxSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "进一步缩减数百 MB 体积，但系统将彻底无法安装安全更新、语言包或可选功能。日常主力虚拟机请保持关闭。",
            en: "Saves several hundred additional MB, but permanently prevents installing security updates, language packs, or optional features. Keep off for daily-driver VMs.",
            fr: "Économise plusieurs centaines de Mo supplémentaires, mais empêche définitivement d’installer des mises à jour ou packs de langue. Laissez désactivé pour un usage quotidien.",
            es: "Ahorra varios cientos de MB adicionales, pero impide permanentemente instalar parches de seguridad o paquetes de idioma. Mantenlo apagado para uso diario.",
            ru: "Дополнительно экономит сотни МБ, но навсегда лишает возможности ставить обновления безопасности и языковые пакеты. Не включайте для основной ВМ.",
            ar: "يوفر مئات الميغابايت الإضافية، لكنه يمنع نهائيًا تثبيت التحديثات الأمنية أو حزم اللغات أو الميزات الاختيارية. أبقِه متوقفًا للاستخدام اليومي."
        )
    }

    // MARK: - Step 4: Settings

    static func settingsViewTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "镜像压缩率与部署选项",
            en: "Image Compression & Deployment Options",
            fr: "Compression de l’image et options de déploiement",
            es: "Compresión de imagen y opciones de despliegue",
            ru: "Степень сжатия и параметры развёртывания",
            ar: "ضغط الصورة وخيارات التثبيت"
        )
    }

    static func settingsViewSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "利用 Apple Silicon 多核性能压缩系统卷，并配置安装阶段体验与输出文件位置。",
            en: "Leverage Apple Silicon multi-core compression, configure first-boot setup behavior, and choose output locations.",
            fr: "Exploitez le multicœur Apple Silicon pour comprimer l’image et configurer l’installation ainsi que les chemins de sortie.",
            es: "Aprovecha el rendimiento multinúcleo de Apple Silicon para comprimir el volumen y configurar la instalación y rutas.",
            ru: "Используйте многоядерность Apple Silicon для сжатия образа и настройте параметры установки и пути сохранения.",
            ar: "استفد من تعدد أنوية Apple Silicon لضغط صورة النظام وضبط تجربة التثبيت ومسارات الحفظ."
        )
    }

    static func compressionBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "最终镜像压缩方式",
            en: "Final Image Compression Mode",
            fr: "Mode de compression finale",
            es: "Modo de compresión final",
            ru: "Режим сжатия итогового образа",
            ar: "طريقة ضغط الصورة النهائية"
        )
    }

    static func installEnhancementsBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "安装与虚拟机增强开关",
            en: "Setup & Virtual Machine Enhancements",
            fr: "Améliorations d’installation et de machine virtuelle",
            es: "Mejoras de instalación y máquina virtual",
            ru: "Улучшения установки и виртуальной машины",
            ar: "تحسينات التثبيت والأجهزة الافتراضية"
        )
    }

    static func preferLocalAccountTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "优先使用本地离线账户并启用断网直通 (BypassNRO)",
            en: "Prefer Local Offline Account & Enable BypassNRO",
            fr: "Préférer un compte local hors ligne (BypassNRO)",
            es: "Preferir cuenta local sin conexión y activar BypassNRO",
            ru: "Локальная учётная запись без интернета (BypassNRO)",
            ar: "تفضيل الحساب المحلي دون اتصال وتفعيل BypassNRO"
        )
    }

    static func preferLocalAccountSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "隐藏开机强制登录微软账号界面，彻底解决 UTM / VMware Fusion 初装缺少网卡驱动时无法跳过联网界面的死锁问题。",
            en: "Hides mandatory Microsoft Account sign-in screens and prevents OOBE network deadlocks in UTM / VMware Fusion before NIC drivers are installed.",
            fr: "Masque la connexion obligatoire au compte Microsoft et évite le blocage réseau OOBE dans UTM / VMware Fusion sans pilote réseau.",
            es: "Oculta el inicio de sesión obligatorio con cuenta Microsoft y evita bloqueos de red en UTM / VMware Fusion al faltar controladores.",
            ru: "Скрывает принудительный вход в аккаунт Microsoft и устраняет зависание OOBE без драйвера сети в UTM / VMware Fusion.",
            ar: "يُخفي شاشة تسجيل حساب Microsoft الإجبارية ويحل مشكلة توقف الإعداد الأول عند غياب تعريف الشبكة في UTM وVMware Fusion."
        )
    }

    static func compactOsTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "启用 CompactOS 紧凑系统部署",
            en: "Enable CompactOS Deployment",
            fr: "Activer le déploiement CompactOS",
            es: "Activar despliegue compacto CompactOS",
            ru: "Включить компактное развёртывание CompactOS",
            ar: "تفعيل التثبيت المضغوط CompactOS"
        )
    }

    static func compactOsSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "在无人值守应答配置中启用 NTFS 透明系统文件压缩，虚拟机安装后额外节省约 2~3 GB 磁盘占用。",
            en: "Enables transparent NTFS OS binary compression via autounattend.xml, saving an extra ~2–3 GB inside your VM disk.",
            fr: "Active la compression transparente NTFS des fichiers système, économisant ~2 à 3 Go supplémentaires sur le disque virtuel.",
            es: "Activa la compresión transparente NTFS de archivos del sistema, ahorrando unos 2–3 GB adicionales tras instalar.",
            ru: "Включает прозрачное NTFS-сжатие системных файлов в файле ответов, экономя ещё ~2–3 ГБ на диске ВМ.",
            ar: "يفعّل ضغط ملفات النظام الشفاف NTFS أثناء التثبيت لتوفير نحو 2 إلى 3 غيغابايت إضافية من مساحة القرص."
        )
    }

    static func cleanCacheTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "清理离线更新缓存与崩溃日志",
            en: "Clean Offline Update Cache & Crash Logs",
            fr: "Nettoyer le cache de mise à jour et les journaux d’erreur",
            es: "Limpiar caché de actualizaciones y registros de fallos",
            ru: "Очистить офлайн-кэш обновлений и отчёты о сбоях",
            ar: "تنظيف ذاكرة التحديثات المؤقتة وسجلات الأعطال"
        )
    }

    static func cleanCacheSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "安全清空 SoftwareDistribution 下载缓存、临时目录与错误报告归档。",
            en: "Safely empties SoftwareDistribution download caches, temp folders, and Windows Error Reporting archives.",
            fr: "Vide en toute sécurité le cache SoftwareDistribution, les dossiers temporaires et les rapports d’erreurs.",
            es: "Vacía de forma segura la caché de SoftwareDistribution, carpetas temporales e informes de errores.",
            ru: "Безопасно очищает кэш загрузок SoftwareDistribution, временные папки и архивы отчётов об ошибках.",
            ar: "إفراغ ملفات SoftwareDistribution المؤقتة ومجلدات Temp وأرشيف تقارير الأخطاء بأمان."
        )
    }

    static func enableNetFx3Title(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "部署期间自动启用 .NET Framework 3.5",
            en: "Enable .NET Framework 3.5 During Setup",
            fr: "Activer automatiquement .NET Framework 3.5 à l’installation",
            es: "Activar .NET Framework 3.5 durante el despliegue",
            ru: "Автоматически включить .NET Framework 3.5 при установке",
            ar: "تفعيل .NET Framework 3.5 تلقائيًا أثناء التثبيت"
        )
    }

    static func enableNetFx3Subtitle(hasPayload: Bool?, isCore: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if hasPayload == false {
            return tr(
                lang: lang,
                zh: "当前导入的 ISO 不含 sources/sxs 载荷，不可用。",
                en: "Unavailable because the imported ISO does not contain sources/sxs.",
                fr: "Indisponible car l’ISO importé ne contient pas le dossier sources/sxs.",
                es: "No disponible porque el ISO importado no incluye la carpeta sources/sxs.",
                ru: "Недоступно: импортированный ISO не содержит каталог sources/sxs.",
                ar: "غير متاح لأن ملف ISO المستورد لا يحتوي على مجلد sources/sxs."
            )
        }
        if isCore {
            return tr(
                lang: lang,
                zh: "Tiny11 Core 模式下不可启用可选功能。",
                en: "Optional features cannot be enabled in Tiny11 Core mode.",
                fr: "Les fonctionnalités facultatives ne peuvent pas être activées en mode Tiny11 Core.",
                es: "No se pueden activar características opcionales en modo Tiny11 Core.",
                ru: "В режиме Tiny11 Core включение дополнительных компонентов недоступно.",
                ar: "لا يمكن تفعيل الميزات الاختيارية في وضع Tiny11 Core."
            )
        }
        return tr(
            lang: lang,
            zh: "从安装盘自带的 sources/sxs 离线启用传统软件所需的 .NET 2.0/3.5 运行库。",
            en: "Enables .NET 2.0/3.5 offline from the media's sources/sxs folder for legacy Windows apps.",
            fr: "Active .NET 2.0/3.5 hors ligne depuis le dossier sources/sxs du média pour les logiciels classiques.",
            es: "Habilita .NET 2.0/3.5 sin conexión desde sources/sxs para aplicaciones clásicas de Windows.",
            ru: "Офлайн-включение среды .NET 2.0/3.5 из папки sources/sxs для классических программ.",
            ar: "تفعيل مكتبات .NET 2.0/3.5 دون اتصال من مجلد sources/sxs لدعم البرامج الكلاسيكية."
        )
    }

    static func omitNetFx3Title(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "从输出 ISO 中省略 .NET 3.5 安装载荷 (sources/sxs)",
            en: "Omit .NET 3.5 Payload (sources/sxs) from Output ISO",
            fr: "Omettre le dossier .NET 3.5 (sources/sxs) de l’ISO final",
            es: "Omitir carga .NET 3.5 (sources/sxs) del ISO de salida",
            ru: "Исключить пакеты .NET 3.5 (sources/sxs) из выходного ISO",
            ar: "استبعاد حزمة .NET 3.5 ‏(sources/sxs) من ملف ISO الناتج"
        )
    }

    static func omitNetFx3Subtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "若不需要离线安装 .NET 3.5，省略该目录可使生成的 ISO 进一步减小约 70 MB。",
            en: "Saves ~70 MB on the output ISO if you do not need offline .NET 3.5 installation.",
            fr: "Réduit la taille de l’ISO généré d’environ 70 Mo si vous n’avez pas besoin de .NET 3.5 hors ligne.",
            es: "Reduce el tamaño del ISO final en unos 70 MB si no necesitas instalar .NET 3.5 sin conexión.",
            ru: "Уменьшает размер выходного ISO примерно на 70 МБ, если офлайн-установка .NET 3.5 не нужна.",
            ar: "يقلل حجم ملف ISO الناتج بنحو 70 ميغابايت إذا لم تكن بحاجة لتثبيت .NET 3.5 دون اتصال."
        )
    }

    static func keepWorkingFilesTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "构建成功后保留临时工作目录文件",
            en: "Keep Temporary Working Files After Build",
            fr: "Conserver les fichiers temporaires après la création",
            es: "Conservar archivos temporales tras completar",
            ru: "Сохранять временные рабочие файлы после сборки",
            ar: "الاحتفاظ بملفات العمل المؤقتة بعد نجاح البناء"
        )
    }

    static func keepWorkingFilesSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "默认在发布校验通过后自动清理数 GB 的中间缓存（仅保留日志与报告）。调试排障时可开启。",
            en: "Multi-GB staging files are cleaned up automatically after verification (keeping logs & report). Enable only for debugging.",
            fr: "Les fichiers intermédiaires de plusieurs Go sont nettoyés automatiquement après vérification (journaux conservés). Utile pour le débogage.",
            es: "Los archivos intermedios se limpian automáticamente tras validar (conservando registros e informe). Actívalo solo para depuración.",
            ru: "Промежуточные гигабайтные кэши автоматически удаляются после проверки (логи сохраняются). Включайте для отладки.",
            ar: "يتم حذف الملفات المؤقتة تلقائيًا بعد التحقق (مع الاحتفاظ بالسجلات والتقرير). فعّله لأغراض التشخيص فقط."
        )
    }

    static func pathsBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "输出 ISO 与工作缓存路径",
            en: "Output ISO & Workspace Paths",
            fr: "Chemins de l’ISO de sortie et du cache de travail",
            es: "Rutas de salida ISO y directorio de trabajo",
            ru: "Пути сохранения ISO и рабочего кэша",
            ar: "مسار حفظ ISO ومجلد العمل المؤقت"
        )
    }

    static func outputIsoPathLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "精简版 ISO 保存路径（绝不覆盖已有文件）：",
            en: "Output ISO path (existing files are never overwritten):",
            fr: "Chemin de sauvegarde de l’ISO (aucun fichier existant écrasé) :",
            es: "Ruta de guardado del ISO (nunca sobrescribe archivos existentes):",
            ru: "Путь сохранения ISO (существующие файлы не перезаписываются):",
            ar: "مسار حفظ ملف ISO الناتج (لا يستبدل الملفات الموجودة أبدًا):"
        )
    }

    static func outputIsoPlaceholder(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "输出 .iso 路径", en: "Output .iso path", fr: "Chemin .iso de sortie", es: "Ruta .iso de salida", ru: "Путь к выходному .iso", ar: "مسار ملف .iso الناتج")
    }

    static func browseButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "浏览...", en: "Browse...", fr: "Parcourir...", es: "Examinar...", ru: "Обзор...", ar: "استعراض...")
    }

    static func workspacePathLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "构建临时工作目录（需源 ISO 体积 2 倍可用空间，约 10~15 GiB，支持普通 APFS 分区）：",
            en: "Temporary workspace directory (requires ~2× source ISO size, ~10–15 GiB free, works on standard APFS):",
            fr: "Dossier temporaire de travail (~2× la taille de l’ISO source requis, compatible APFS standard) :",
            es: "Directorio temporal de trabajo (requiere ~2× el tamaño del ISO origen, compatible con APFS estándar):",
            ru: "Временный рабочий каталог (требуется ~2× размера исходного ISO, подходит обычный раздел APFS):",
            ar: "مجلد العمل المؤقت (يتطلب نحو ضعفي حجم ملف ISO الأصلي ويدعم أقسام APFS العادية):"
        )
    }

    static func customOnlyBadge(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "仅限自定义",
            en: "Custom Only",
            fr: "Custom seul",
            es: "Solo Custom",
            ru: "Только Custom",
            ar: "مخصّص فقط"
        )
    }

    static func shrinkBootImageTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "精简重建引导镜像 (Shrink boot.wim)",
            en: "Rebuild Smaller Stock Boot Image (Shrink boot.wim)",
            fr: "Reconstruire une image boot.wim plus compacte",
            es: "Reconstruir imagen de arranque boot.wim reducida",
            ru: "Пересобрать уменьшенный загрузочный образ (Shrink boot.wim)",
            ar: "إعادة بناء صورة الإقلاع بحجم أصغر (Shrink boot.wim)"
        )
    }

    static func shrinkBootImageSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "仅导出 boot.wim 中的 Windows Setup 引导卷并执行 LZX 最大压缩，完整保留图形安装界面与原生存储驱动。",
            en: "Rebuilds boot.wim as a single maximum-compressed bootable Setup index while retaining the GUI installer and native drivers.",
            fr: "Reconstruit boot.wim en un seul index Setup amorçable à compression maximale tout en conservant l’interface et les pilotes.",
            es: "Reconstruye boot.wim como un único índice Setup arrancable con compresión máxima manteniendo interfaz y controladores.",
            ru: "Пересобирает boot.wim с одним загрузочным индексом Setup и максимальным сжатием LZX, сохраняя GUI и драйверы.",
            ar: "يعيد بناء boot.wim كفهرس إعداد واحد قابل للإقلاع بأقصى ضغط مع الحفاظ على الواجهة الرسومية والتعريفات."
        )
    }

    static func isoSizeLimitBoxTitle(_ limitFormatted: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "配方体积预算上限：\(limitFormatted)",
            en: "Recipe ISO Size Budget: \(limitFormatted)",
            fr: "Budget de taille ISO de la recette : \(limitFormatted)",
            es: "Límite de tamaño ISO de la receta: \(limitFormatted)",
            ru: "Лимит размера ISO из рецепта: \(limitFormatted)",
            ar: "حد حجم ملف ISO في الوصفة: \(limitFormatted)"
        )
    }

    static func isoSizeLimitSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "当前导入的配方设定了成品 ISO 字节上限（如 CD 700MB 极限配方）。若无需严格限制体积，可点击右侧移除。",
            en: "The imported recipe enforces a strict maximum byte budget on the output ISO. Click Remove Limit if you do not need this constraint.",
            fr: "La recette importée impose une taille maximale stricte pour l’ISO final. Cliquez à droite pour lever cette limite.",
            es: "La receta importada impone un tamaño máximo estricto al ISO final. Haz clic a la derecha para quitar este límite.",
            ru: "Импортированный рецепт задаёт строгий лимит размера выходного ISO. Нажмите кнопку справа, чтобы снять ограничение.",
            ar: "تفرض الوصفة المستوردة حدًا أقصى صارمًا لحجم ملف ISO الناتج. انقر لإزالة هذا القيد إذا لم تكن بحاجة إليه."
        )
    }

    static func clearLimitButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "移除体积限制",
            en: "Remove Limit",
            fr: "Retirer la limite",
            es: "Quitar límite",
            ru: "Снять лимит",
            ar: "إزالة الحد"
        )
    }

    static func reviewShrinkBootLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "精简 boot.wim",
            en: "Shrink boot.wim",
            fr: "Réduire boot.wim",
            es: "Reducir boot.wim",
            ru: "Сжатие boot.wim",
            ar: "تقليص boot.wim"
        )
    }

    static func reviewIsoLimitLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "体积预算上限",
            en: "ISO Size Limit",
            fr: "Limite taille ISO",
            es: "Límite tamaño ISO",
            ru: "Лимит размера ISO",
            ar: "حد حجم ISO"
        )
    }

    static func workspacePlaceholder(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "工作缓存目录", en: "Workspace directory", fr: "Dossier de travail", es: "Directorio de trabajo", ru: "Рабочий каталог", ar: "مجلد العمل المؤقت")
    }

    static func selectFolderButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "选择目录...", en: "Choose Folder...", fr: "Choisir un dossier...", es: "Elegir carpeta...", ru: "Выбрать папку...", ar: "اختيار مجلد...")
    }

    // MARK: - Step 5: Review

    static func reviewViewTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "复核构建方案",
            en: "Review Build Plan",
            fr: "Vérifier le plan de création",
            es: "Revisar plan de compilación",
            ru: "Проверка плана сборки",
            ar: "مراجعة خطة البناء"
        )
    }

    static func reviewViewSubtitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "确认以下配置无误后，点击右下角「开始制作精简版 ISO」启动原生流水线。",
            en: "Confirm your settings below, then click \"Build Slimmed ISO\" to launch the native imaging pipeline.",
            fr: "Vérifiez la configuration ci-dessous puis cliquez sur « Créer l’ISO allégé » pour lancer le pipeline natif.",
            es: "Confirma la configuración siguiente y haz clic en «Crear ISO optimizado» para iniciar el proceso nativo.",
            ru: "Проверьте параметры ниже и нажмите «Создать облегчённый ISO» для запуска нативного конвейера.",
            ar: "تأكد من صحة الإعدادات أدناه ثم انقر على «بدء إنشاء ملف ISO المخفّف» لبدء المعالجة الأصلية."
        )
    }

    static func reviewTargetCardTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "目标系统版本", en: "Target Windows Edition", fr: "Édition Windows cible", es: "Edición de destino", ru: "Целевая система", ar: "نسخة النظام المستهدفة")
    }

    static func reviewOsNameLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "系统名称", en: "Edition", fr: "Édition", es: "Edición", ru: "Название ОС", ar: "اسم النظام")
    }

    static func reviewArchLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "处理器架构", en: "Architecture", fr: "Architecture", es: "Arquitectura", ru: "Архитектура", ar: "معمارية المعالج")
    }

    static func reviewVersionLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "版本号", en: "Version", fr: "Version", es: "Versión", ru: "Версия", ar: "رقم الإصدار")
    }

    static func reviewLanguageLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "镜像语言", en: "ISO Languages", fr: "Langues de l’ISO", es: "Idiomas del ISO", ru: "Языки образа", ar: "لغات الصورة")
    }

    static func reviewDefaultLanguage(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "默认", en: "Default", fr: "Par défaut", es: "Predeterminado", ru: "По умолчанию", ar: "افتراضي")
    }

    static func reviewNoSourceSelected(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "尚未选择有效的源镜像",
            en: "No valid source image selected",
            fr: "Aucune image source valide sélectionnée",
            es: "No se ha seleccionado una imagen válida",
            ru: "Не выбран корректный исходный образ",
            ar: "لم يتم اختيار صورة مصدر صالحة بعد"
        )
    }

    static func reviewCleanupCardTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "精简策略概览", en: "Slimming Summary", fr: "Résumé de l’allègement", es: "Resumen de recorte", ru: "Сводка очистки", ar: "ملخص استراتيجية التخفيف")
    }

    static func reviewModeLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "当前模式", en: "Build Mode", fr: "Mode choisi", es: "Modo actual", ru: "Режим сборки", ar: "الوضع الحالي")
    }

    static func reviewEnabledRulesLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "启用规则数", en: "Active Rules", fr: "Règles actives", es: "Reglas activas", ru: "Активных правил", ar: "القواعد المفعّلة")
    }

    static func reviewEnabledRulesValue(_ count: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "\(count) 项", en: "\(count) rules", fr: "\(count) règles", es: "\(count) reglas", ru: "\(count) шт.", ar: "\(count) عنصر")
    }

    static func reviewEdgeLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "Microsoft Edge", en: "Microsoft Edge", fr: "Microsoft Edge", es: "Microsoft Edge", ru: "Microsoft Edge", ar: "Microsoft Edge")
    }

    static func reviewEdgeValue(removeEdgeFiles: Bool, suppressEdgePromos: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if removeEdgeFiles {
            return tr(
                lang: lang,
                zh: "彻底移除 (含 WebView2)",
                en: "Removed (with WebView2)",
                fr: "Supprimé (avec WebView2)",
                es: "Eliminado (con WebView2)",
                ru: "Удалён (вместе с WebView2)",
                ar: "إزالة كاملة (مع WebView2)"
            )
        }
        if suppressEdgePromos {
            return tr(
                lang: lang,
                zh: "保留（净化推广弹窗）",
                en: "Kept (promos suppressed)",
                fr: "Conservé (pubs masquées)",
                es: "Conservado (sin anuncios)",
                ru: "Сохранён (без рекламы)",
                ar: "مُحتفظ به (مع إخفاء الترويج)"
            )
        }
        return tr(
            lang: lang,
            zh: "完整保留",
            en: "Kept (untouched)",
            fr: "Conservé tel quel",
            es: "Conservado intacto",
            ru: "Полностью сохранён",
            ar: "مُحتفظ به بالكامل"
        )
    }

    static func reviewCoreLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "Core 组件库裁剪", en: "Core Store Prune", fr: "Élagage Core", es: "Recorte Core", ru: "Очистка Core", ar: "تقليص مخزن Core")
    }

    static func reviewCoreValue(_ enabled: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if enabled {
            return tr(
                lang: lang,
                zh: "开启（不可更新系统）",
                en: "Enabled (non-serviceable)",
                fr: "Activé (sans mises à jour)",
                es: "Activado (sin actualizaciones)",
                ru: "Включено (без обновлений)",
                ar: "مفعّل (لا يقبل التحديثات)"
            )
        }
        return tr(
            lang: lang,
            zh: "关闭（保留更新与 Guest Tools 兼容）",
            en: "Off (updates & Guest Tools kept)",
            fr: "Désactivé (mises à jour et Guest Tools gardés)",
            es: "Desactivado (mantiene updates y Guest Tools)",
            ru: "Выключено (обновления и Guest Tools сохранены)",
            ar: "متوقف (يحفظ التحديثات وأدوات الضيف)"
        )
    }

    static func reviewHardwareBypassLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "硬件限制绕过", en: "Hardware Bypass", fr: "Contournement TPM", es: "Omisión hardware", ru: "Обход проверок", ar: "تجاوز قيود العتاد")
    }

    static func reviewHardwareBypassValue(_ enabled: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if enabled {
            return tr(
                lang: lang,
                zh: "已启用 (TPM/RAM/CPU)",
                en: "Enabled (TPM/RAM/CPU)",
                fr: "Activé (TPM/RAM/CPU)",
                es: "Activado (TPM/RAM/CPU)",
                ru: "Включён (TPM/ОЗУ/ЦП)",
                ar: "مفعّل (TPM/RAM/CPU)"
            )
        }
        return tr(lang: lang, zh: "未启用", en: "Disabled", fr: "Désactivé", es: "Desactivado", ru: "Выключен", ar: "غير مفعّل")
    }

    static func reviewInstallCardTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "安装与压缩参数", en: "Setup & Compression", fr: "Installation et compression", es: "Instalación y compresión", ru: "Установка и сжатие", ar: "معاملات التثبيت والضغط")
    }

    static func reviewCompressionLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "压缩等级", en: "Compression", fr: "Compression", es: "Compresión", ru: "Сжатие", ar: "مستوى الضغط")
    }

    static func reviewLocalAccountLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "本地账户直通", en: "Offline Account", fr: "Compte local", es: "Cuenta local", ru: "Локальный вход", ar: "الحساب المحلي")
    }

    static func reviewLocalAccountValue(_ enabled: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if enabled {
            return tr(
                lang: lang,
                zh: "开启 (BypassNRO + 隐藏联网页)",
                en: "On (BypassNRO + hide online screen)",
                fr: "Activé (BypassNRO + hors ligne)",
                es: "Activado (BypassNRO + sin red)",
                ru: "Вкл. (BypassNRO + без сети)",
                ar: "مفعّل (BypassNRO + إخفاء الاتصال)"
            )
        }
        return tr(lang: lang, zh: "关闭", en: "Off", fr: "Désactivé", es: "Desactivado", ru: "Выкл.", ar: "متوقف")
    }

    static func reviewCompactOsLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "CompactOS 部署", en: "CompactOS", fr: "CompactOS", es: "CompactOS", ru: "CompactOS", ar: "نشر CompactOS")
    }

    static func reviewOnOffValue(_ enabled: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        enabled
            ? tr(lang: lang, zh: "开启", en: "On", fr: "Activé", es: "Activado", ru: "Вкл.", ar: "مفعّل")
            : tr(lang: lang, zh: "关闭", en: "Off", fr: "Désactivé", es: "Desactivado", ru: "Выкл.", ar: "متوقف")
    }

    static func reviewNetFx3Label(lang: AppLanguage = L10n.currentLanguage) -> String {
        ".NET Framework 3.5"
    }

    static func reviewNetFx3Value(enable: Bool, omitPayload: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if enable {
            return tr(
                lang: lang,
                zh: "自动离线启用",
                en: "Auto-enable offline",
                fr: "Activation hors ligne auto",
                es: "Activar sin conexión",
                ru: "Включить офлайн",
                ar: "تفعيل تلقائي دون اتصال"
            )
        }
        if omitPayload {
            return tr(
                lang: lang,
                zh: "不启用且省略载荷",
                en: "Disabled & payload omitted",
                fr: "Désactivé et dossier omis",
                es: "Desactivado y carga omitida",
                ru: "Выкл., пакеты исключены",
                ar: "غير مفعّل مع استبعاد الحزمة"
            )
        }
        return tr(
            lang: lang,
            zh: "按默认保留载荷",
            en: "Keep payload (not enabled)",
            fr: "Conserver le dossier par défaut",
            es: "Conservar carga por defecto",
            ru: "Сохранить пакеты по умолчанию",
            ar: "الاحتفاظ بالحزمة افتراضيًا"
        )
    }

    static func reviewPathsCardTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "输入与输出位置", en: "Input & Output Paths", fr: "Entrée et sortie", es: "Ubicaciones de E/S", ru: "Пути ввода и вывода", ar: "مواقع الإدخال والإخراج")
    }

    static func reviewSourceLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "源镜像", en: "Source Media", fr: "Média source", es: "Origen", ru: "Исходник", ar: "صورة المصدر")
    }

    static func reviewOutputLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "输出文件", en: "Output ISO", fr: "Fichier ISO", es: "Archivo ISO", ru: "Выходной ISO", ar: "ملف الإخراج")
    }

    static func reviewWorkspaceLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "工作缓存", en: "Workspace", fr: "Cache travail", es: "Caché trabajo", ru: "Рабочий кэш", ar: "مجلد العمل")
    }

    static func reviewToolsLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "工具引擎", en: "Native Engine", fr: "Moteur natif", es: "Motor nativo", ru: "Движок", ar: "محرك الأدوات")
    }

    static func reviewToolsValue(_ ready: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        ready
            ? tr(lang: lang, zh: "就绪", en: "Ready", fr: "Prêt", es: "Listo", ru: "Готов", ar: "جاهز")
            : tr(lang: lang, zh: "缺失工具", en: "Missing tools", fr: "Outils manquants", es: "Faltan herramientas", ru: "Нет утилит", ar: "أدوات مفقودة")
    }

    static func reviewCoreWarningBanner(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "注意：当前已开启 Tiny11 Core 极限裁剪。生成的系统不支持安装累计更新、安全补丁或额外语言包，建议仅在隔离的测试虚拟机中使用。",
            en: "Note: Tiny11 Core extreme pruning is active. The resulting OS cannot install cumulative updates, security patches, or extra language packs—recommended only for isolated test VMs.",
            fr: "Attention : l’allègement extrême Tiny11 Core est activé. Le système généré ne pourra installer ni mises à jour de sécurité ni packs de langue — à réserver aux VM de test isolées.",
            es: "Aviso: el recorte extremo Tiny11 Core está activo. El sistema resultante no admite parches de seguridad ni paquetes de idioma; úsalo solo en VMs de prueba aisladas.",
            ru: "Внимание: включён режим Tiny11 Core. Готовая система не поддерживает установку обновлений безопасности и языковых пакетов — используйте только в тестовых ВМ.",
            ar: "تنبيه: وضع Tiny11 Core مفعّل حاليًا. النظام الناتج لا يدعم تثبيت التحديثات الأمنية أو حزم اللغات الإضافية؛ يُنصح باستخدامه في أجهزة افتراضية معزولة للاختبار فقط."
        )
    }

    // MARK: - Step 6: Build Progress & Results

    static func buildHeaderTitle(isBuilding: Bool, cancelRequested: Bool, hasResult: Bool, hasError: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if isBuilding {
            if cancelRequested {
                return tr(
                    lang: lang,
                    zh: "正在安全停止操作...",
                    en: "Safely Stopping Build...",
                    fr: "Arrêt sécurisé en cours...",
                    es: "Deteniendo operación de forma segura...",
                    ru: "Безопасная остановка сборки...",
                    ar: "جارٍ إيقاف العملية بأمان..."
                )
            }
            return tr(
                lang: lang,
                zh: "正在构建精简版 Windows 11 ISO...",
                en: "Building Slimmed Windows 11 ISO...",
                fr: "Création de l’ISO Windows 11 allégé en cours...",
                es: "Compilando ISO optimizado de Windows 11...",
                ru: "Сборка облегчённого образа Windows 11 ISO...",
                ar: "جارٍ بناء ملف ISO المخفّف لنظام Windows 11..."
            )
        }
        if hasResult {
            return tr(lang: lang, zh: "构建成功", en: "Build Complete", fr: "Création réussie", es: "Compilación exitosa", ru: "Сборка завершена", ar: "اكتمل البناء بنجاح")
        }
        if hasError {
            return tr(lang: lang, zh: "构建已停止", en: "Build Stopped", fr: "Création interrompue", es: "Compilación detenida", ru: "Сборка остановлена", ar: "توقف البناء")
        }
        return tr(lang: lang, zh: "准备就绪", en: "Ready", fr: "Prêt", es: "Listo", ru: "Готово", ar: "جاهز للبدء")
    }

    static func buildSubtitleSucceeded(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "可直接挂载至 Parallels Desktop、VMware Fusion、UTM 或刻录装机。",
            en: "Ready to mount in Parallels Desktop, VMware Fusion, UTM, or flash to USB installation media.",
            fr: "Prêt à être monté dans Parallels Desktop, VMware Fusion, UTM ou gravé sur clé USB.",
            es: "Listo para montar en Parallels Desktop, VMware Fusion, UTM o grabar en un medio USB.",
            ru: "Готов к подключению в Parallels Desktop, VMware Fusion, UTM или записи на USB-носитель.",
            ar: "جاهز للتركيب مباشرةً في Parallels Desktop أو VMware Fusion أو UTM أو حرقه على ذاكرة USB."
        )
    }

    static func buildSubtitleReadOnly(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "源安装介质全程只读保护。",
            en: "Source installation media remains strictly read-only throughout.",
            fr: "Le média d’installation source reste protégé en lecture seule.",
            es: "El medio de instalación de origen permanece protegido en solo lectura.",
            ru: "Исходный установочный носитель полностью защищён в режиме чтения.",
            ar: "وسيط التثبيت الأصلي محمي بالكامل بوضع القراءة فقط."
        )
    }

    static func cancelBuildButton(cancelRequested: Bool, lang: AppLanguage = L10n.currentLanguage) -> String {
        if cancelRequested {
            return tr(lang: lang, zh: "正在取消...", en: "Cancelling...", fr: "Annulation...", es: "Cancelando...", ru: "Отмена...", ar: "جارٍ الإلغاء...")
        }
        return tr(lang: lang, zh: "安全取消", en: "Safe Cancel", fr: "Annulation sécurisée", es: "Cancelación segura", ru: "Безопасная отмена", ar: "إلغاء آمن")
    }

    static func buildCompleteBannerTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "精简版 Windows 11 ISO 构建完成！",
            en: "Slimmed Windows 11 ISO Built Successfully!",
            fr: "ISO Windows 11 allégé créé avec succès !",
            es: "¡ISO optimizado de Windows 11 creado con éxito!",
            ru: "Облегчённый образ Windows 11 ISO готов!",
            ar: "اكتمل بناء ملف ISO المخفّف لنظام Windows 11!"
        )
    }

    static func revealInFinderButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "在 Finder 中显示 ISO",
            en: "Show ISO in Finder",
            fr: "Afficher l’ISO dans le Finder",
            es: "Mostrar ISO en el Finder",
            ru: "Показать ISO в Finder",
            ar: "إظهار ملف ISO في Finder"
        )
    }

    static func statOutputSizeLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "输出镜像体积", en: "Output ISO Size", fr: "Taille de l’ISO", es: "Tamaño de salida", ru: "Размер выходного ISO", ar: "حجم ملف ISO الناتج")
    }

    static func statSavedVsSourceLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "相比原盘缩减", en: "Saved vs. Source", fr: "Gain sur l’original", es: "Ahorro frente al original", ru: "Сэкономлено от исходника", ar: "التوفير مقارنةً بالأصل")
    }

    static func statRemovedAndLockedLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "移除条目 / 锁定应用",
            en: "Removed Paths / Locked Apps",
            fr: "Éléments retirés / Apps bloquées",
            es: "Rutas quitadas / Apps bloqueadas",
            ru: "Удалено путей / Заблокировано",
            ar: "العناصر المزالة / التطبيقات المقفلة"
        )
    }

    static func statRemovedAndLockedValue(removed: Int, locked: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "\(removed) 处 / \(locked) 款",
            en: "\(removed) / \(locked) apps",
            fr: "\(removed) / \(locked) apps",
            es: "\(removed) / \(locked) apps",
            ru: "\(removed) / \(locked) прил.",
            ar: "\(removed) مسار / \(locked) تطبيق"
        )
    }

    static func statDurationLabel(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "总耗时", en: "Elapsed Time", fr: "Durée totale", es: "Tiempo total", ru: "Затрачено времени", ar: "الوقت المستغرق")
    }

    static func statDurationValue(_ seconds: Double, lang: AppLanguage = L10n.currentLanguage) -> String {
        let formatted = String(format: "%.1f", seconds)
        return tr(
            lang: lang,
            zh: "\(formatted) 秒",
            en: "\(formatted) s",
            fr: "\(formatted) s",
            es: "\(formatted) s",
            ru: "\(formatted) сек",
            ar: "\(formatted) ثانية"
        )
    }

    static func copyChecksumButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "复制校验和", en: "Copy SHA-256", fr: "Copier SHA-256", es: "Copiar SHA-256", ru: "Копировать SHA-256", ar: "نسخ SHA-256")
    }

    static func openLogDirButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "打开日志目录", en: "Open Log Folder", fr: "Ouvrir le dossier des journaux", es: "Abrir carpeta de registros", ru: "Открыть папку логов", ar: "فتح مجلد السجلات")
    }

    static func buildFailedTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "构建未能完成", en: "Build Failed", fr: "Échec de la création", es: "No se pudo completar", ru: "Сборка не завершена", ar: "تعذّر إكمال البناء")
    }

    static func editSettingsRetryButton(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "修改设置重试", en: "Review & Retry", fr: "Modifier et réessayer", es: "Revisar y reintentar", ru: "Изменить и повторить", ar: "تعديل الإعدادات وإعادة المحاولة")
    }

    static func pipelineStagesBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "构建流水线阶段", en: "Pipeline Stages", fr: "Étapes du pipeline", es: "Fases del proceso", ru: "Этапы конвейера сборки", ar: "مراحل خط المعالجة")
    }

    static func liveEngineLogBoxTitle(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(lang: lang, zh: "实时引擎日志", en: "Live Engine Log", fr: "Journal du moteur en direct", es: "Registro en vivo del motor", ru: "Журнал движка в реальном времени", ar: "سجل المحرك المباشر")
    }
}
