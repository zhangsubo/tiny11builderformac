import Foundation
import Darwin
import CHivex

public struct HiveModificationSummary: Sendable, Equatable {
    public var policiesWritten: Int = 0
    public var deprovisionedFamilies: [String] = []
    public var removedStagedEntries: Int = 0
    public var disabledServices: [String] = []
    public var edgeUninstallRemoved: Bool = false
}

/// 使用 libhivex 在用户态直接打开并编辑离线 Windows REGF 注册表 Hive 文件（绝不触碰宿主机系统环境）
public final class HiveSession {
    private var handle: OpaquePointer?
    public let path: String
    public let writable: Bool

    public init(path: String, writable: Bool = true) throws {
        self.path = path
        self.writable = writable
        let flags: Int32 = writable ? HIVEX_OPEN_WRITE : 0
        guard let h = hivex_open(path, flags) else {
            let code = errno
            let msg = String(cString: strerror(code))
            throw Tiny11Error.registryError(
                L10n.hiveOpenFailed(fileName: URL(fileURLWithPath: path).lastPathComponent, message: msg, code: code)
            )
        }
        self.handle = h
    }

    deinit {
        if let h = handle {
            hivex_close(h)
        }
    }

    public func close() {
        if let h = handle {
            hivex_close(h)
            handle = nil
        }
    }

    private func requireHandle() throws -> OpaquePointer {
        guard let h = handle else {
            throw Tiny11Error.registryError(L10n.hiveSessionClosed())
        }
        return h
    }

    public func rootNode() throws -> hive_node_h {
        let h = try requireHandle()
        let root = hivex_root(h)
        guard root != 0 else {
            throw Tiny11Error.registryError(L10n.hiveRootNotFound(path))
        }
        return root
    }

    /// 查找指定反斜杠路径的子键，不存在时返回 `nil`
    public func findNode(path keyPath: String) throws -> hive_node_h? {
        let h = try requireHandle()
        var current = try rootNode()
        let parts = keyPath.split(separator: "\\").map(String.init).filter { !$0.isEmpty }
        for part in parts {
            errno = 0
            let next = part.withCString { cstr in
                hivex_node_get_child(h, current, cstr)
            }
            if next == 0 {
                if errno != 0 && errno != ENOENT {
                    let msg = String(cString: strerror(errno))
                    throw Tiny11Error.registryError(L10n.hiveFindKeyFailed(keyPath: keyPath, message: msg))
                }
                return nil
            }
            current = next
        }
        return current
    }

    /// 查找或递归创建指定路径的子键
    public func ensureNode(path keyPath: String) throws -> hive_node_h {
        let h = try requireHandle()
        var current = try rootNode()
        let parts = keyPath.split(separator: "\\").map(String.init).filter { !$0.isEmpty }
        for part in parts {
            errno = 0
            var next = part.withCString { cstr in
                hivex_node_get_child(h, current, cstr)
            }
            if next == 0 {
                next = part.withCString { cstr in
                    hivex_node_add_child(h, current, cstr)
                }
                guard next != 0 else {
                    let msg = String(cString: strerror(errno))
                    throw Tiny11Error.registryError(L10n.hiveCreateSubkeyFailed(part: part, keyPath: keyPath, message: msg))
                }
            }
            current = next
        }
        return current
    }

    /// 列出某个节点的所有直接子键名称与句柄
    public func children(of node: hive_node_h) throws -> [(name: String, node: hive_node_h)] {
        let h = try requireHandle()
        guard let listPtr = hivex_node_children(h, node) else {
            let msg = String(cString: strerror(errno))
            throw Tiny11Error.registryError(L10n.hiveReadChildrenFailed(msg))
        }
        defer { free(listPtr) }

        var results: [(String, hive_node_h)] = []
        var idx = 0
        while listPtr[idx] != 0 {
            let child = listPtr[idx]
            if let namePtr = hivex_node_name(h, child) {
                let name = String(cString: namePtr)
                free(namePtr)
                results.append((name, child))
            }
            idx += 1
        }
        return results
    }

    /// 递归删除指定节点及其全部子键和值
    public func deleteNode(_ node: hive_node_h, description: String = "") throws {
        let h = try requireHandle()
        let rc = hivex_node_delete_child(h, node)
        guard rc == 0 else {
            let msg = String(cString: strerror(errno))
            throw Tiny11Error.registryError(L10n.hiveDeleteNodeFailed(description: description, message: msg))
        }
    }

