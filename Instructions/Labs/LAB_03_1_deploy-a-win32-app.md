---
title: 'Lab 3.1 – Deploy a Win32 app'
lab:
    title: 'Lab 3.1 – Deploy a Win32 app'
    module: 'Day 3 – Windows apps and security'
---

# Lab 3.1 – Deploy a Win32 app

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Package CMTrace as Win32 app, deploy it from Intune and follow it in the Company Portal and the logs.

1. vLab host: create `C:\Source\CMTrace` and copy `cmtrace.exe`, `CmtraceInstall.ps1` and `CmtraceRemove.ps1` from `C:\Scripts` into it.
2. vLab host: download the Microsoft Win32 Content Prep Tool (`IntuneWinAppUtil.exe`) from GitHub and package the folder:

   ```powershell
   .\IntuneWinAppUtil.exe -c C:\Source\CMTrace -s CmtraceInstall.ps1 -o C:\Source\Output
   ```

3. Intune admin center → Apps → Windows → Create → **Windows app (Win32)**: app `CMTrace` from `CmtraceInstall.intunewin` with these settings, assigned as **Available** to `Cloud Users`:

   | Setting | Value |
   |---|---|
   | Install command | `PowerShell.exe -ExecutionPolicy Bypass -File "CmtraceInstall.ps1"` |
   | Uninstall command | `PowerShell.exe -ExecutionPolicy Bypass -File "CmtraceRemove.ps1"` |
   | Install behavior | System |
   | Detection rule | File: `C:\Windows`, file or folder `CMTrace.exe`, file or folder exists |

4. Apps → Windows → Create → **Microsoft Store app (new)**: add an app of your choice and assign it as **Available** to `Cloud Users`.
5. CL3 as User1: open the Company Portal and install both apps.
6. CL3: open `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\AppWorkload.log` with CMTrace and find download, install and detection of `CMTrace`.

### Checkpoint

- [ ] `CmtraceInstall.intunewin` created
- [ ] Both apps installed on CL3 from the Company Portal
- [ ] Portal shows **Installed** for CMTrace on CL3

**Note:** The Intune Management Extension installs itself the first time a Win32 app, script or remediation targets the device or user – the first install takes longer.

**Why:** The detection rule decides **Installed** – not the exit code alone.
<!-- 2026-10-20 Michael: lab files currently via bit.ly share to C:\Scripts, later as ZIP from this repo. C:\Scripts is always on the vLab host, so packaging and upload happen there. cmtrace.exe stays out of the public repo. -->
<!-- VERIFY: Company Portal install – auto-installed in pod or part of this lab (handbook: "Installation des Company Portals")? -->
