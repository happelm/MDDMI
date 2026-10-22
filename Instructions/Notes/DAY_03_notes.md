---
title: 'Day 3 notes – Windows apps, updates and Autopilot'
---

# Day 3 notes – Windows apps, updates and Autopilot

> Summary of what was covered on Day 3, with sources – not a transcript. Recommendations marked "trainer recommendation" are field experience, not Microsoft documentation. Links marked "community" point to non-Microsoft sources.

## Key takeaways

- Every Windows app type has its own path: Microsoft Store (new), Microsoft 365 Apps, web link, MSI line-of-business and Win32. Win32 is the most flexible one and runs through the Intune Management Extension.
- **Required** installs on its own, **Available** waits for the user in the Company Portal and needs a user group.
- A Win32 app counts as installed only when its detection rule says so.
- Update rings control when and how updates install, feature update policies control the Windows version, driver update policies control drivers.
- Deadline and grace period are two separate clocks. The later one decides when Windows forces the restart.
- Hotpatch is on by default for eligible devices. Don't opt out without a reason.
- Windows Autopilot needs the hardware hash in your tenant and an assigned profile **before** the device starts OOBE.
- **Retire** is not meant for corporate Entra joined Windows devices. Use Wipe, Fresh Start or Autopilot reset instead.

## 1. Windows apps

- **Microsoft Store app (new)** installs Store apps through the Windows Package Manager; you can choose user or system context. The Company Portal is deployed this way.
- **Microsoft 365 Apps** use the configuration designer or an XML file. You choose apps, architecture and update channel.
- A **Windows web link** shows up in the **All** list of the Start menu. Start search and the category view may not show it.
- **Win32 apps** (`.intunewin`) are at most 30 GB per app. The Intune Management Extension (IME) installs them. It installs itself when the first Win32 app or PowerShell script targets the user or device, and it checks for new Win32 apps every hour and at service or device restart.
- **Dependencies** exist only between Win32 apps. An app graph holds at most 100 dependencies. Dependencies install before the app, but in no fixed order among themselves. Each dependency follows the Win32 retry logic (three tries, five minutes apart).
- **Remediations** (demo only) need the Windows license verification in Tenant administration → Connectors and tokens → Windows data. Scripting and remediations are covered in MDDMI-Adv and the troubleshooting course.
- App configuration and app protection for Windows apply only to Microsoft Edge.