    public func getDword(node: hive_node_h, name: String) throws -> UInt32? {
        let h = try requireHandle()
        let valHandle = name.withCString { hivex_node_get_value(h, node, $0) }
        guard valHandle != 0 else { return nil }
        errno = 0
        let raw = hivex_value_dword(h, valHandle)
        if raw == -1 && errno != 0 {
            return nil
        }
        return UInt32(bitPattern: raw)
    }

    public func getString(node: hive_node_h, name: String) throws -> String? {
        let h = try requireHandle()
        let valHandle = name.withCString { hivex_node_get_value(h, node, $0) }
        guard valHandle != 0 else { return nil }
        guard let cstr = hivex_value_string(h, valHandle) else { return nil }
        defer { free(cstr) }
        return String(cString: cstr)
    }

    public func setValue(keyPath: String, name: String, data: RegistryValueData) throws {
        let node = try ensureNode(path: keyPath)
        try setValue(node: node, name: name, data: data, contextPath: keyPath)
    }

    public func setValue(node: hive_node_h, name: String, data: RegistryValueData, contextPath: String = "") throws {
        let h = try requireHandle()
        switch data {
        case .dword(let number):
            var le = number.littleEndian
            let bytes = withUnsafeBytes(of: &le) { Data($0) }
            try writeRawValue(h: h, node: node, name: name, type: hive_t_REG_DWORD, payload: bytes, contextPath: contextPath)

        case .string(let text):
            // Windows REG_SZ 采用以双零字节 (\0\0) 结尾的 UTF-16LE 编码
            var payload = text.data(using: .utf16LittleEndian) ?? Data()
            payload.append(contentsOf: [0x00, 0x00])
            try writeRawValue(h: h, node: node, name: name, type: hive_t_REG_SZ, payload: payload, contextPath: contextPath)
        }

        // 回读校验确保值已准确写入（保持与原版 OfflineRegistry.cs 一致的严谨性）
        switch data {
        case .dword(let expected):
            guard let actual = try getDword(node: node, name: name), actual == expected else {
                throw Tiny11Error.registryError(L10n.hiveReadbackFailed(contextPath: contextPath, name: name))
            }
        case .string(let expected):
            guard let actual = try getString(node: node, name: name), actual == expected else {
                throw Tiny11Error.registryError(L10n.hiveReadbackFailed(contextPath: contextPath, name: name))
            }
        }
    }

    private func writeRawValue(
        h: OpaquePointer,
        node: hive_node_h,
        name: String,
        type: hive_type,
        payload: Data,
        contextPath: String
    ) throws {
        guard let keyDup = strdup(name) else {
            throw Tiny11Error.registryError(L10n.hiveMemoryAllocFailed())
        }
        defer { free(keyDup) }

        let rc: Int32 = payload.withUnsafeBytes { rawBuf in
            let mutablePtr = UnsafeMutableRawPointer(mutating: rawBuf.baseAddress)?.assumingMemoryBound(to: CChar.self)
            var spec = hive_set_value(
                key: keyDup,
                t: type,
                len: payload.count,
                value: mutablePtr
            )
            return hivex_node_set_value(h, node, &spec, 0)
        }

        guard rc == 0 else {
            let msg = String(cString: strerror(errno))
            throw Tiny11Error.registryError(L10n.hiveWriteValueFailed(contextPath: contextPath, name: name, message: msg))
        }
    }

    public func commit() throws {
        let h = try requireHandle()
        guard writable else { return }
        let rc = hivex_commit(h, nil, 0)
        guard rc == 0 else {
            let msg = String(cString: strerror(errno))
            throw Tiny11Error.registryError(
                L10n.hiveCommitFailed(fileName: URL(fileURLWithPath: path).lastPathComponent, message: msg)
            )
        }
    }
}

