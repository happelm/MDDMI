---
title: 'Lab 3.2 – Deploy CL4 with Windows Autopilot'
lab:
    title: 'Lab 3.2 – Deploy CL4 with Windows Autopilot'
    module: 'Day 3 – Windows apps and security'
---

# Lab 3.2 – Deploy CL4 with Windows Autopilot

**Estimated time:** 60 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Register CL4 for Windows Autopilot, assign a user-driven Entra join profile and watch the deployment with the Enrollment Status Page.

1. CL4 starts at OOBE. Press `Ctrl+Shift+F3` – Windows restarts in audit mode.
2. CL4: open an elevated PowerShell and upload the hardware hash to your tenant. Sign in with your tenant admin and accept the permission request:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
   ```

   ```powershell
   Install-Script -Name Get-WindowsAutopilotInfo -Force
   ```

   ```powershell
   $env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
   ```

   ```powershell
   Get-WindowsAutopilotInfo -Online
   ```

3. Intune admin center → Devices → Enrollment → Windows → Windows Autopilot → Devices: wait until CL4 is listed.
4. Entra admin center → Groups: create an assigned security group `Autopilot Devices` and add the CL4 device object (its name is the serial number).
5. Intune admin center → Devices → Enrollment → Windows → Windows Autopilot → Deployment profiles → Create profile → Windows PC: profile `User-driven Entra join`, mode **User-Driven**, join to **Microsoft Entra joined**, assigned to `Autopilot Devices`.
6. Devices → Enrollment → Windows → Enrollment Status Page: look at the default profile. Create a profile `ESP Lab` with **Show app and profile configuration progress** = Yes and **Block device use until all apps and profiles are installed** = Yes, assigned to `Autopilot Devices`.
7. Wait until the Autopilot device shows the profile status **Assigned**. CL4: shut down without generalizing:

   ```cmd
   C:\Windows\System32\Sysprep\sysprep.exe /oobe /shutdown
   ```

8. Start CL4 and sign in as User2. Watch the Enrollment Status Page.

### Checkpoint

- [ ] CL4 listed in Windows Autopilot devices with profile status **Assigned**
- [ ] OOBE shows your company branding and asks only for the work account
- [ ] ESP finished without error on CL4
- [ ] CL4 is listed in Intune admin center → Devices → Windows with User2

**Note:** The profile must be **Assigned** before CL4 starts OOBE – otherwise the device runs a normal OOBE. Group membership and profile assignment can take several minutes.

**Why:** Windows Autopilot device preparation (Autopilot v2) works without hardware hash registration – the trainer shows the differences.
<!-- VERIFY: Get-WindowsAutopilotInfo current version / -Online needs Microsoft Graph modules and admin consent on first run; test in the pod before class. -->
<!-- VERIFY: ESP only tracks Required apps; if Michael wants CMTrace in the ESP, assign it Required to Autopilot Devices. -->
<!-- VERIFY: Autopilot device object name in Entra (serial number) in Hyper-V. -->
