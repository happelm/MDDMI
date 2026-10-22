---
title: 'Lab 3.2 – Deploy a Win32 app'
lab:
    title: 'Lab 3.2 – Deploy a Win32 app'
    module: 'Day 3 – Windows apps, updates and Autopilot'
---

# Lab 3.2 – Deploy a Win32 app

**Estimated time:** 30 minutes

**Goal:** Deploy CMTrace as a required Win32 app and follow the install on CL3 in the Intune Management Extension log.

1. Intune admin center → Apps → Windows → Create → **Windows app (Win32)**. Select the package `C:\Scripts\cmtrace.intunewin`. It already contains `cmtraceinstall.ps1` and `cmtraceremove.ps1`, so you don't need to package anything.
2. App information: name `CMTrace`, version `5.0`, logo `ETCLogoTransparent.png` from `C:\Scripts`. Fill in the other required fields as you like.
3. Program and detection:

   | Setting | Value |
   |---|---|
   | Install command | `PowerShell.exe -executionpolicy Bypass -file "cmtraceinstall.ps1"` |
   | Uninstall command | `PowerShell.exe -executionpolicy Bypass -file "cmtraceremove.ps1"` |
   | Install behavior | System |
   | Detection rules | Manually configure: **File**, path `C:\Windows`, file or folder `CMTrace.exe`, detection method **File or folder exists** |

4. Assign it as **Required** to `All Windows 11 Devices`.
5. CL3: wait until CMTrace is installed (the Intune Management Extension checks for new Win32 apps every hour, a restart of CL3 is faster). Open `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\AppWorkload.log` with CMTrace and find download, install and detection of `CMTrace`.

### Checkpoint

- [ ] `C:\Windows\CMTrace.exe` exists on CL3
- [ ] `AppWorkload.log` shows the install and the detection of `CMTrace`
- [ ] The app shows **Installed** for CL3 in the Intune admin center

**Note:** The Intune Management Extension installs itself the first time a Win32 app or PowerShell script targets the user or device, so the first Win32 app takes longer.

**Why:** The detection rule decides whether Intune reports **Installed** – the exit code of the install command alone is not enough.

**Note:** Dependencies between apps exist only for Win32 apps (maximum 100 per app graph). Intune installs dependencies before the app, but in no fixed order among themselves.
<!-- Source: Michael's decisions 2026-10-21 12:43 (cmtrace.intunewin in C:\Scripts with both scripts, no packaging, no .txt; Required to All Windows 11 Devices, version 5.0, ETC logo, detection File C:\Windows CMTrace.exe exists, System). Learn: Win32 app management (IME, hourly check, 30 GB), Add a Win32 app – Dependencies (100, no order at a dependency level, Win32 only). -->
