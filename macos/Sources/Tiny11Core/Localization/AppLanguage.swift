import Foundation
import CoreFoundation

/// Supported UI and engine languages for Tiny11 Builder for Mac.
/// Follows macOS primary system language; falls back to `.en` for any unsupported language.
public enum AppLanguage: String, CaseIterable, Codable, Sendable, Identifiable {
    case zh = "zh-Hans"
    case zhHant = "zh-Hant"
    case en = "en"
    case fr = "fr"
    case es = "es"
    case ru = "ru"
    case ar = "ar"

    public var id: String { rawValue }

    public var localeIdentifier: String { rawValue }

    public var locale: Locale {
        Locale(identifier: localeIdentifier)
    }

    public var isRTL: Bool {
        self == .ar
    }

    /// Resolves the active language from the system's primary preferred language.
    /// If the primary language is not one of Simplified Chinese, Traditional Chinese, English,
    /// French, Spanish, Russian, or Arabic, always returns `.en` (English).
    public static func resolve(
        preferredLanguages: [String] = Locale.preferredLanguages,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) -> AppLanguage {
        if let envOverride = environment["TINY11_LANG"]?.trimmingCharacters(in: .whitespacesAndNewlines),
           !envOverride.isEmpty {
            return matchPrimaryLanguageTag(envOverride)
        }
        guard let primary = preferredLanguages.first else {
            return .en
        }
        return matchPrimaryLanguageTag(primary)
    }

    public static func matchPrimaryLanguageTag(_ rawTag: String) -> AppLanguage {
        let normalized = rawTag
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "_", with: "-")
        let subtags = normalized.split(separator: "-").map(String.init)
        guard let primarySubtag = subtags.first, !primarySubtag.isEmpty else {
            return .en
        }
        switch primarySubtag {
        case "zh":
            let traditionalMarkers: Set<String> = ["hant", "tw", "hk", "mo", "cht"]
            if subtags.dropFirst().contains(where: { traditionalMarkers.contains($0) }) {
                return .zhHant
            }
            return .zh
        case "cht":
            return .zhHant
        case "chs":
            return .zh
        case "en": return .en
        case "fr": return .fr
        case "es": return .es
        case "ru": return .ru
        case "ar": return .ar
        default: return .en
        }
    }
}

public enum L10n {
    private static let lock = NSLock()
    private static let detectedSystemLanguage: AppLanguage = AppLanguage.resolve()
    nonisolated(unsafe) private static var overrideLanguage: AppLanguage?

    public static var currentLanguage: AppLanguage {
        lock.lock()
        let currentOverride = overrideLanguage
        lock.unlock()
        if let currentOverride {
            return currentOverride
        }
        return detectedSystemLanguage
    }

    /// Executes `body` with a temporary language override (useful for unit tests and previews).
    public static func withLanguage<T>(_ language: AppLanguage?, perform body: () throws -> T) rethrows -> T {
        lock.lock()
        let previous = overrideLanguage
        overrideLanguage = language
        lock.unlock()
        defer {
            lock.lock()
            overrideLanguage = previous
            lock.unlock()
        }
        return try body()
    }

    /// Compile-time exhaustive selector across all 7 supported languages.
    public static func tr(
        lang: AppLanguage = L10n.currentLanguage,
        zh: String,
        zhHant: String? = nil,
        en: String,
        fr: String,
        es: String,
        ru: String,
        ar: String
    ) -> String {
        switch lang {
        case .zh: return zh
        case .zhHant: return zhHant ?? toTraditionalChinese(zh)
        case .en: return en
        case .fr: return fr
        case .es: return es
        case .ru: return ru
        case .ar: return ar
        }
    }

    /// Converts Simplified Chinese text to Traditional Chinese using macOS ICU transform and regional IT terminology.
    public static func toTraditionalChinese(_ simplified: String) -> String {
        let mutable = NSMutableString(string: simplified)
        CFStringTransform(mutable, nil, "Hans-Hant" as CFString, false)
        var result = mutable as String
        let terminologyReplacements: [(String, String)] = [
            ("虛擬機", "虛擬機器"),
            ("內存", "記憶體"),
            ("默認", "預設"),
            ("硬盤", "硬碟"),
            ("磁盤", "磁碟"),
            ("光盤", "光碟"),
            ("原盤", "原光碟"),
            ("文件夾", "資料夾"),
            ("註冊表", "登錄檔"),
            ("緩存", "快取"),
            ("激活", "啟用"),
            ("字節", "位元組"),
            ("菜單", "選單"),
            ("鏈接", "連結"),
            ("組件", "元件"),
            ("賬戶", "帳戶"),
            ("網絡", "網路")
        ]
        for (src, dst) in terminologyReplacements {
            result = result.replacingOccurrences(of: src, with: dst)
        }
        return result
    }

    public static func formatBytes(_ bytes: Int64, lang: AppLanguage = L10n.currentLanguage) -> String {
        bytes.formatted(.byteCount(style: .file).locale(lang.locale))
    }
}
