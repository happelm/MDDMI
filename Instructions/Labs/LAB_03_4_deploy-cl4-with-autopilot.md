---
title: 'Lab 3.4 – Deploy CL4 with Windows Autopilot'
lab:
    title: 'Lab 3.4 – Deploy CL4 with Windows Autopilot'
    module: 'Day 3 – Windows apps, updates and Autopilot'
---

# Lab 3.4 – Deploy CL4 with Windows Autopilot

**Estimated time:** 75 minutes

**Goal:** Upload the hardware hash of CL4 from OOBE, assign a user-driven Entra join profile and deploy CL4 as User2.

## Upload the hardware hash

1. Hyper-V Manager: start CL4. At the first OOBE screen press **Shift+F10** and type `powershell`.
2. vLab host: open `C:\Scripts\GetAP.ps1` in Notepad and copy the lines. In CL4, run `notepad`, then use the Hyper-V menu **Clipboard → Type clipboard text** to paste them. Copy them from Notepad into PowerShell. The prompt must start with `PS`.

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
   Install-Script -Name Get-WindowsAutopilotInfoCommunity -Force
   $env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
   Get-WindowsAutopilotInfoCommunity -Online
   ```

3. Sign in with your tenant admin and accept the permission request for Microsoft Graph PowerShell. Wait for **1 device imported** (one to four minutes). If the sign-in times out, run the last command again.
4. Close PowerShell and **Turn off** CL4 in Hyper-V Manager. It stays in OOBE.

## Prepare the profile

5. Intune admin center → Devices → Enrollment → Windows → Windows Autopilot → **Devices**: refresh until CL4 shows up (manufacturer Microsoft Corporation, model Virtual Machine, with its serial number). Open it, set **Device name** to `CL4` and save.
6. Windows Autopilot → **Deployment profiles** → Create profile → Windows PC, name `Windows Autopilot POC`:

   | Setting | Value |
   |---|---|
   | Convert all targeted devices to Autopilot | No |
   | Deployment mode | User-Driven |
   | Join to Microsoft Entra ID as | Microsoft Entra joined |
   | Microsoft Software License Terms | Hide |
   | Privacy settings | Hide |
   | Hide change account options | Hide |
   | User account type | Standard |
   | Allow pre-provisioned deployment | No |
   | Language (Region) | German (Austria) |
   | Automatically configure keyboard | Yes |
   | Apply device name template | No |

   Don't assign it yet.
7. Entra admin center → Devices: the Autopilot object of CL4 (name = serial number, Microsoft Entra joined, no MDM) already exists. Groups → New group: security group `All Autopilot Devices`, membership type **Assigned**, member = this device.
8. `Windows Autopilot POC` → Assignments → include `All Autopilot Devices`. In Windows Autopilot → Devices, wait until the profile status of CL4 changes from **Not assigned** to **Assigned** (about 5 minutes). **Sync** doesn't speed this up.
9. Devices → Enrollment → Windows → **Enrollment Status Page** → **Default** (all users and all devices) → Properties → Settings → Edit:

   | Setting | Value |
   |---|---|
   | Show app and profile configuration progress | Yes |
   | Show an error when installation takes longer than specified number of minutes | 60 |
   | Install Windows quality updates (might restart the device) | No |
   | Block device use until all apps and profiles are installed | No |

## Deploy CL4

10. When the profile is **Assigned**, start CL4. Sign in as User2 and follow the Enrollment Status Page: device preparation, device setup, account setup. You can skip the Windows Hello prompt.
11. CL4: run `hostname` and check that the Intune Management Extension is in `C:\Program Files (x86)\Microsoft Intune Management Extension`.

### Checkpoint

- [ ] CL4 listed in Windows Autopilot devices with profile status **Assigned**
- [ ] OOBE skips region and keyboard and shows your company branding
- [ ] `hostname` on CL4 returns `CL4`
- [ ] Entra admin center: CL4 joined by User2, MDM **Microsoft Intune**
- [ ] Intune admin center: CL4 with ownership **Corporate**, OneDrive signed in on CL4

**Note:** The profile must be **Assigned** before CL4 starts OOBE. Otherwise CL4 runs a normal OOBE.

**Note:** The Company Portal and other apps assigned to `All Windows 11 Devices` can arrive after the first sign-in – the dynamic group needs time to pick up the new device.

**Note:** To upload hardware hashes you need **Intune Administrator** or **Policy and Profile Manager** (or a custom role with the Enrollment programs permissions), plus consent for Microsoft Graph PowerShell.

**Note:** Instead of an assigned group you can use a dynamic device group with all Autopilot devices:

```text
(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))
```

**Why Shift+F10 instead of audit mode:** You stay in OOBE, so CL4 needs no reset after the upload. In production you can turn Shift+F10 off in OOBE (see the Day 3 notes).
<!-- Source: Day 3 recording 2026-10-21 PM 01:17–02:52 and Michael's decisions 2026-10-22 (the four lines from GetAP.ps1, German (Austria)). Learn: Autopilot add-devices (roles, Graph PowerShell consent), create device groups (ZTDid rule), Enrollment Status Page. Community script Get-WindowsAutopilotInfoCommunity (PowerShell Gallery). VERIFY: exact ESP setting labels and Autopilot profile field labels in the current portal. -->
