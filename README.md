[中文](README_zh.md)

# OpenBachelorC-M for Termux User Manual

## Overview

This manual provides guidance on deploying and running the OpenBachelorC-M automation tool within the Termux environment on Android devices. This tool is a modified and ported version of [OpenBachelorC](https://github.com/pfyy/OpenBachelorC).

## Prerequisites

- **Android Device**: System version Android 11 or higher.
- **Termux Application**: Download and install from [F-Droid](https://f-droid.org/en/packages/com.termux/). **Do not use the outdated version from the Play Store**.
- **Patched PvZ Online APK**: Prepare the modified game client. [OpenBachelorG](https://github.com/pfyy/OpenBachelorG)
- **OpenBachelorC-M Project Files**: Obtain the complete `OpenBachelorC-M` folder.
- **Backup File** (Optional): `backup.tar.xz`, containing a pre-configured Termux environment. **Note: Restoring this backup will completely overwrite your current Termux environment. Use with caution. It is strongly recommended to use the manual configuration method below for better compatibility and control.**

---

## Phase One: Preparation

### 1. Install Termux and the Game

Install Termux from F-Droid, and install the patched PvZ Online APK file.

### 2. Place Necessary Files

- Place the `OpenBachelorC-M` folder into the `Download` directory of the device's internal storage:

  ```
  Internal Storage/Download/OpenBachelorC-M/
  ```

- (Optional) If you wish to use the backup restore method, place the `backup.tar.xz` file in the root directory of your phone's internal storage:

  ```
  Internal Storage/backup.tar.xz
  ```

### 3. Configure Server Address

Use a text editor to open the following file:

```
Internal Storage/Download/OpenBachelorC-M/conf/config.json
```

Locate the `"host"` field and modify it to your automation server's IP address:

```json
{
  "host": "127.0.0.1", // Change to your server address
  ...
}
```

Save and close the file.

---

## Phase Two: Termux Environment Deployment

### Recommended Method: Manual Configuration (Using setup.sh)

This method will download and compile the necessary components on your device in real-time, ensuring perfect compatibility with your system architecture. It will not overwrite any of your existing custom settings. Future updates and maintenance are also more convenient with this approach.

1. **Open Termux and Grant Storage Permission**  
   After opening Termux for the first time, execute:
   ```bash
   termux-setup-storage
   ```

2. **Run the One-Click Setup Script**  
   Navigate to the project directory and run `setup.sh`:
   ```bash
   cd ~/storage/downloads/OpenBachelorC-M
   bash setup.sh
   ```
   This script will automatically:
   - Update the package list
   - Install necessary tools
   - Install required Python modules (via pip)
   - Compile and install Frida tools

   Wait for the script to complete execution. The environment setup is now finished.

### Alternative Method: Using Backup Restore (Fast but May Overwrite Data)

If you prefer to skip manual configuration, you can use the provided backup file. However, please note:

- **Restoring the backup will completely overwrite Termux's `$PREFIX` directory, losing all previously installed packages and user data. The environment will be reverted to the state at the time of backup.**
- Due to device differences, there is no guarantee that all components in the restored environment will function correctly.

If you still decide to use this method, follow these steps:

1. **Open Termux and Grant Storage Permission** (same as above)
2. **Restore the Backup Environment**:
   ```bash
   termux-restore /sdcard/backup.tar.xz
   ```

   This process may take some time; please wait for it to complete.

---

## Phase Three: Starting Automation

### Scenario 1: Rooted Device (With Root Privileges)

1. Obtain root privileges:

   ```bash
   su
   ```

2. Restart the Termux application.
3. Automatic startup process:
   - Upon startup, Termux will automatically execute the `~/storage/downloads/OpenBachelorC-M/start.sh` script.
   - The first run may require granting ADB debugging permissions; select "Always Allow."

### Scenario 2: Non-Rooted Device (Without Root Privileges)

Requires using the built-in "Wireless Debugging" feature available in Android 11 and above.

1. **Edit the Login Script**:

   ```bash
   nano $PREFIX/etc/termux-login.sh
   ```

   Comment out the automatic startup command (add `#` at the beginning of the line):

   ```bash
   # sh ~/storage/downloads/OpenBachelorC-M/start.sh
   ```

   Press `Ctrl+X`, then enter `Y` to save and exit.

2. **Manual Operation Process for Each Startup**:

   - Keep Termux in split-screen or small window mode.
   - Enable Wireless Debugging in the Developer Options.
   - Pair the device using a pairing code:

     ```bash
     adb pair localhost:[Pairing Port]
     ```

     Enter the displayed six-digit pairing code.

   - Connect the device:

     ```bash
     adb connect localhost:[Connection Port]
     ```

   - Run the main script:

     ```bash
     cd ~/storage/downloads/OpenBachelorC-M/
     sh main.sh
     ```

---

## Frequently Asked Questions (Q&A)

**Q: Script execution fails with the error `adb: no devices/emulators found`?**

- **A:** ADB is not connected to the device.
  - Root users: Check if SU permissions and ADB debugging authorization have been granted.
  - Non-root users: Re-pair and reconnect using Wireless Debugging.

**Q: Python module not found error (e.g., `No module named 'xxx'`)?**

- **A:** The backup restoration was not performed correctly. Please re-execute `termux-restore /sdcard/backup.tar.xz`.

**Q: How to stop a running script?**

- **A:** After exiting the PvZ Online game, press `Ctrl+D` in Termux to interrupt the script.

**Q: Do non-root users need to perform manual operations every time?**

- **A:** Yes. The pairing code and port for Wireless Debugging become invalid after a device restart or toggling the Wireless Debugging switch, requiring re-pairing. Consider using Android automation apps (e.g., "Tasker" or "MacroDroid") to simplify the process.

**Q: What is the difference between using `setup.sh` and the backup restore?**

- **A:** `setup.sh` downloads and compiles the necessary components on your device in real-time, offering better compatibility and making future updates easier. The backup restore directly extracts a pre-configured environment, which is faster, but may lead to some components not working correctly due to device differences. **Crucially, it will completely overwrite your current Termux environment. Therefore, using `setup.sh` is strongly recommended.**