Sources: [Win32 app management](https://learn.microsoft.com/intune/app-management/deployment/win32) · [Add a Win32 app – dependencies](https://learn.microsoft.com/intune/app-management/deployment/add-win32#step-5-dependencies) · [Windows app types](https://learn.microsoft.com/intune/app-management/deployment/deploy-windows#supported-windows-app-types) · [Windows data and license verification](https://learn.microsoft.com/intune/privacy/enable-windows-diagnostic-data)

### Single sign-on prompt in the EEA

In the European Economic Area, Windows asks users once whether their Windows account may sign them in to other Microsoft apps. On managed Windows 11 24H2 and 25H2 devices with the July 2026 security update, admins can accept this automatically with the registry value `AutoAcceptSsoPermission` (DWORD) = `1`. Use the path `HKLM\SOFTWARE\Policies\Microsoft\Windows\AAD` from the article text – it worked in the trainer's lab. The screenshot in the article shows `HKLM\SOFTWARE\Policies\Microsoft\AAD`.

Source: [Admin control for SSO prompts in Windows](https://learn.microsoft.com/entra/identity/devices/sso-admin-control)

## 2. Windows Update

### Three policy types

- **Update rings** set deferral, automatic update behavior, deadlines, grace period and restart behavior.
- **Feature update policies** pin a device to a Windows version or move it to a newer one, and keep it from going further. Set the feature update deferral in the ring to 0 when you use them.
- **Driver update policies** decide whether recommended drivers are approved automatically or manually.
- Pause stops a ring for up to 35 days. Uninstall removes only the latest update and works from a paused ring.
- Don't combine Windows Update settings from Group Policy with update rings on the same device.

### Deadlines in plain words

There are two clocks:

1. **Deadline:** starts when the device **finds** the update in its scan. That's the release date plus the deferral, not the release date itself.
2. **Grace period:** starts when the update is installed and a **restart is pending**.

Windows forces the restart when **both** clocks have run out – so whichever ends **later** wins. After that, the restart happens even during active hours, the user gets a 15-minute notice and can't move it.

Two examples with deadline 2 days and grace 2 days:

- **Device online:** it finds the update Tuesday 10:00, installs right away, restart pending from Tuesday 11:00. Deadline clock ends Thursday 10:00, grace clock Thursday 11:00 → forced restart **Thursday 11:00**.
- **Device off after the scan:** it finds the update Tuesday 10:00, but the user shuts it down before the install and comes back from vacation the next Monday. The deadline clock ended Thursday 10:00. The device installs Monday morning, restart pending from Monday 09:00, so the grace clock gives the user until **Wednesday 09:00**. Without a grace period, the restart would be forced right after the install.

More rules:

- Once a deadline is set, the device downloads and installs the update **as soon as it is offered**. The **Automatic update behavior** of the ring applies until the deadline and is ignored after it.
- **Auto reboot before deadline = Yes** (recommended): Windows restarts outside active hours before the deadline. **No**: Windows waits until the deadline and then restarts, even during active hours.
- Microsoft recommends a quality update deadline of **1** day, a feature update deadline of **2** days, a grace period of 2 days for quality and 7 days for feature updates, and no more than **7 days** from release to install (deferral + deadline + grace).
- The Intune documentation lists a deadline range of 2–30 days. The portal saved **1** in class, and the Windows Update CSP allows 0–30.
- Maintenance windows (Windows 11 24H2 and later): use either maintenance windows or deadlines, not both. An expired deadline wins.

### Hotpatch, expedite and reports

- **Hotpatch** installs monthly security updates without a restart. It is on by default for eligible devices and needs virtualization-based security (VBS) running. You change the default in Tenant administration → Windows Autopatch → Tenant management → **Tenant settings**.
- **Expedite** policies push an urgent quality update faster than the ring allows.
- **Windows quality update policy** (Devices → Windows updates → Quality updates → Create): since the rollout of September to October 2026, it approves monthly security updates, preview updates, out-of-band updates and .NET Framework updates automatically or manually, with its own deferral of 0–30 days. Before, it only held the hotpatch setting. Its deferral overrides the deferral of the update ring. Deadlines and grace period still come from the ring. A device in such a policy only gets the updates that are approved there.
- Several Windows update reports and alerts need **Windows diagnostic data** turned on in Tenant administration → Connectors and tokens → Windows data.

Sources: [Enforce compliance deadlines](https://learn.microsoft.com/windows/deployment/update/wufb-compliancedeadlines) · [Policies for update compliance](https://learn.microsoft.com/windows/deployment/update/update-policies) · [Update ring settings](https://learn.microsoft.com/intune/device-updates/windows/ref-update-ring-settings) · [Policy CSP – Update](https://learn.microsoft.com/windows/client-management/mdm/policy-csp-update) · [Manage update rings](https://learn.microsoft.com/intune/device-updates/windows/manage-update-rings) · [Manage feature updates](https://learn.microsoft.com/intune/device-updates/windows/manage-feature-updates) · [Hotpatch](https://learn.microsoft.com/intune/device-updates/windows/configure-hotpatch) · [Windows quality updates and .NET Framework updates](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-windows-quality-update-overview) · [Windows message center, 2026-09-01](https://learn.microsoft.com/windows/release-health/windows-message-center) · [Windows diagnostic data](https://learn.microsoft.com/intune/privacy/enable-windows-diagnostic-data)

## 3. Windows Autopilot

- To upload hardware hashes you need **Intune Administrator** or **Policy and Profile Manager** (or a custom role with the Enrollment programs permissions), plus consent for Microsoft Graph PowerShell.
- The profile must show **Assigned** before the device starts OOBE. Assignment takes a few minutes; **Sync** doesn't speed it up.
- A dynamic group for all Autopilot devices uses the rule `(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))`.
- Hybrid join with Autopilot needs the Intune Connector for Active Directory. *Trainer recommendation:* use Entra join.
- **Shift+F10** opens a command prompt in OOBE. You can turn it off with the empty file `DisableCMDRequest.TAG` in `C:\Windows\Setup\Scripts`, for example in the image. A reset deletes the file, so recreate it with a provisioning package. Windows in S mode has it off by default. (Community: [Michael Niehaus, oofhours.com](https://oofhours.com/2020/08/04/disable-shift-f10-in-oobe/))

Sources: [Add devices to Windows Autopilot](https://learn.microsoft.com/autopilot/add-devices) · [Create device groups](https://learn.microsoft.com/autopilot/enrollment-autopilot) · [Enrollment Status Page](https://learn.microsoft.com/intune/device-enrollment/windows/setup-status-page)

## 4. Device actions

- **Wipe** resets the device, optionally keeping user data. **Fresh Start** removes the apps the OEM installed and can keep user data.
- **Autopilot reset** works only for Entra joined devices. It removes personal files, apps and settings and keeps the device registered in Entra ID and Intune – use it to hand a device to the next user.
- **Retire** on an Entra joined Windows device: the portal says *"Retiring a device isn't supported for Entra-joined Windows devices"*. Learn warns that retire and delete remove the BitLocker key protectors, so back up the BitLocker recovery key and the LAPS password first. After a retire, nobody can sign in with an Entra account.
- **Delete** removes the device from Intune, removes company data and retires it – the same BitLocker and LAPS warning applies.
- **Device cleanup rules** hide devices that haven't checked in for a set time. They don't look at compliance.

Source: [Retire a device](https://learn.microsoft.com/intune/device-management/actions/retire?pivots=windows)

## To do before Day 4

> Create a new Google account (@gmail.com) at home, if you haven't already. You need it to connect your tenant to Managed Google Play. Create it outside the classroom – Google blocks many sign-ups from one network.