public enum OfflineHiveEditor {
    /// 对提取出的 install.wim 三大注册表 Hive 一次性完成策略注入、OOBE 断网直通、AppX Deprovisioned 防重装以及 Core 服务禁用
    public static func applyInstallHives(
        softwareHivePath: String,
        systemHivePath: String,
        defaultUserHivePath: String,
        recipe: BuildRecipe,
        discoveredPackageNames: [String],
        removeEdgeUninstallEntry: Bool,
        log: (String) -> Void
    ) throws -> HiveModificationSummary {
        var summary = HiveModificationSummary()
        let selectedSet = Set(recipe.selectedOptions)

        let software = try HiveSession(path: softwareHivePath, writable: true)
        defer { software.close() }
        let system = try HiveSession(path: systemHivePath, writable: true)
        defer { system.close() }
        let user = try HiveSession(path: defaultUserHivePath, writable: true)
        defer { user.close() }

        // 1. 解析当前 ControlSet (例如 ControlSet001)
        var currentIndex: UInt32 = 1
        if let selectNode = try system.findNode(path: "Select"),
           let cur = try system.getDword(node: selectNode, name: "Current"),
           cur > 0 && cur < 1000 {
            currentIndex = cur
        }
        let controlSetName = String(format: "ControlSet%03d", currentIndex)

        // 2. 应用选中的策略项
        for optionId in recipe.selectedOptions {
            for policy in PolicyCatalog.values(forOptionId: optionId) {
                let resolvedKey = policy.keyPath.replacingOccurrences(of: "{ControlSet}", with: controlSetName)
                let session: HiveSession = switch policy.hive {
                case .software: software
                case .defaultUser: user
                case .system: system
                }
                try session.setValue(keyPath: resolvedKey, name: policy.name, data: policy.data)
                summary.policiesWritten += 1
                log(L10n.logPolicyWritten(hive: policy.hive.rawValue, key: resolvedKey, name: policy.name))
            }
        }

        // 3. 本地账户断网直通 (BypassNRO) —— 解决 Mac 虚拟机初装无 VirtIO/vmxnet3 网卡驱动卡死 OOBE 联网页
        if recipe.preferLocalAccount {
            try software.setValue(
                keyPath: #"Microsoft\Windows\CurrentVersion\OOBE"#,
                name: "BypassNRO",
                data: .dword(1)
            )
            summary.policiesWritten += 1
            log(L10n.logBypassNROEnabled())
        }

        // 4. 离线预装 AppX 防重装注册与 Staged 项清理
        let appxStoreBase = #"Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore"#
        var familiesToDeprovision = Set<String>()

        // 从 WIM 目录扫描到的包全名提取 PackageFamilyName（例如 `Microsoft.BingNews_4.8.11001.0_x64__8wekyb3d8bbwe` -> `Microsoft.BingNews_8wekyb3d8bbwe`）
        for pkgFullName in discoveredPackageNames {
            if CleanupCatalog.matchesAppPackageName(pkgFullName, selectedOptionIds: selectedSet) != nil,
               let family = extractPackageFamilyName(from: pkgFullName) {
                familiesToDeprovision.insert(family)
            }
        }

        // 同时扫描注册表 AppxAllUserStore 下的 InboxApplications / Staged / Applications
        for subStore in ["Applications", "Staged", "InboxApplications"] {
            let storePath = "\(appxStoreBase)\\\(subStore)"
            guard let storeNode = try software.findNode(path: storePath) else { continue }
            let entries = try software.children(of: storeNode)
            for (pkgKeyName, childNode) in entries {
                if CleanupCatalog.matchesAppPackageName(pkgKeyName, selectedOptionIds: selectedSet) != nil {
                    if let family = extractPackageFamilyName(from: pkgKeyName) {
                        familiesToDeprovision.insert(family)
                    }
                    // 对非系统保护的 Staged / Applications 预装条目直接移除注册键
                    if subStore == "Staged" || subStore == "Applications" {
                        try software.deleteNode(childNode, description: "\(storePath)\\\(pkgKeyName)")
                        summary.removedStagedEntries += 1
                        log(L10n.logRemovedStagedEntry(subStore: subStore, pkgKeyName: pkgKeyName))
                    }
                }
            }
        }

        for family in familiesToDeprovision.sorted() {
            _ = try software.ensureNode(path: "\(appxStoreBase)\\Deprovisioned\\\(family)")
            summary.deprovisionedFamilies.append(family)
            log(L10n.logLockedDeprovisioned(family))
        }

        // 5. 若物理移除了 Edge 文件，同步清理已安装程序列表中的 Microsoft Edge 卸载入口（对应原版 EdgeRegistration.cs）
        if removeEdgeUninstallEntry {
            for uninstallPath in [
                #"Microsoft\Windows\CurrentVersion\Uninstall"#,
                #"WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"#
            ] {
                guard let uninstallNode = try software.findNode(path: uninstallPath) else { continue }
                for (name, child) in try software.children(of: uninstallNode) where name.caseInsensitiveCompare("Microsoft Edge") == .orderedSame {
                    let display = try software.getString(node: child, name: "DisplayName") ?? ""
                    let publisher = try software.getString(node: child, name: "Publisher") ?? ""
                    if display.caseInsensitiveCompare("Microsoft Edge") == .orderedSame &&
                       publisher.caseInsensitiveCompare("Microsoft Corporation") == .orderedSame {
                        try software.deleteNode(child, description: "\(uninstallPath)\\Microsoft Edge")
                        summary.edgeUninstallRemoved = true
                        log(L10n.logRemovedEdgeUninstall(uninstallPath))
                    }
                }
            }
        }

        // 6. Core 模式：禁用所有 ControlSet 中的 Windows Update 与 Defender 服务及策略
        if recipe.effectiveCore {
            let rootChildren = try system.children(of: try system.rootNode())
            for (keyName, _) in rootChildren where keyName.range(of: #"^ControlSet\d{3}$"#, options: .regularExpression) != nil {
                guard let servicesNode = try system.findNode(path: "\(keyName)\\Services") else { continue }
                let existingServices = Dictionary(
                    uniqueKeysWithValues: try system.children(of: servicesNode).map { ($0.name.lowercased(), $0) }
                )
                for svc in PolicyCatalog.coreDisabledServices {
                    guard let matched = existingServices[svc.lowercased()] else { continue }
                    try system.setValue(
                        node: matched.node,
                        name: "Start",
                        data: .dword(4),
                        contextPath: "\(keyName)\\Services\\\(matched.name)"
                    )
                    if !summary.disabledServices.contains(matched.name) {
                        summary.disabledServices.append(matched.name)
                    }
                    log(L10n.logCoreDisabledService(controlSet: keyName, service: matched.name))
                }
            }
            for policy in PolicyCatalog.coreSoftwarePolicies {
                try software.setValue(keyPath: policy.keyPath, name: policy.name, data: policy.data)
                summary.policiesWritten += 1
            }
        }

        try software.commit()
        try system.commit()
        try user.commit()
        return summary
    }

