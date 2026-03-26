# OpenBachelorC-M for Termux 使用手册

## 概述

本手册旨在指导您在 Android 设备上的 Termux 环境中部署和运行 OpenBachelorC-M 自动化工具。该工具是 [OpenBachelorC](https://github.com/pfyy/OpenBachelorC) 的修改与移植版本。

## 前提条件

- **Android 设备**：系统版本为 Android 11 或更高。
- **Termux 应用**：从 [F-Droid](https://f-droid.org/en/packages/com.termux/) 下载安装，**请勿使用已停止更新的 Play Store 版本**。
- **修补后的 PvZ Online APK**：准备好修改版游戏客户端。[OpenBachelorG](https://github.com/pfyy/OpenBachelorG)
- **OpenBachelorC-M 项目文件**：获取完整的 `OpenBachelorC-M` 文件夹。
- **备份文件**（可选）：`backup.tar.xz`，包含预配置的 Termux 环境。**注意：恢复备份会完全覆盖您当前的 Termux 环境，请谨慎使用。强烈推荐使用下面的手动配置方式，以获得最佳兼容性和可控性。**

---

## 第一阶段：准备工作

### 1. 安装 Termux 与游戏

从 F-Droid 安装 Termux，并安装修补后的 PvZ Online APK 文件。

### 2. 放置必要文件

- 将 `OpenBachelorC-M` 文件夹放置到手机内部存储的 `Download` 目录：

  ```
  内部存储/Download/OpenBachelorC-M/
  ```

- （可选）如果希望使用备份恢复，将 `backup.tar.xz` 文件放置到手机内部存储的根目录：

  ```
  内部存储/backup.tar.xz
  ```

### 3. 配置离线模式（可选）

如果您希望使用 **离线模式** 在手机本地运行服务器：
1. 下载 [OpenBachelorS](https://github.com/pfyy/OpenBachelorS)。
2. 将解压后的文件夹放入 `Download` 目录并重命名为 `OpenBachelorS`。
   ```
   内部存储/Download/OpenBachelorS/
   ```
3. 将 `OpenBachelorC-M/termux/obs/` 目录下的所有文件复制到 `OpenBachelorS/` 目录中。
4. （在 Termux 中）进入该目录并运行初始化脚本：
   ```bash
   cd ~/storage/downloads/OpenBachelorS/
   sh setup.sh
   ```

### 4. 配置服务器地址

**方法一：自动配置（适用于 Root 用户）**
使用 `start.sh` 启动（Root 用户默认方式）时，脚本会自动配置：
- **离线模式**：自动设置为 `127.0.0.1`。
- **在线模式**：默认为 `10.0.0.1`。

如需更改在线模式的默认 IP：
1. 编辑 `start.sh`。
2. 修改 `HOST="10.0.0.1"` 为您的服务器 IP。

**方法二：手动配置（适用于非 Root 用户）**
如果您手动启动脚本（如 `sh main.sh`）而不使用 `start.sh`：
1. 打开 `conf/config.json`。
2. 找到 `"host"` 字段。
3. 修改为您服务器的 IP 地址（本地服务器请填 `127.0.0.1`）。

---

## 第二阶段：Termux 环境部署

### 推荐方式：手动配置（使用 setup.sh）

此方式将在您的设备上实时下载并编译所需组件，确保与您的系统架构完美兼容，并且不会覆盖您已有的任何自定义设置。后续更新维护也更加方便。

1. **打开 Termux 并授予存储权限**  
   首次打开 Termux 后，执行：
   ```bash
   termux-setup-storage
   ```

2. **执行一键配置脚本**  
   进入项目目录并运行 `setup.sh`：
   ```bash
   cd ~/storage/downloads/OpenBachelorC-M
   bash setup.sh
   ```
   该脚本将自动：
   - 更新软件包列表
   - 安装必要工具
   - 安装所需的 Python 模块（通过 pip）
   - 编译并安装 Frida 工具

   等待脚本执行完成，环境即部署完毕。

### 备选方式：使用备份恢复（快速但可能覆盖数据）

如果您希望跳过手动配置，可以使用我们提供的备份文件。但请注意：

- **恢复备份将完全覆盖 Termux 的 `$PREFIX` 目录，丢失所有之前安装的软件包和用户数据，环境将回滚到备份时的状态。**
- 由于设备差异，恢复的环境可能无法保证所有组件都能正常工作。

如果您仍决定使用此方法，请按以下步骤操作：

1. **打开 Termux 并授予存储权限**（同上）
2. **恢复备份环境**：
   ```bash
   termux-restore /sdcard/backup.tar.xz
   ```
   此过程需要一些时间，请等待完成。

---

## 第三阶段：启动自动化

### 情况一：设备已 Root（拥有 Root 权限）

1. 获取 Root 权限：

   ```bash
   su
   ```

2. 重启 Termux 应用
3. 自动启动流程：
   - Termux 启动时会自动执行 `~/storage/downloads/OpenBachelorC-M/start.sh` 脚本
   - **选择运行模式**：
     - 如果检测到服务端组件 (`OpenBachelorS`)，将显示选择菜单：
       - `O` (Online)：在线模式，连接到远程服务器（默认 `10.0.0.1` 或 `start.sh` 中配置的地址）。
       - `F` (Offline)：离线模式，启动本地服务器并连接到 `127.0.0.1`。
       - `N` (Exit)：退出。
     - 如果仅有客户端：
       - `Y` (Yes)：连接到远程服务器。
       - `N` (No)：退出。
   - 首次运行时可能需要授权 ADB 调试权限，请选择「总是允许」

### 情况二：设备未 Root（无 Root 权限）

需要使用 Android 11 及以上系统自带的「无线调试」功能。

1. **编辑登录脚本**（禁用自动启动）：

   ```bash
   nano $PREFIX/etc/termux-login.sh
   ```

   注释掉自动启动命令（在行首添加 `#`）：

   ```bash
   # sh ~/storage/downloads/OpenBachelorC-M/start.sh
   ```

   按 `Ctrl+X`，输入 `Y` 保存退出。

2. **每次启动的手动操作流程**：

   - 保持 Termux 在分屏或小窗模式
   - 开启开发者选项中的无线调试功能
   - 使用配对码配对设备：

     ```bash
     adb pair localhost:[配对端口]
     ```

     输入显示的六位配对码

   - 连接设备：

     ```bash
     adb connect localhost:[连接端口]
     ```

   - 运行主脚本：

     ```bash
     cd ~/storage/downloads/OpenBachelorC-M/
     sh main.sh
     ```

---

## 常见问题解答 (Q&A)

**Q: 脚本执行失败，提示 `adb: no devices/emulators found`？**

- **A:** ADB 未连接到设备。
  - Root 用户：检查是否授予了 SU 权限和 ADB 调试授权
  - 非 Root 用户：重新进行无线调试的配对和连接

**Q: 提示 Python 模块未找到（如 `No module named 'xxx'`）？**

- **A:** 如果是手动配置，请确认 `setup.sh` 是否完整执行且无报错；如果是备份恢复，请重新执行 `termux-restore /sdcard/backup.tar.xz`（注意会覆盖数据）

**Q: 如何停止正在运行的脚本？**

- **A:** 退出 PvZ Online 游戏后，在 Termux 中按 `Ctrl+D` 组合键中断脚本运行

**Q: 非 Root 用户每次都要手动操作吗？**

- **A:** 是的。无线调试的配对码和端口在手机重启或无线调试开关重启后会失效，需要重新配对。可以考虑使用 Android 自动化应用（如「Tasker」或「MacroDroid」）来简化流程。

**Q: 使用 `setup.sh` 和备份恢复有什么区别？**

- **A:** `setup.sh` 会在您的设备上实时下载并编译所需组件，兼容性更好，也便于后续更新；备份恢复则是直接解压一个预先配置好的环境，速度更快，但可能因设备差异导致部分组件无法正常工作，**且会完全覆盖您当前的 Termux 环境**。因此，**强烈推荐优先使用 `setup.sh`。**