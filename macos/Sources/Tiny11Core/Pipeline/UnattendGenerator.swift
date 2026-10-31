import Foundation

public enum UnattendGenerator {
    /// 生成与目标架构匹配的 `autounattend.xml`（兼容 ARM64 与 x64）
    public static func generateXML(image: WindowsImage, recipe: BuildRecipe, includeSpecializeScript: Bool) -> String {
        let arch = image.architecture.unattendProcessorArchitecture
        let selectedSet = Set(recipe.selectedOptions)
        let bypassHardware = selectedSet.contains("hardware-bypass")
        let compactText = recipe.compactInstallation ? "true" : "false"

        var peRunSyncXml = ""
        if bypassHardware {
            let bypassKeys = [
                "BypassTPMCheck", "BypassSecureBootCheck", "BypassRAMCheck",
                "BypassStorageCheck", "BypassCPUCheck"
            ]
            var cmds: [String] = []
            for (idx, key) in bypassKeys.enumerated() {
                cmds.append("""
                            <RunSynchronousCommand wcm:action="add">
                                <Order>\(idx + 1)</Order>
                                <Path>reg add "HKLM\\SYSTEM\\Setup\\LabConfig" /v \(key) /t REG_DWORD /d 1 /f</Path>
                            </RunSynchronousCommand>
                """)
            }
            peRunSyncXml = """
                        <RunSynchronous>
            \(cmds.joined(separator: "\n"))
                        </RunSynchronous>
            """
        }

        var specializeSection = ""
        if recipe.preferLocalAccount || includeSpecializeScript {
            var specCmds: [String] = []
            var order = 1
            if recipe.preferLocalAccount {
                specCmds.append("""
                            <RunSynchronousCommand wcm:action="add">
                                <Order>\(order)</Order>
                                <Path>reg add "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f</Path>
                            </RunSynchronousCommand>
                """)
                order += 1
            }
            if includeSpecializeScript {
                specCmds.append("""
                            <RunSynchronousCommand wcm:action="add">
                                <Order>\(order)</Order>
                                <Path>powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\\Windows\\Setup\\Scripts\\Tiny11Specialize.ps1"</Path>
                            </RunSynchronousCommand>
                """)
            }
            specializeSection = """
                <settings pass="specialize">
                    <component name="Microsoft-Windows-Deployment" processorArchitecture="\(arch)" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                        <RunSynchronous>
            \(specCmds.joined(separator: "\n"))
                        </RunSynchronous>
                    </component>
                </settings>
            """
        }

        let hideOnlineXml = recipe.preferLocalAccount ? "\n                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>" : ""

        return """
        <?xml version="1.0" encoding="utf-8"?>
        <unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
            <settings pass="windowsPE">
                <component name="Microsoft-Windows-Setup" processorArchitecture="\(arch)" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                    <ImageInstall>
                        <OSImage>
                            <Compact>\(compactText)</Compact>
                            <WillShowUI>OnError</WillShowUI>
                            <InstallFrom>
                                <MetaData wcm:action="add">
                                    <Key>/IMAGE/INDEX</Key>
                                    <Value>1</Value>
                                </MetaData>
                            </InstallFrom>
                        </OSImage>
                    </ImageInstall>
                    <DynamicUpdate>
                        <Enable>false</Enable>
                    </DynamicUpdate>
        \(peRunSyncXml)
                </component>
            </settings>
        \(specializeSection)
            <settings pass="oobeSystem">
                <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="\(arch)" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                    <OOBE>
                        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>\(hideOnlineXml)
                    </OOBE>
                </component>
            </settings>
        </unattend>
        """
    }

    /// 生成安装部署阶段 (specialize) 辅助清理脚本，用于在可维护镜像首次启动前通过原生 DISM 完成可选功能禁用、FOD 移除或离线启用 .NET 3.5
    public static func generateSpecializePowerShell(recipe: BuildRecipe) -> String? {
        // Core 模式下组件服务栈已被裁剪，不再运行在线 DISM 变更
        guard !recipe.effectiveCore else { return nil }

        let selectedSet = Set(recipe.selectedOptions)
        let featureTargets = CleanupCatalog.options
            .filter { $0.kind == .feature && selectedSet.contains($0.id) }
            .flatMap(\.targets)
        let capabilityPrefixes = CleanupCatalog.options
            .filter { $0.kind == .capability && selectedSet.contains($0.id) }
            .flatMap(\.targets)
        let appTargets = CleanupCatalog.options
            .filter { $0.kind == .app && selectedSet.contains($0.id) }
            .flatMap(\.targets)

        if featureTargets.isEmpty && capabilityPrefixes.isEmpty && appTargets.isEmpty && !recipe.enableNetFx3 {
            return nil
        }

        var lines: [String] = [
            "$ErrorActionPreference = 'SilentlyContinue'",
            "$ProgressPreference = 'SilentlyContinue'"
        ]

        if !appTargets.isEmpty {
            let quoted = appTargets.map { "'\($0)'" }.joined(separator: ", ")
            lines.append("$appPrefixes = @(\(quoted))")
            lines.append("""
            Get-AppxProvisionedPackage -Online | ForEach-Object {
                $pkg = $_
                foreach ($p in $appPrefixes) {
                    if ($pkg.DisplayName -ieq $p -or $pkg.PackageName -ilike "$p`_*") {
                        Remove-AppxProvisionedPackage -Online -PackageName $pkg.PackageName -NoRestart | Out-Null
                        break
                    }
                }
            }
            """)
        }

        for feat in featureTargets {
            lines.append("Disable-WindowsOptionalFeature -Online -FeatureName '\(feat)' -Remove -NoRestart | Out-Null")
        }

        if !capabilityPrefixes.isEmpty {
            let quotedCaps = capabilityPrefixes.map { "'\($0)'" }.joined(separator: ", ")
            lines.append("$capPrefixes = @(\(quotedCaps))")
            lines.append("""
            Get-WindowsCapability -Online | Where-Object { $_.State -eq 'Installed' } | ForEach-Object {
                $cap = $_
                foreach ($cp in $capPrefixes) {
                    if ($cap.Name -ilike "$cp.*" -or $cap.Name -ilike "$cp~*") {
                        Remove-WindowsCapability -Online -Name $cap.Name | Out-Null
                        break
                    }
                }
            }
            """)
        }

        if recipe.enableNetFx3 {
            lines.append("""
            foreach ($drv in [System.IO.DriveInfo]::GetDrives()) {
                $sxs = Join-Path $drv.RootDirectory.FullName 'sources\\sxs'
                if (Test-Path $sxs) {
                    Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -All -LimitAccess -Source $sxs -NoRestart | Out-Null
                    break
                }
            }
            """)
        }

        lines.append("Remove-Item -LiteralPath $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue")
        lines.append("exit 0")
        return lines.joined(separator: "\r\n") + "\r\n"
    }
}
