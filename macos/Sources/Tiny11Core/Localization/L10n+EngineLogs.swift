import Foundation

public extension L10n {
    // MARK: - OfflineHiveEditor Errors & Logs

    static func hiveOpenFailed(fileName: String, message: String, code: Int32, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法打开离线注册表文件 \(fileName): \(message) (errno=\(code))",
            en: "Failed to open offline registry file \(fileName): \(message) (errno=\(code))",
            fr: "Impossible d’ouvrir la ruche de registre \(fileName) : \(message) (errno=\(code))",
            es: "No se pudo abrir el archivo de registro \(fileName): \(message) (errno=\(code))",
            ru: "Не удалось открыть файл куста реестра \(fileName): \(message) (errno=\(code))",
            ar: "تعذّر فتح ملف السجل دون اتصال \(fileName): \(message) (errno=\(code))"
        )
    }

    static func hiveSessionClosed(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "注册表会话已关闭。",
            en: "Registry hive session is already closed.",
            fr: "La session du registre est déjà fermée.",
            es: "La sesión del registro ya está cerrada.",
            ru: "Сеанс работы с кустом реестра уже закрыт.",
            ar: "تم إغلاق جلسة السجل بالفعل."
        )
    }

    static func hiveRootNotFound(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法定位注册表根节点：\(path)",
            en: "Unable to locate registry root node: \(path)",
            fr: "Impossible de localiser le nœud racine du registre : \(path)",
            es: "No se pudo localizar el nodo raíz del registro: \(path)",
            ru: "Не удалось найти корневой узел реестра: \(path)",
            ar: "تعذّر تحديد العقدة الجذرية للسجل: \(path)"
        )
    }

    static func hiveFindKeyFailed(keyPath: String, message: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "查找注册表键 \(keyPath) 出错：\(message)",
            en: "Error looking up registry key \(keyPath): \(message)",
            fr: "Erreur lors de la recherche de la clé \(keyPath) : \(message)",
            es: "Error al buscar la clave de registro \(keyPath): \(message)",
            ru: "Ошибка поиска ключа реестра \(keyPath): \(message)",
            ar: "حدث خطأ أثناء البحث عن مفتاح السجل \(keyPath): \(message)"
        )
    }

    static func hiveCreateSubkeyFailed(part: String, keyPath: String, message: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "创建注册表子键 '\(part)' (\(keyPath)) 失败：\(message)",
            en: "Failed to create registry subkey '\(part)' (\(keyPath)): \(message)",
            fr: "Échec de la création de la sous-clé '\(part)' (\(keyPath)) : \(message)",
            es: "Error al crear la subclave '\(part)' (\(keyPath)): \(message)",
            ru: "Не удалось создать подключ реестра '\(part)' (\(keyPath)): \(message)",
            ar: "فشل إنشاء المفتاح الفرعي '\(part)' (\(keyPath)): \(message)"
        )
    }

    static func hiveReadChildrenFailed(_ message: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "读取注册表子键列表失败：\(message)",
            en: "Failed to read registry subkey list: \(message)",
            fr: "Échec de la lecture de la liste des sous-clés : \(message)",
            es: "Error al leer la lista de subclaves del registro: \(message)",
            ru: "Не удалось прочитать список подключей реестра: \(message)",
            ar: "فشلت قراءة قائمة المفاتيح الفرعية للسجل: \(message)"
        )
    }

    static func hiveDeleteNodeFailed(description: String, message: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "删除注册表节点 \(description) 失败：\(message)",
            en: "Failed to delete registry node \(description): \(message)",
            fr: "Échec de la suppression du nœud \(description) : \(message)",
            es: "Error al eliminar el nodo de registro \(description): \(message)",
            ru: "Не удалось удалить узел реестра \(description): \(message)",
            ar: "فشل حذف عقدة السجل \(description): \(message)"
        )
    }

    static func hiveReadbackFailed(contextPath: String, name: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "注册表回读校验失败：\(contextPath)\\\(name)",
            en: "Registry read-back verification failed: \(contextPath)\\\(name)",
            fr: "Échec de la vérification par relecture du registre : \(contextPath)\\\(name)",
            es: "Falló la verificación de lectura del registro: \(contextPath)\\\(name)",
            ru: "Ошибка проверки записи в реестр: \(contextPath)\\\(name)",
            ar: "فشل التحقق من إعادة قراءة قيمة السجل: \(contextPath)\\\(name)"
        )
    }

    static func hiveMemoryAllocFailed(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "内存分配失败",
            en: "Memory allocation failed",
            fr: "Échec d’allocation mémoire",
            es: "Error de asignación de memoria",
            ru: "Ошибка выделения памяти",
            ar: "فشل تخصيص الذاكرة"
        )
    }

    static func hiveWriteValueFailed(contextPath: String, name: String, message: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "写入注册表值 \(contextPath)\\\(name) 失败：\(message)",
            en: "Failed to write registry value \(contextPath)\\\(name): \(message)",
            fr: "Échec de l’écriture de la valeur \(contextPath)\\\(name) : \(message)",
            es: "Error al escribir el valor de registro \(contextPath)\\\(name): \(message)",
            ru: "Не удалось записать значение реестра \(contextPath)\\\(name): \(message)",
            ar: "فشلت كتابة قيمة السجل \(contextPath)\\\(name): \(message)"
        )
    }

    static func hiveCommitFailed(fileName: String, message: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "提交注册表修改至 \(fileName) 失败：\(message)",
            en: "Failed to commit registry changes to \(fileName): \(message)",
            fr: "Échec de l’enregistrement des modifications dans \(fileName) : \(message)",
            es: "Error al guardar los cambios del registro en \(fileName): \(message)",
            ru: "Не удалось сохранить изменения реестра в \(fileName): \(message)",
            ar: "فشل حفظ تعديلات السجل في \(fileName): \(message)"
        )
    }

    static func winpeshlEncodeFailed(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "无法编码 winpeshl.ini。",
            en: "Failed to encode winpeshl.ini.",
            fr: "Impossible d’encoder winpeshl.ini.",
            es: "No se pudo codificar winpeshl.ini.",
            ru: "Не удалось закодировать winpeshl.ini.",
            ar: "تعذّر ترميز ملف winpeshl.ini."
        )
    }

    // MARK: - Engine Live Log Lines

    static func logJobStarted(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Tiny11 Builder for Mac · 任务启动: \(path)",
            en: "Tiny11 Builder for Mac · Job started: \(path)",
            fr: "Tiny11 Builder for Mac · Tâche démarrée : \(path)",
            es: "Tiny11 Builder for Mac · Tarea iniciada: \(path)",
            ru: "Tiny11 Builder for Mac · Задача запущена: \(path)",
            ar: "Tiny11 Builder for Mac · بدء المهمة: \(path)"
        )
    }

    static func logToolchainMode(bundled: Bool, wimlib: String, mkisofs: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        let modeDesc = tr(
            lang: lang,
            zh: bundled ? "App 内嵌独立工具" : "开发环境工具",
            en: bundled ? "Bundled tools" : "Dev environment tools",
            fr: bundled ? "Outils intégrés" : "Outils de développement",
            es: bundled ? "Herramientas integradas" : "Herramientas de desarrollo",
            ru: bundled ? "Встроенные утилиты" : "Утилиты окружения разработки",
            ar: bundled ? "أدوات مدمجة بالتطبيق" : "أدوات بيئة التطوير"
        )
        return tr(
            lang: lang,
            zh: "工具链模式: \(modeDesc) | wimlib=\(wimlib) | mkisofs=\(mkisofs)",
            en: "Toolchain: \(modeDesc) | wimlib=\(wimlib) | mkisofs=\(mkisofs)",
            fr: "Chaîne d’outils : \(modeDesc) | wimlib=\(wimlib) | mkisofs=\(mkisofs)",
            es: "Cadena de herramientas: \(modeDesc) | wimlib=\(wimlib) | mkisofs=\(mkisofs)",
            ru: "Инструменты: \(modeDesc) | wimlib=\(wimlib) | mkisofs=\(mkisofs)",
            ar: "الأدوات: \(modeDesc) | wimlib=\(wimlib) | mkisofs=\(mkisofs)"
        )
    }

    static func logTargetEdition(_ summary: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "目标版本: \(summary)",
            en: "Target edition: \(summary)",
            fr: "Édition cible : \(summary)",
            es: "Edición de destino: \(summary)",
            ru: "Целевая редакция: \(summary)",
            ar: "النسخة المستهدفة: \(summary)"
        )
    }

    static func logMediaStagedProgress(current: Int, total: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已暂存安装介质文件 \(current) / \(total)",
            en: "Staged setup media files \(current) / \(total)",
            fr: "Fichiers du média préparés : \(current) / \(total)",
            es: "Archivos del medio preparados: \(current) / \(total)",
            ru: "Подготовлено файлов носителя: \(current) / \(total)",
            ar: "تم تجهيز ملفات وسيط التثبيت \(current) / \(total)"
        )
    }

    static func logOmittedNetFx3Payload(count: Int, mib: Int64, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已按设置省略 sources/sxs (.NET 3.5 安装载荷)：共 \(count) 个文件，节省 \(mib) MiB",
            en: "Omitted sources/sxs (.NET 3.5 payload): \(count) files, saved \(mib) MiB",
            fr: "Dossier sources/sxs (.NET 3.5) omis : \(count) fichiers, \(mib) Mio économisés",
            es: "Omitido sources/sxs (carga .NET 3.5): \(count) archivos, \(mib) MiB ahorrados",
            ru: "Пропущен каталог sources/sxs (.NET 3.5): файлов \(count), сэкономлено \(mib) МиБ",
            ar: "تم استبعاد sources/sxs (حزمة .NET 3.5): \(count) ملف، تم توفير \(mib) ميغابايت"
        )
    }

    static func logScheduledAppDelete(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "计划移除预装应用载荷: \(path)",
            en: "Scheduled bundled app removal: \(path)",
            fr: "Suppression prévue de l’application : \(path)",
            es: "Programada eliminación de app preinstalada: \(path)",
            ru: "Запланировано удаление пакета приложения: \(path)",
            ar: "جدولة إزالة حزمة التطبيق المدمج: \(path)"
        )
    }

    static func logScheduledOneDriveDelete(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "计划移除 OneDrive 安装器: \(path)",
            en: "Scheduled OneDrive setup removal: \(path)",
            fr: "Suppression prévue de l’installateur OneDrive : \(path)",
            es: "Programada eliminación del instalador OneDrive: \(path)",
            ru: "Запланировано удаление установщика OneDrive: \(path)",
            ar: "جدولة إزالة مثبت OneDrive: \(path)"
        )
    }

    static func logWarning(_ warn: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "警告: \(warn)",
            en: "Warning: \(warn)",
            fr: "Avertissement : \(warn)",
            es: "Advertencia: \(warn)",
            ru: "Предупреждение: \(warn)",
            ar: "تحذير: \(warn)"
        )
    }

    static func logScheduledEdgeDelete(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "计划移除 Edge 目录: \(path)",
            en: "Scheduled Edge directory removal: \(path)",
            fr: "Suppression prévue du dossier Edge : \(path)",
            es: "Programada eliminación del directorio Edge: \(path)",
            ru: "Запланировано удаление каталога Edge: \(path)",
            ar: "جدولة إزالة مجلد Edge: \(path)"
        )
    }

    static func logCorePrunedWinSxS(_ count: Int, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Core: 计划裁剪 WinSxS 非核心组件目录 \(count) 个",
            en: "Core: scheduled pruning of \(count) non-essential WinSxS directories",
            fr: "Core : suppression prévue de \(count) dossiers WinSxS non essentiels",
            es: "Core: programado recorte de \(count) directorios no esenciales de WinSxS",
            ru: "Core: запланирована очистка \(count) неосновных каталогов WinSxS",
            ar: "Core: جدولة تقليص \(count) من مجلدات WinSxS غير الأساسية"
        )
    }

    static func logCoreScheduledWinREDelete(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Core: 计划移除恢复镜像 \(path)",
            en: "Core: scheduled WinRE recovery image removal: \(path)",
            fr: "Core : suppression prévue de l’image de récupération \(path)",
            es: "Core: programada eliminación de imagen de recuperación \(path)",
            ru: "Core: запланировано удаление образа восстановления \(path)",
            ar: "Core: جدولة إزالة صورة الاسترداد \(path)"
        )
    }

    static func logPolicyWritten(hive: String, key: String, name: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已写入策略: [\(hive)] \(key)\\\(name)",
            en: "Applied policy: [\(hive)] \(key)\\\(name)",
            fr: "Stratégie écrite : [\(hive)] \(key)\\\(name)",
            es: "Directiva escrita: [\(hive)] \(key)\\\(name)",
            ru: "Записана политика: [\(hive)] \(key)\\\(name)",
            ar: "تم تطبيق السياسة: [\(hive)] \(key)\\\(name)"
        )
    }

    static func logBypassNROEnabled(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已启用 OOBE 本地账户直通 (BypassNRO=1)",
            en: "Enabled offline local account OOBE bypass (BypassNRO=1)",
            fr: "Contournement de compte local OOBE activé (BypassNRO=1)",
            es: "Activado acceso directo a cuenta local en OOBE (BypassNRO=1)",
            ru: "Включён обход сетевой учётной записи OOBE (BypassNRO=1)",
            ar: "تم تفعيل الحساب المحلي دون إنترنت في OOBE ‏(BypassNRO=1)"
        )
    }

    static func logRemovedStagedEntry(subStore: String, pkgKeyName: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已清理离线预装包注册项: \(subStore)\\\(pkgKeyName)",
            en: "Removed offline provisioned package entry: \(subStore)\\\(pkgKeyName)",
            fr: "Entrée de paquet préinstallé supprimée : \(subStore)\\\(pkgKeyName)",
            es: "Entrada de paquete preinstalado eliminada: \(subStore)\\\(pkgKeyName)",
            ru: "Удалена запись предустановленного пакета: \(subStore)\\\(pkgKeyName)",
            ar: "تمت إزالة سجل الحزمة المثبتة مسبقًا: \(subStore)\\\(pkgKeyName)"
        )
    }

    static func logLockedDeprovisioned(_ family: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已锁定预装应用防重装标记: Deprovisioned\\\(family)",
            en: "Locked deprovisioned app family: Deprovisioned\\\(family)",
            fr: "Famille d’application verrouillée : Deprovisioned\\\(family)",
            es: "Familia de app bloqueada contra reinstalación: Deprovisioned\\\(family)",
            ru: "Установлена блокировка переустановки: Deprovisioned\\\(family)",
            ar: "تم قفل إعادة تثبيت التطبيق: Deprovisioned\\\(family)"
        )
    }

    static func logRemovedEdgeUninstall(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已移除离线 Edge 卸载残留项: \(path)\\Microsoft Edge",
            en: "Removed offline Edge uninstall entry: \(path)\\Microsoft Edge",
            fr: "Entrée de désinstallation Edge hors ligne supprimée : \(path)\\Microsoft Edge",
            es: "Eliminada entrada de desinstalación de Edge: \(path)\\Microsoft Edge",
            ru: "Удалена запись деинсталляции Edge: \(path)\\Microsoft Edge",
            ar: "تمت إزالة مدخل إلغاء تثبيت Edge: \(path)\\Microsoft Edge"
        )
    }

    static func logCoreDisabledService(controlSet: String, service: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Core: 已禁用服务 \(controlSet)\\Services\\\(service)",
            en: "Core: disabled service \(controlSet)\\Services\\\(service)",
            fr: "Core : service désactivé \(controlSet)\\Services\\\(service)",
            es: "Core: servicio desactivado \(controlSet)\\Services\\\(service)",
            ru: "Core: отключена служба \(controlSet)\\Services\\\(service)",
            ar: "Core: تم تعطيل الخدمة \(controlSet)\\Services\\\(service)"
        )
    }

    static func logBootBypassWritten(keyPath: String, name: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已在引导镜像写入硬件绕过策略: \(keyPath)\\\(name)",
            en: "Wrote hardware bypass key in boot image: \(keyPath)\\\(name)",
            fr: "Clé de contournement matériel écrite dans boot.wim : \(keyPath)\\\(name)",
            es: "Clave de omisión de hardware escrita en boot.wim: \(keyPath)\\\(name)",
            ru: "В загрузочный образ записан ключ обхода: \(keyPath)\\\(name)",
            ar: "تمت كتابة مفتاح تجاوز العتاد في صورة الإقلاع: \(keyPath)\\\(name)"
        )
    }

    static func logCoreLegacySetupEnabled(_ legacyExeRel: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "Core: 已在 boot.wim 启用经典安装器 (%SYSTEMDRIVE%\\\(legacyExeRel))",
            en: "Core: enabled legacy Windows Setup in boot.wim (%SYSTEMDRIVE%\\\(legacyExeRel))",
            fr: "Core : installateur classique activé dans boot.wim (%SYSTEMDRIVE%\\\(legacyExeRel))",
            es: "Core: instalador clásico habilitado en boot.wim (%SYSTEMDRIVE%\\\(legacyExeRel))",
            ru: "Core: включён классический установщик в boot.wim (%SYSTEMDRIVE%\\\(legacyExeRel))",
            ar: "Core: تم تفعيل المثبت الكلاسيكي في boot.wim ‏(%SYSTEMDRIVE%\\\(legacyExeRel))"
        )
    }

    static func logSpecializeScriptInjected(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已注入部署期可选功能与预装存根清理脚本: /Windows/Setup/Scripts/Tiny11Specialize.ps1",
            en: "Injected specialize cleanup script: /Windows/Setup/Scripts/Tiny11Specialize.ps1",
            fr: "Script de nettoyage specialize injecté : /Windows/Setup/Scripts/Tiny11Specialize.ps1",
            es: "Inyectado script de limpieza specialize: /Windows/Setup/Scripts/Tiny11Specialize.ps1",
            ru: "Внедрён скрипт очистки этапа specialize: /Windows/Setup/Scripts/Tiny11Specialize.ps1",
            ar: "تم حقن نص التنظيف لمرحلة التخصيص: /Windows/Setup/Scripts/Tiny11Specialize.ps1"
        )
    }

    static func logUnattendWritten(_ arch: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "已写入应答配置文件: autounattend.xml (架构: \(arch))",
            en: "Generated unattended configuration: autounattend.xml (arch: \(arch))",
            fr: "Fichier de réponses généré : autounattend.xml (arch : \(arch))",
            es: "Archivo de respuesta generado: autounattend.xml (arq: \(arch))",
            ru: "Создан файл ответов: autounattend.xml (архитектура: \(arch))",
            ar: "تم إنشاء ملف الإعداد التلقائي: autounattend.xml (المعمارية: \(arch))"
        )
    }

    static func logBuildSuccess(_ path: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "构建成功! 输出镜像: \(path)",
            en: "Build succeeded! Output ISO: \(path)",
            fr: "Création réussie ! ISO de sortie : \(path)",
            es: "¡Compilación completada! ISO de salida: \(path)",
            ru: "Сборка успешно завершена! Выходной ISO: \(path)",
            ar: "اكتمل البناء بنجاح! ملف ISO الناتج: \(path)"
        )
    }

    static func logBuildSizeAndSha(size: String, sha256: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "大小: \(size) | SHA-256: \(sha256)",
            en: "Size: \(size) | SHA-256: \(sha256)",
            fr: "Taille : \(size) | SHA-256 : \(sha256)",
            es: "Tamaño: \(size) | SHA-256: \(sha256)",
            ru: "Размер: \(size) | SHA-256: \(sha256)",
            ar: "الحجم: \(size) | SHA-256: \(sha256)"
        )
    }

    static func logBuildCancelled(lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "构建已由用户取消。",
            en: "Build cancelled by user.",
            fr: "Création annulée par l’utilisateur.",
            es: "Compilación cancelada por el usuario.",
            ru: "Сборка отменена пользователем.",
            ar: "تم إلغاء البناء من قِبل المستخدم."
        )
    }

    static func logBuildFailed(_ err: String, lang: AppLanguage = L10n.currentLanguage) -> String {
        tr(
            lang: lang,
            zh: "构建失败: \(err)",
            en: "Build failed: \(err)",
            fr: "Échec de la création : \(err)",
            es: "Error en la compilación: \(err)",
            ru: "Сбой сборки: \(err)",
            ar: "فشل البناء: \(err)"
        )
    }
}