    /// 向 boot.wim 的 SYSTEM Hive 写入 Setup\LabConfig 硬件检测绕过项
    public static func applyBootSetupBypass(systemHivePath: String, log: (String) -> Void) throws {
        let system = try HiveSession(path: systemHivePath, writable: true)
        defer { system.close() }
        for policy in PolicyCatalog.values(forOptionId: "hardware-bypass") where policy.hive == .system {
            try system.setValue(keyPath: policy.keyPath, name: policy.name, data: policy.data)
            log(L10n.logBootBypassWritten(keyPath: policy.keyPath, name: policy.name))
        }
        try system.commit()
    }

    /// 检查离线 SOFTWARE Hive 是否存在挂起的组件更新标记（对应 OfflineDataCleaner.AssessRegistryPending）
    public static func hasPendingServicingMarkers(softwareHivePath: String) -> Bool {
        guard FileManager.default.fileExists(atPath: softwareHivePath),
              let software = try? HiveSession(path: softwareHivePath, writable: false) else {
            return false
        }
        defer { software.close() }

        let cbsBase = #"Microsoft\Windows\CurrentVersion\Component Based Servicing"#
        let pendingKeys = [
            "\(cbsBase)\\RebootPending",
            "\(cbsBase)\\PackagesPending",
            "\(cbsBase)\\RebootInProgress",
            #"Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"#
        ]
        for key in pendingKeys {
            if (try? software.findNode(path: key)) != nil {
                return true
            }
        }
        return false
    }

    /// 将包全名（如 `Microsoft.XboxGamingOverlay_7.124.5142.0_arm64__8wekyb3d8bbwe`）转换为包族名 `Microsoft.XboxGamingOverlay_8wekyb3d8bbwe`
    public static func extractPackageFamilyName(from fullName: String) -> String? {
        let parts = fullName.split(separator: "_", omittingEmptySubsequences: false).map(String.init)
        guard parts.count >= 5 else { return nil }
        let name = parts[0]
        let publisherId = parts[parts.count - 1]
        guard !name.isEmpty, publisherId.count >= 10, !publisherId.contains(".") else {
            return nil
        }
        return "\(name)_\(publisherId)"
    }
}
