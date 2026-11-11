# Tiny11 Builder for Mac (Apple Silicon)

原生 **macOS ARM64 (`M1` / `M2` / `M3` / `M4`)** 桌面应用，无需启动 Windows 虚拟机、无需 `sudo` 管理员密码、无需 NTFS 分区，即可在本地将微软官方 **Windows 11 ARM64 / x64 ISO** 流式精简并重新打包为干净轻量的可引导 `.iso` 镜像，直接用于 **Parallels Desktop、VMware Fusion、UTM** 或 PC 装机。

---

## 核心特性

1. **纯用户态流式引擎（零宿主机污染）**
   - **`hdiutil` 只读挂载**：安全读取官方 ISO（即使已在 Finder 中挂载也会无感复用），源镜像绝不修改。
   - **`wimlib` 直接归档修改**：无需把 15GB 系统解压到磁盘（避免 macOS APFS 大小写不敏感文件名冲突与 Windows ACL 丢失），直接在 `.wim` 归档流中完成单版本导出、臃肿组件剔除与多核 `LZMS` 固态压缩（生成高压缩比 `install.esd`）。
   - **`libhivex` (`CHivex`) 离线注册表二进制编辑**：C 语言直连读写离线 `SOFTWARE`、`SYSTEM`、`NTUSER.DAT` Hive 文件，写入硬件绕过策略、`Deprovisioned` 防重装锁与隐私策略。
   - **`mkisofs` (`cdrtools`) 双架构可引导封装**：原生合成支持 `> 4 GiB` 大文件的 `UDF + ISO9660 Level 3` 镜像，完整支持 **ARM64 纯 UEFI (`0xEF`)** 与 **x64 Legacy BIOS + UEFI 混合引导**。

2. **专为 Mac 虚拟机调优的内置预设（`Tiny11 · Mac 虚拟机优化版`）**
   - **硬件限制全绕过**：在 `boot.wim` 与安装应答中同时注入 TPM 2.0、SecureBoot、8GB 内存限制绕过。
   - **OOBE 无网卡防死锁（`BypassNRO` + 本地离线账户直通）**：彻底解决 UTM / VMware Fusion 初装缺少 VirtIO 或 `vmxnet3` 网卡驱动时卡死在“让我们为你连接到网络”界面的痛点。
   - **立省 ~7GB 虚拟磁盘占用**：自动关闭 Windows 11 预留空间（`ShippedWithReserves=0`）与自动设备加密（`PreventDeviceEncryption=1`），默认开启 `CompactOS` 透明压缩部署。
   - **完整保留虚拟机工具兼容性**：移除 20+ 款预装臃肿 UWP 应用（Clipchamp、News、Teams、Copilot、Xbox、Solitaire、OneDrive 等）及广告遥测，同时默认保留 `WebView2`、Windows Update 与安装服务，确保 **Parallels Tools / VMware Tools / SPICE Guest Tools** 一键顺畅安装。

3. **多语言国际化（i18n）与标准版灵活定制**
   - **6 国语言自适应**：内置 **中文、英文、法文、西班牙文、俄文、阿拉伯文（含原生 RTL 从右向左镜像布局）** 六种语言，自动跟随 macOS 系统首选语言，若系统为其他语言则统一回退显示英文（亦支持在 macOS「系统设置 → 通用 → 语言与地区 → 应用程序」中单独指定语言，或通过环境变量 `TINY11_LANG=en|zh|fr|es|ru|ar` 预览）。
   - **标准版可选是否精简 Edge**：在 **「Tiny11 · 标准精简版」** 卡片与定制页均提供独立的 **精简 Microsoft Edge** 开关，可按需选择彻底移除 Edge/WebView2 或完整保留其运行库兼容性，无需被迫退化为纯手动勾选模式。

4. **开箱即用自包含 `.app` 应用包**
   - 打包产出的 `Tiny11Builder.app` 已将 `wimlib-imagex`、`mkisofs`、`libwim`、`libhivex`、`libintl` 内嵌并完成 `@executable_path` / `@loader_path` 动态库重定位与代码签名，拷贝到任意 Apple Silicon Mac 双击即可运行，无需用户手动安装命令行工具。

---

## 快速使用流程

1. 打开 `macos/dist/Tiny11Builder.app`（或安装 `Tiny11Builder-macOS-arm64.dmg`）。
2. **第 1 步 · 构建模式**：日常使用 Parallels Desktop / VMware Fusion / UTM 推荐选择 **「Tiny11 · Mac 虚拟机优化版」**；PC 装机可选标准版或自定义勾选。
3. **第 2 步 · 导入镜像**：将本地准备好的官方 Windows 11 `.iso`（支持 22H2 / 23H2 / 24H2 / 25H2 及更新版本的 ARM64 或 x64 镜像）拖入窗口，选择要提取的目标 SKU（如 `Windows 11 Pro`）。
4. **第 3–4 步 · 定制与参数**：按需微调移除清单、压缩等级（`Recovery ESD` 体积最小，`Fast WIM` 打包最快）及输出 ISO 路径。
5. **第 5–6 步 · 复核与构建**：点击 **「开始制作精简版 ISO」**，实时查看八阶段进度与滚动日志；完成后一键在 Finder 中定位生成的 `.iso` 并校验 `SHA-256`。

---

## 本地编译、测试与打包

### 环境要求
- Apple Silicon Mac（`arm64`，macOS 14.0 Sonoma 或更高版本）
- Xcode 16+ / Swift 6 工具链
- Homebrew（仅开发机编译打包时需要，最终用户运行 `.app` 不需要）

### 一键构建自包含 `.app` 与 `.dmg`

```bash
./macos/Scripts/build-app.sh
```

打包完成后产物位于：
- 应用包：`macos/dist/Tiny11Builder.app`
- 安装盘镜像：`macos/dist/Tiny11Builder-macOS-arm64.dmg`

### 运行单元与全链路合成 ISO 集成测试

```bash
swift test --package-path macos
```
