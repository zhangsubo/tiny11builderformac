# Tiny11 Builder for Mac (Apple Silicon)

🌐 **Language / 语言**: [**🇨🇳 中文说明**](#中文说明) · [**🇺🇸 English Documentation**](#english-documentation) · 📄 [**`readmeformac.md`**](readmeformac.md)

---

<a id="中文说明"></a>

## 🇨🇳 Tiny11 Builder for Mac（中文说明）

原生 **macOS ARM64 (`M1` / `M2` / `M3` / `M4`)** 桌面应用，无需启动 Windows 虚拟机、无需 `sudo` 管理员密码、无需 NTFS 分区，即可在本地将微软官方 **Windows 11 ARM64 / x64 ISO** 流式精简并重新打包为干净轻量的可引导 `.iso` 镜像，直接用于 **Parallels Desktop、VMware Fusion、UTM** 或 PC 装机。

- 📦 [**下载 `Tiny11Builder-macOS-arm64.dmg` (GitHub Releases)**](https://github.com/zhangsubo/tiny11builderformac/releases/latest)
- 🏠 [**返回项目主文档 (`../README.md`)**](../README.md)

### 核心特性

#### 1. 纯用户态流式引擎（零宿主机污染）
- **`hdiutil` 只读挂载**：安全读取官方 ISO（即使已在 Finder 中挂载也会无感复用），源镜像绝不修改。
- **`wimlib` 直接归档修改**：无需把 15GB 系统解压到磁盘（避免 macOS APFS 大小写不敏感文件名冲突与 Windows ACL 丢失），直接在 `.wim` 归档流中完成单版本导出、臃肿组件剔除与多核 `LZMS` 固态压缩（生成高压缩比 `install.esd`）。
- **`libhivex` (`CHivex`) 离线注册表二进制编辑**：C 语言直连读写离线 `SOFTWARE`、`SYSTEM`、`NTUSER.DAT` Hive 文件，写入硬件绕过策略、`Deprovisioned` 防重装锁、完整卸载项清理（含 Edge / EdgeUpdate / EdgeWebView2 5 项注册表项）与隐私策略。
- **`mkisofs` (`cdrtools`) 双架构可引导封装**：原生合成支持 `> 4 GiB` 大文件的 `UDF + ISO9660 Level 3` 镜像，完整支持 **ARM64 纯 UEFI (`0xEF`)** 与 **x64 Legacy BIOS + UEFI 混合引导**。

#### 2. 四种构建预设（含专为 Mac 虚拟机调优模式）

| 预设模式 | 适用场景 | 核心行为 |
| :--- | :--- | :--- |
| **Tiny11 · Mac 虚拟机优化版** *(推荐)* | Parallels Desktop / VMware Fusion / UTM 日常办公与开发虚拟机 | 绕过 TPM 2.0 / SecureBoot / 8GB 内存限制；注入 `BypassNRO` 防止无网卡驱动时卡死在联网界面；关闭系统预留空间（立省 ~7GB）与 BitLocker 自动加密；默认开启 `CompactOS`；保留 `WebView2` 与 Windows Update，确保 **Parallels Tools / VMware Tools / SPICE Guest Tools** 一键顺畅安装。 |
| **Tiny11 · 标准精简版** | 物理 PC 装机或标准虚拟机 | 同步上游 Tiny11 标准精简规则，保留安全中心、Windows Update 与系统可维护性；**支持独立开关选择是否精简 Microsoft Edge 与 WebView2**。 |
| **自定义 · 逐项勾选** | 高级玩家深度定制 / 导入便携配方 | 开放全部 33 项精简开关（含上游 `v0.2.0` 新增的 **6 项底层载荷深度裁剪**），支持导入/导出 JSON 构建配方（兼容上游 `recipes/cd700-custom.json`）。 |
| **Tiny11 Core · 极限精简版** | 一次性测试沙盒 / 极小磁盘占用 | 额外剥离 WinSxS 组件库、Windows Update、Defender 与 WinRE 恢复环境（构建后不可再安装系统更新）。 |

#### 3. 同步上游 `v0.2.0` 核心改进
- **标准版可选是否精简 Edge**：在 **「Tiny11 · 标准精简版」** 卡片与定制页均提供独立的 **精简 Microsoft Edge** 开关，可按需选择彻底移除 Edge / WebView2 或完整保留其运行库兼容性，无需退化为纯手动勾选模式。
- **自定义模式 6 项深度底层载荷裁剪（Custom-only）**：
  - `remove-wow64`：移除 32 位应用兼容层（`SysWOW64`）
  - `remove-desktop-netfx`：移除传统桌面 `.NET` 与 `WindowsPowerShell` 程序集
  - `remove-ime-files`：移除输入法编辑器（IME）载荷
  - `remove-speech-files`：移除离线语音识别与语音合成（TTS）引擎载荷
  - `remove-print-drivers`：移除内置打印/扫描仪驱动库（`prn*` / `scan*` / `mfd*`）与打印后台处理程序载荷
  - `remove-extra-media`：移除额外壁纸、系统提示音与无障碍光标方案
- **`boot.wim` 单卷极限压缩（`Shrink boot.wim`）**：可选将多索引 `sources/boot.wim` 仅保留 Windows Setup 引导卷，并以 `LZX:100` 极限重压缩重建为单卷可引导镜像，进一步缩减 ISO 体积。
- **Legacy Setup 应答修复**：当勾选要求旧版安装器（Legacy Setup）的深度裁剪项时，自动在 `autounattend.xml` 的 `windowsPE` 阶段注入 `<ProductKey><WillShowUI>Always</WillShowUI></ProductKey>`，解决旧版安装程序卡在产品密钥界面的问题。
- **便携配方兼容与 ISO 体积预算校验**：直接支持加载上游便携配方（如 [`../recipes/cd700-custom.json`](../recipes/cd700-custom.json)，自动保留当前已选源 ISO 与输出路径），并在校验阶段检查 `IsoSizeLimitBytes` 体积预算。
- **更友好的磁盘空间预检**：工作区可用空间预检下调为 `max(10 GiB, 源镜像有效体积 × 2)`，对剩余磁盘空间紧张的 Mac 更加友好。

#### 4. 多语言国际化（7 种语言自适应）
- 内置 **简体中文（`zh-Hans`）、繁体中文（`zh-Hant`）、英文（`en`）、法文（`fr`）、西班牙文（`es`）、俄文（`ru`）、阿拉伯文（`ar`，含原生 RTL 从右向左镜像布局）** 七种语言。
- 自动跟随 macOS 系统首选语言；若系统首选语言不在上述 7 种语言内，则统一回退显示英文。
- 支持通过命令行环境变量或启动参数强制指定运行语言（便于测试与固定语言使用）：
  ```bash
  # 强制以英文启动
  open -n macos/dist/Tiny11Builder.app --env TINY11_LANG=en --args -AppleLanguages '(en)'

  # 强制以繁体中文启动
  open -n macos/dist/Tiny11Builder.app --env TINY11_LANG=zh-Hant --args -AppleLanguages '(zh-Hant)'
  ```

#### 5. 开箱即用自包含 `.app` 应用包
- 打包产出的 `Tiny11Builder.app` 已将 `wimlib-imagex`、`mkisofs`、`libwim`、`libhivex`、`libintl` 内嵌并完成 `@executable_path` / `@loader_path` 动态库重定位与代码签名，拷贝到任意 Apple Silicon Mac 双击即可运行，无需用户手动安装 Homebrew 或命令行工具。

### 快速使用流程

1. 打开 `Tiny11Builder.app`（从 GitHub Releases 下载 `Tiny11Builder-macOS-arm64.dmg` 拖入应用程序，或本地运行 `macos/dist/Tiny11Builder.app`）。
2. **第 1 步 · 构建模式**：
   - 日常使用 Parallels Desktop / VMware Fusion / UTM 推荐选择 **「Tiny11 · Mac 虚拟机优化版」**；
   - 物理机或通用装机可选 **「Tiny11 · 标准精简版」**（可直接勾选是否保留或移除 Edge）；
   - 深度裁剪可选 **「自定义 · 逐项勾选」** 或从顶部工具栏导入 `.json` 配方。
3. **第 2 步 · 导入镜像**：将本地准备好的官方 Windows 11 `.iso`（支持 22H2 / 23H2 / 24H2 / 25H2 及更新版本的 ARM64 或 x64 镜像）拖入窗口，选择要提取的目标版本（如 `Windows 11 Pro` / `專業版`）。
4. **第 3–4 步 · 定制与参数**：按需微调移除清单、压缩等级（`Recovery ESD` 体积最小，`Fast WIM` 打包最快）、是否开启 `boot.wim` 单卷极限压缩及输出 ISO 路径。
5. **第 5–6 步 · 复核与构建**：点击 **「开始制作精简版 ISO」**，实时查看八阶段进度与滚动日志；完成后一键在 Finder 中定位生成的 `.iso` 并核对 `SHA-256` 校验值。

### 本地编译、测试与打包

#### 环境要求
- Apple Silicon Mac（`arm64`，macOS 14.0 Sonoma 或更高版本）
- Xcode 16+ / Swift 6 工具链
- Homebrew（仅开发机编译打包时需要，最终用户运行 `.app` 不需要）

#### 一键构建自包含 `.app` 与 `.dmg`

```bash
./macos/Scripts/build-app.sh
```

打包完成后产物位于：
- 应用包：`macos/dist/Tiny11Builder.app`
- 安装盘镜像：`macos/dist/Tiny11Builder-macOS-arm64.dmg`

#### 运行单元与全链路合成 ISO 集成测试

```bash
swift test --package-path macos
```

---

<a id="english-documentation"></a>

## 🇺🇸 Tiny11 Builder for Mac (English Documentation)

Native **macOS ARM64 (`M1` / `M2` / `M3` / `M4`)** desktop application built with **Swift 6 + SwiftUI**. Stream-trim and repackage official Microsoft **Windows 11 ARM64 / x64 ISOs** into clean, lightweight, bootable `.iso` installers directly on your Mac — **no Windows VM, no `sudo` password, and no NTFS partition required**. Designed for **Parallels Desktop, VMware Fusion, UTM**, and physical PC installs.

- 📦 [**Download `Tiny11Builder-macOS-arm64.dmg` (GitHub Releases)**](https://github.com/zhangsubo/tiny11builderformac/releases/latest)
- 🏠 [**Back to Main Repository README (`../README.md`)**](../README.md)

### Key Features

#### 1. Pure User-Space Streaming Engine (Zero Host Pollution)
- **Read-Only `hdiutil` Mounting**: Safely reads your source ISO (seamlessly reuses existing Finder mounts) and leaves the original media untouched.
- **Direct In-Archive WIM Editing via `wimlib`**: Eliminates the need to extract 15+ GB of Windows files onto macOS APFS (avoiding case-insensitivity collisions and Windows NTFS ACL loss). Exports a single target index, strips bloatware in-stream, and compresses with multi-core `LZMS` solid compression (`install.esd`).
- **Binary Offline Registry Editing via `libhivex` (`CHivex`)**: Directly reads and writes offline `SOFTWARE`, `SYSTEM`, and `NTUSER.DAT` hives in C to inject hardware bypasses, `Deprovisioned` locks against silent app reinstallation, full Edge/WebView2 uninstall key cleanup (all 5 Microsoft Corporation entries), and telemetry policies.
- **Dual-Architecture Bootable ISO Mastering via `mkisofs` (`cdrtools`)**: Generates `UDF + ISO9660 Level 3` images supporting `> 4 GiB` files with native **ARM64 pure UEFI (`0xEF`)** and **x64 Legacy BIOS + UEFI hybrid boot** support.

#### 2. Four Build Presets (Including Mac VM Optimized Mode)

| Preset | Best For | What It Does |
| :--- | :--- | :--- |
| **Tiny11 · Mac VM Edition** *(Recommended)* | Daily-driver VMs in Parallels Desktop, VMware Fusion, or UTM | Bypasses TPM 2.0, SecureBoot & 8 GB RAM checks; injects `BypassNRO` so OOBE never deadlocks when VirtIO/`vmxnet3` NIC drivers are missing; disables 7 GB Reserved Storage (`ShippedWithReserves=0`) & automatic BitLocker encryption; enables `CompactOS` by default; preserves `WebView2` and Windows Update so **Parallels Tools / VMware Tools / SPICE Guest Tools** install out of the box. |
| **Tiny11 · Standard** | Physical PCs or standard VMs | Matches upstream Tiny11 Standard removals while keeping Windows Security, Windows Update, and servicing intact. **Includes a dedicated toggle to optionally strip or keep Microsoft Edge & WebView2.** |
| **Custom · Granular Selection** | Power users & portable recipes | Unlocks all 33 removal switches (including the **6 Custom-only native payload removals** from upstream `v0.2.0`) and supports importing/exporting JSON recipes (compatible with upstream [`../recipes/cd700-custom.json`](../recipes/cd700-custom.json)). |
| **Tiny11 Core · Extreme** | Disposable test VMs & minimal disk footprint | Also strips WinSxS component store, Windows Update, Windows Defender, and WinRE recovery image (cannot install updates after building). |

#### 3. Synced Upstream `v0.2.0` Enhancements
- **Standard Preset Edge Toggle**: Toggle **Remove Microsoft Edge** directly on the **Tiny11 Standard** preset card or Customize screen without switching to full manual Custom mode.
- **6 Custom-Only Native Payload Removals**:
  - `remove-wow64`: Remove 32-bit compatibility layer (`SysWOW64`)
  - `remove-desktop-netfx`: Remove legacy desktop `.NET` and `WindowsPowerShell` assemblies
  - `remove-ime-files`: Remove Input Method Editor (IME) payloads
  - `remove-speech-files`: Remove offline speech recognition and TTS engine payloads
  - `remove-print-drivers`: Remove inbox printer/scanner driver packages (`prn*` / `scan*` / `mfd*`) and print spooler payloads
  - `remove-extra-media`: Remove extra wallpapers, system sounds, and accessibility cursor schemes
- **Shrink `boot.wim` (`ShrinkBootImage`)**: Optionally rebuilds a multi-index `sources/boot.wim` into a single-index Setup-only bootable WIM using maximum `LZX:100` compression.
- **Legacy Setup `autounattend.xml` Fix**: Automatically injects `<UserData><ProductKey><WillShowUI>Always</WillShowUI></ProductKey></UserData>` into the `windowsPE` pass whenever deep removals require legacy Windows Setup.
- **Portable Recipe Compatibility & ISO Size Budget Check**: Directly loads upstream portable recipes (such as [`../recipes/cd700-custom.json`](../recipes/cd700-custom.json) while preserving your selected source/output paths) and enforces `IsoSizeLimitBytes` during output verification.
- **Lower Disk Space Requirement**: Workspace free-space preflight check lowered to `max(10 GiB, effectiveSourceBytes * 2)`.

#### 4. 7-Language Internationalization (i18n)
- Built-in support for **Simplified Chinese (`zh-Hans`), Traditional Chinese (`zh-Hant`), English (`en`), French (`fr`), Spanish (`es`), Russian (`ru`), and Arabic (`ar`, with native right-to-left RTL layout mirroring)**.
- Automatically follows your macOS primary system language; if your system language is not one of the 7 supported languages, the app defaults to **English**.
- You can also force a specific language via environment variable or launch arguments:
  ```bash
  # Force launch in English
  open -n macos/dist/Tiny11Builder.app --env TINY11_LANG=en --args -AppleLanguages '(en)'

  # Force launch in Traditional Chinese
  open -n macos/dist/Tiny11Builder.app --env TINY11_LANG=zh-Hant --args -AppleLanguages '(zh-Hant)'
  ```

#### 5. Self-Contained `.app` Bundle
- `Tiny11Builder.app` embeds `wimlib-imagex`, `mkisofs`, `libwim`, `libhivex`, and `libintl` with relocated `@executable_path` / `@loader_path` dynamic library paths and ad-hoc code signing. Copy it to any Apple Silicon Mac and double-click to run — no Homebrew or CLI setup needed by end users.

### Quick Start

1. Open `Tiny11Builder.app` (download `Tiny11Builder-macOS-arm64.dmg` from GitHub Releases, or launch `macos/dist/Tiny11Builder.app`).
2. **Step 1 · Build Mode**:
   - Choose **Tiny11 · Mac VM Edition** for Parallels Desktop, VMware Fusion, or UTM;
   - Choose **Tiny11 · Standard** for general installs (with optional Edge removal toggle);
   - Choose **Custom** for granular control or import a `.json` recipe from the toolbar.
3. **Step 2 · Source Media**: Drag and drop an official Windows 11 `.iso` (22H2 / 23H2 / 24H2 / 25H2+ ARM64 or x64) and select the target edition (e.g., `Windows 11 Pro`).
4. **Steps 3–4 · Customize & Target**: Adjust component removals, compression profile (`Recovery ESD` for smallest size, `Fast WIM` for fastest build), optional `Shrink boot.wim`, and output `.iso` path.
5. **Steps 5–6 · Review & Build**: Click **Build Trimmed ISO** to watch real-time 8-stage progress and logs, then reveal your finished `.iso` in Finder with its verified `SHA-256` checksum.

### Building & Testing from Source

#### Requirements
- Apple Silicon Mac (`arm64`, macOS 14.0 Sonoma or later)
- Xcode 16+ / Swift 6 toolchain
- Homebrew (required only on the build machine when packaging; not required by end users)

#### Build Self-Contained `.app` and `.dmg`

```bash
./macos/Scripts/build-app.sh
```

Output artifacts:
- App bundle: `macos/dist/Tiny11Builder.app`
- Disk image: `macos/dist/Tiny11Builder-macOS-arm64.dmg`

#### Run Unit & Synthetic ISO End-to-End Tests

```bash
swift test --package-path macos
```

---

## Directory Layout (`macos/`)

```text
macos/
├── Package.swift                 # Swift 6 Package manifest (Tiny11Core + Tiny11BuilderApp + CHivex)
├── readmeformac.md               # Dedicated bilingual (CN/EN) documentation for macOS
├── README.md                     # Default GitHub directory README (synced with readmeformac.md)
├── Scripts/
│   ├── bootstrap-homebrew.sh     # Verifies/installs build dependencies (wimlib, cdrtools, hivex)
│   └── build-app.sh              # Builds Release binary, relocates dylibs, signs & packages .app / .dmg
├── Sources/
│   ├── CHivex/                   # C module map for libhivex
│   ├── Tiny11Core/               # Streaming build engine, WIM/ISO/Hive tools, models & 7-language i18n
│   └── Tiny11BuilderApp/         # Native SwiftUI desktop UI and ViewModel
└── Tests/
    └── Tiny11CoreTests/          # Unit tests and end-to-end synthetic ISO integration tests
```
