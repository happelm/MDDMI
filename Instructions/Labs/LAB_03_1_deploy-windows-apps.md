---
title: 'Lab 3.1 – Deploy Windows apps'
lab:
    title: 'Lab 3.1 – Deploy Windows apps'
    module: 'Day 3 – Windows apps, updates and Autopilot'
---

# Lab 3.1 – Deploy Windows apps

**Estimated time:** 60 minutes

**Goal:** Check last night's scheduled restart, then add one app of each type – Microsoft Store, Microsoft 365 Apps, web link and line-of-business (MSI) – and assign them as required or available.

**Why:** Each app type has its own install path and its own limits. The trainer may split the apps between you and your neighbor.

## Before you start: check the scheduled restart

In Lab 2.6 you assigned `Win CO CS Daily Reboot` (Reboot CSP, daily at 18:00) to `All Windows 11 Devices`.

1. vLab host: open **Hyper-V Manager** and look at the **Uptime** column for CL1, CL2 and CL3. At 09:00 it should show about 15 hours.
2. If the uptime is shorter, Windows Update may have restarted the VM again during the night. CL3: open PowerShell and list the last restarts with process and reason:

   ```powershell
   Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='User32'; Id=1074} -MaxEvents 5 | Format-List TimeCreated, Message
   ```

   An entry at 18:00 is the Reboot CSP. Read the process and reason in **Message** for any other entry.

## Add the apps

All apps: Intune admin center → Apps → Windows → **Create**.

1. **Microsoft Store app (new)**: search for `Company Portal` and add it. Install behavior **System**. Assign it as **Required** to **All devices**.
2. **Microsoft Store app (new)**: add a second app of your choice. Assign it as **Available** to `Cloud Users`.
3. **Microsoft 365 Apps** → Windows 10 and later: suite `Microsoft 365 Apps`, configuration settings format **Configuration designer**:

   | Setting | Value |
   |---|---|
   | Apps | Word, Excel, PowerPoint (clear all others) |
   | Architecture | 64-bit |
   | Update channel | Monthly Enterprise Channel |

   Assign it as **Available** to `Cloud Users`.
4. **Windows web link**: name `ETC Homepage`, app URL `https://www.etc.at`. Assign it as **Required** to `All Windows 11 Devices`.
5. **Line-of-business app**: upload `C:\Scripts\intunepro.msi`. Assign it as **Available** to `Cloud Users`.
6. CL3 as User1: open the Company Portal and install the available apps.
7. Intune admin center → Devices → Windows → CL3: look at the app views of the device (managed apps and app inventory) and compare them with what you installed.

### Checkpoint

- [ ] Uptime of CL1–CL3 noted, Event 1074 at 18:00 found on CL3
- [ ] Company Portal and `ETC Homepage` arrive on CL3 without user action
- [ ] Store app, Microsoft 365 Apps and `intunepro.msi` installed on CL3 from the Company Portal
- [ ] `ETC Homepage` found in Start → **All** (not through search)

**Note:** The web link shows up in the **All** list of the Start menu. In class, the category view and Start search did not show it, so it looked as if it had not arrived.

**Note:** Apps assigned as **Available** need a user group – the user installs them from the Company Portal. **Required** apps install on their own, to users or devices.

**Why the Company Portal as Store app:** Windows doesn't bring the Company Portal with it. Deploying it as a required Store app makes it available for every user on the device.
<!-- Source: Day 3 recording 2026-10-21 (AM, PM 00:01) and Michael's decisions 2026-10-21 12:43 (all app types hands-on, split ad lib, intunepro.msi as LOB). Uptime check: Michael 2026-10-22; Event 1074/User32: Learn "Troubleshoot unexpected reboots using system event logs". The process names the Reboot CSP and Windows Update write into 1074 are not documented – add them after Michael sees them in class. VERIFY: exact names of the device app views (Managed apps / App inventory). -->
