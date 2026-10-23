---
title: 'Day 2 notes – Windows management'
---

# Day 2 notes – Windows management

> Summary of what was covered on Day 2, with sources – not a transcript. Recommendations marked "trainer recommendation" are field experience, not Microsoft documentation. Links marked "community" point to non-Microsoft projects.

## Key takeaways

- Registration (Entra ID) and enrollment (Intune) are two different things – the device lists don't have to match.
- Enrollment restrictions control how many devices a user may enroll and which platforms and versions may enroll at all. GPO, co-management and Autopilot enrollments don't count against the device limit.
- Intune roles plus scope groups and scope tags limit admins to part of the devices; Entra roles work on the whole tenant.
- The MDM user scope decides who enrolls automatically. An Entra joined device gets single sign-on to cloud and on-premises resources through the PRT.
- Keep personal Windows devices out of Intune: turn on **Disable MDM enrollment when adding work or school account** in production.
- Hybrid join runs in steps: SCP, `userCertificate`, sync, registration, MDM enrollment. `dsregcmd /status` and the two event logs show where it stops.
- Co-management needs workloads moved to Intune – until then, Intune policies don't reach ConfigMgr clients.
- Settings catalog first, template second, custom OMA-URI last. Use assignment filters to narrow assignments by device properties.
- Don't migrate GPOs 1:1 – use Group Policy analytics to decide what you still need.

## 1. Registration, enrollment and ownership

- **Registration** puts a device object into Microsoft Entra ID. **Enrollment** puts the device into Intune management. A device can be registered without being enrolled, so the device lists in Entra ID and in Intune don't have to match.
- Every enrolled device is either **Corporate** or **Personal**. Ownership decides what Intune may see and do (for example, the full app inventory or a wipe), and you can use it in assignment filters. You can change it later in the device properties.
- On Windows, the Company Portal isn't needed for enrollment. An Entra join with automatic enrollment, GPO auto-enrollment or Windows Autopilot enrolls the device without it. You still need the Company Portal to install **Available** apps.
- The Intune Management Extension (IME) installs itself when the first Win32 app, PowerShell script or remediation targets the device.
- Intune supports Windows 11 Home, but many settings (CSPs) don't apply to Home. *Trainer recommendation:* don't manage Home devices. Linux (Ubuntu 24.04/26.04 LTS, Red Hat Enterprise Linux 9/10) and ChromeOS can be enrolled, with far fewer management options than Windows.
- Intune marks devices with no compliance policy as **Compliant** by default. Microsoft recommends switching this to **Not compliant** as soon as you use Conditional Access (Endpoint security → Device compliance → Compliance policy settings).
- Device cleanup rules hide Intune devices that haven't checked in for 30 to 270 days. They don't wipe or retire the device and don't remove it from Entra ID.
- Devices deleted in Entra ID go to a soft-deleted state (preview) and can be restored for 30 days – BitLocker recovery keys and LAPS passwords are kept. You restore them in the Entra admin center in the **Deleted devices** view. Learn still names only Microsoft Graph and PowerShell for the preview.<!-- Lab observation Michael 2026-10-20: restore works in the portal. -->

Sources: [Device enrollment guide](https://learn.microsoft.com/intune/device-enrollment/guide) · [Supported operating systems](https://learn.microsoft.com/intune/fundamentals/ref-supported-platforms) · [Compliance policy settings](https://learn.microsoft.com/intune/device-security/compliance/overview#compliance-policy-settings) · [Corporate identifiers and ownership](https://learn.microsoft.com/intune/device-enrollment/add-corporate-identifiers) · [Device cleanup rules](https://learn.microsoft.com/intune/governance/configure-cleanup-rules) · [Device soft delete (preview)](https://learn.microsoft.com/entra/identity/devices/concept-soft-delete-devices)

## 2. Enrollment restrictions

- **Device limit restrictions** set how many devices one user can enroll, from 1 to 15. In a normal tenant the default restriction allows 5 devices. Your course tenant ships with 15.
- **Device platform restrictions** allow or block platforms, personally owned devices and OS versions (for example, iOS/iPadOS 26.0 and later).
- Restrictions have priorities. The one with the highest priority wins, and a new restriction is placed just above the default.
- The Intune device limit doesn't count devices enrolled through GPO auto-enrollment, co-management, Windows Autopilot, a work account added in Windows Settings, or a device enrollment manager (DEM). These count as shared or admin-enrolled devices. Entra ID has its own device limit for joined and registered devices.
- A **device enrollment manager** account can enroll up to 1,000 devices. It isn't an admin role and doesn't work with every enrollment method, Apple automated device enrollment for example.

Sources: [Create device limit restrictions](https://learn.microsoft.com/intune/device-enrollment/create-device-limit-restrictions) · [Intune and Entra device limits](https://learn.microsoft.com/intune/device-enrollment/limits-intune-entra) · [Create device platform restrictions](https://learn.microsoft.com/intune/device-enrollment/create-platform-restrictions) · [Device enrollment managers](https://learn.microsoft.com/intune/device-enrollment/setup-enrollment-manager)

Lab: [2.1 Enrollment restrictions](../Labs/LAB_02_1_enrollment-restrictions.html)

## 3. Roles and permissions

- **Entra roles** such as Intune Administrator work on the whole tenant. **Intune roles** only work inside Intune and can be limited.
- An Intune role assignment has three parts: **admin groups** (who gets the role), **scope groups** (which users and devices they can target) and **scope tags** (which objects they can see). Scope groups and scope tags must both match.
- Built-in Intune roles can't be changed. To adjust permissions, duplicate a built-in role and edit the copy.
- Some settings need an Entra role no matter which Intune role you have. Creating device limit restrictions needs the Entra role Intune Administrator, for example – every Intune role has read-only access to them.

Sources: [RBAC with Microsoft Intune](https://learn.microsoft.com/intune/fundamentals/role-based-access-control/overview) · [Scope tags](https://learn.microsoft.com/intune/fundamentals/role-based-access-control/scope-tags)

Lab: [2.2 Roles and permissions](../Labs/LAB_02_2_roles-and-permissions.html)

## 4. Join types

| | Entra registered | Entra joined | Entra hybrid joined |
|---|---|---|---|
| Typical device | Personal device | New corporate device | Existing domain-joined device |
| Sign-in to Windows | Local or Microsoft account | Entra account | AD account |
| In this course | – | CL3, CL4 | CL1, CL2 |

- An Entra joined device doesn't need a domain controller to sign in. With line of sight to a DC, it still gets Kerberos tickets for on-premises resources (the SSO test with `\\dc1\LabFiles` in Lab 2.3).
- Use Entra join for new or reinstalled devices. Hybrid join brings the existing domain-joined fleet into Entra ID and needs line of sight to a DC. Moving a hybrid joined device to Entra join needs a reset.
- The **MDM user scope** (All, Some or None) decides who enrolls automatically when a device joins Entra ID. Windows Autopilot needs it too. Without a license that includes Intune and Entra ID P1, auto-enrollment doesn't run.
- **Disable MDM enrollment when adding work or school account** (Automatic Enrollment, preview) stops the "Allow my organization to manage my device" prompt when a user adds a work account in Microsoft Edge or an app such as Teams. It doesn't affect Entra join or Autopilot. *Trainer recommendation:* **Yes** in production; the lab keeps **No**.
- To require MFA at enrollment, target the Conditional Access resource **Microsoft Intune Enrollment**. New tenants don't have it automatically – an admin creates its service principal (app ID `d4ebce55-015a-49b5-a083-c84d1797ae8c`) with PowerShell or Graph.
- After a sign-in with the **password**, an Entra joined device gets Kerberos tickets for on-premises resources. After a sign-in with **Windows Hello for Business**, it needs cloud Kerberos trust for that – covered later in the course.
- Windows Information Protection (WIP) is gone. It is removed starting with Windows 11, version 24H2.
- Windows Hello for Business uses a 6-digit PIN by default. In a Hyper-V VM, set up Hello in the basic console, not in an enhanced session.

Sources: [Microsoft Entra device identity](https://learn.microsoft.com/entra/identity/devices/overview) · [Entra joined vs. hybrid joined](https://learn.microsoft.com/intune/solutions/cloud-native-endpoints/entra-join-types) · [Windows automatic enrollment](https://learn.microsoft.com/intune/device-enrollment/windows/enable-automatic-mdm) · [MFA for enrollment](https://learn.microsoft.com/intune/device-enrollment/configure-multifactor-authentication) · [Cloud Kerberos trust](https://learn.microsoft.com/windows/security/identity-protection/hello-for-business/deploy/hybrid-cloud-kerberos-trust) · [Deprecated Windows features (WIP)](https://learn.microsoft.com/windows/whats-new/deprecated-features) · [Windows Hello for Business at enrollment](https://learn.microsoft.com/intune/device-security/identity-protection/configure-tenant-wide-policy)

Lab: [2.3 Join CL3 to Entra ID](../Labs/LAB_02_3_join-cl3-to-entra-id.html)

## 5. Hybrid join

The hybrid join runs in this order:

1. The Entra Connect wizard writes a **service connection point (SCP)** to AD. It tells domain-joined devices which tenant to join.
2. The client reads the SCP and writes a key to its computer object (`userCertificate`). The scheduled task **Automatic-Device-Join** runs at every user sign-in and every hour.
3. The next sync takes the computer to Entra ID. Until the client completes the registration, the device shows **Pending**.
4. The client completes the join and gets a PRT for the signed-in user.
5. The GPO **Enable automatic MDM enrollment using default Azure AD credentials** creates the EnterpriseMgmt task, and the device enrolls in Intune.

- If you are stuck on **Pending**, run the Automatic-Device-Join task or `dsregcmd /join` in an elevated prompt.
- `dsregcmd /status` shows `AzureAdJoined`, `DomainJoined` and the PRT. The "Diagnostic Data" section shows the phase and error code of a failed join.
- The join is logged under Applications and Services Logs → Microsoft → Windows → **User Device Registration** → Admin. The MDM enrollment is logged under **DeviceManagement-Enterprise-Diagnostics-Provider** → Admin: event 75 means success, 76 failure.
- Use **User Credential** in the GPO. **Device Credential** is only supported for co-management and Azure Virtual Desktop multi-session hosts.
- On a hybrid device, GPO and Intune can set the same setting. By default the GPO wins; the MDM setting **ControlPolicyConflict/MDMWinsOverGP** reverses that. *Trainer recommendation:* decide per setting who owns it – mixing them makes troubleshooting hard.

Sources: [Configure hybrid join](https://learn.microsoft.com/entra/identity/devices/how-to-hybrid-join) · [How device registration works](https://learn.microsoft.com/entra/identity/devices/device-registration-how-it-works) · [Troubleshoot hybrid joined devices](https://learn.microsoft.com/entra/identity/devices/troubleshoot-hybrid-join-windows-current) · [Enroll Windows devices by Group Policy](https://learn.microsoft.com/windows/client-management/enroll-a-windows-10-device-automatically-using-group-policy) · [Diagnose MDM enrollment](https://learn.microsoft.com/windows/client-management/mdm-diagnose-enrollment)

Lab: [2.4 Hybrid join CL1 and CL2](../Labs/LAB_02_4_hybrid-join-cl1-and-cl2.html)

## 6. Co-management

- Clients with the Configuration Manager agent show MDM **Microsoft Configuration Manager** in Entra ID, and compliance **ConfigMgr** in Intune. Until you move workloads, Intune policies don't reach them.
- **Cloud attach** is set up in the Configuration Manager console under Administration → Cloud Services → Cloud Attach. With the default settings, eligible clients enroll into co-management, but every workload stays on Configuration Manager.
- Each workload (compliance, device configuration, apps and others) has exactly one owner. You move them one by one with the sliders on `CoMgmtSettingsProd`, or for a pilot collection first.
- In class, the wizard needed an Intune license on the signing-in admin.
- After tenant attach, a device may show up twice in Intune for a while. The records merge by themselves.

Sources: [Enable cloud attach](https://learn.microsoft.com/intune/configmgr/cloud-attach/enable) · [Co-management workloads](https://learn.microsoft.com/intune/configmgr/comanage/workloads)

Lab: [2.5 Co-management with Configuration Manager](../Labs/LAB_02_5_co-management.html)

## 7. Configuration profiles

- Every Windows setting from Intune ends up as a **CSP** setting on the device. Templates, the settings catalog and custom OMA-URI are only different ways to write them.
- The CSP path decides the scope: `./Device/...` applies to the device, `./User/...` to the signed-in user. That is independent of whether you assign the profile to a user group or a device group.
- **Settings catalog** first. Use a template only where the catalog has no equivalent, and custom OMA-URI only where neither has the setting. Copy OMA-URIs from the CSP reference – they are case-sensitive.
- The **properties catalog** collects hardware inventory. Data shows up after up to 24 hours.
- Intune doesn't resolve conflicts between two configuration profiles. The setting shows **Conflict**, and you have to fix it yourself.
- A device checks in about every 8 hours. Right after enrollment it checks in more often. A manual sync or a restart is faster than waiting.
- *Trainer recommendation:* Intune has no version history and no recycle bin for policies. Write who changed what and why into the description, and back up your policies (for example with IntuneManagement, see below).
- *Trainer recommendation:* name profiles by a fixed pattern – platform, ownership, type, purpose (for example, `Win CO SC OneDrive Settings`).

Sources: [Create a device profile](https://learn.microsoft.com/intune/device-configuration/create-device-profile) · [Settings catalog](https://learn.microsoft.com/intune/device-configuration/settings-catalog/) · [Policy refresh intervals and conflicts](https://learn.microsoft.com/intune/device-configuration/troubleshoot-device-profiles) · [Reboot CSP](https://learn.microsoft.com/windows/client-management/mdm/reboot-csp) · [Configuration service provider reference](https://learn.microsoft.com/windows/client-management/mdm/)

## 8. Groups and assignment filters

- Groups decide **who** gets a policy. Assignment filters narrow it down **at check-in** by device properties such as ownership, OS version or join type. Filters are evaluated when the device checks in, without waiting for dynamic group membership to be calculated.
- A tenant can have up to 200 filters.
- Don't mix user and device groups across include and exclude. Exclude users from a user assignment and devices from a device assignment, or use a filter instead.
- Be careful with exclusions based on dynamic groups: while the group is still being calculated, a device can briefly fall outside the exclusion.

Sources: [Assignment filters](https://learn.microsoft.com/intune/fundamentals/filters/overview) · [Filter properties](https://learn.microsoft.com/intune/fundamentals/filters/ref-device-properties) · [Filters and exclusions: recommendations](https://learn.microsoft.com/intune/fundamentals/filters/performance-recommendations)

Lab: [2.6 Configuration profiles](../Labs/LAB_02_6_configuration-profiles.html)

## 9. Group Policy analytics

- Group Policy analytics reads a GPO report (XML) and shows, per setting, whether an MDM equivalent exists.
- **Migrate** creates a settings catalog policy from the supported settings. Leave it unassigned and review it before you use it.
- Group Policy preferences and firewall rules don't come over. Firewall rules belong in an Endpoint security policy.
- *Trainer recommendation:* don't migrate GPOs 1:1. Use the report to decide what you still need – many old settings are no longer relevant.

Sources: [Group Policy analytics](https://learn.microsoft.com/intune/device-configuration/import-group-policy-analytics) · [Migrate to the settings catalog](https://learn.microsoft.com/intune/device-configuration/migrate-group-policy)

Lab: [2.7 Group Policy analytics](../Labs/LAB_02_7_group-policy-analytics.html)

## 10. Baselines and tools

- [Microsoft Intune – What's new](https://learn.microsoft.com/intune/fundamentals/whats-new): read it at least every two weeks – Intune changes fast.
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks): hardening recommendations, also available for Intune.
- [OpenIntuneBaseline](https://github.com/SkipToTheEndpoint/OpenIntuneBaseline) (community): ready-made baseline policies to import.
- [IntuneManagement](https://github.com/Micke-K/IntuneManagement) (community): backup, export and import of Intune policies – Intune itself keeps no versions.
- [awesomeintune.com](https://awesomeintune.com) (community): curated list of Intune tools and blogs.
- [intunesettings.app](https://intunesettings.app) (community): search all settings catalog settings.

## What you did today

1. Limited devices per user and iOS/iPadOS versions with enrollment restrictions ([Lab 2.1](../Labs/LAB_02_1_enrollment-restrictions.html)).
2. Gave `Cloud Users` the Policy and Profile Manager role for Windows devices ([Lab 2.2](../Labs/LAB_02_2_roles-and-permissions.html)).
3. Joined CL3 to Entra ID from OOBE and tested single sign-on to cloud and on-premises resources ([Lab 2.3](../Labs/LAB_02_3_join-cl3-to-entra-id.html)).
4. Brought CL1 and CL2 to hybrid join and into Intune, and checked both steps in the event logs ([Lab 2.4](../Labs/LAB_02_4_hybrid-join-cl1-and-cl2.html)).
5. Cloud attached Configuration Manager and moved all workloads to Intune ([Lab 2.5](../Labs/LAB_02_5_co-management.html)).
6. Deployed a template, a custom OMA-URI, settings and properties catalog profiles with assignment filters ([Lab 2.6](../Labs/LAB_02_6_configuration-profiles.html)).
7. Analyzed and migrated a GPO with Group Policy analytics ([Lab 2.7](../Labs/LAB_02_7_group-policy-analytics.html)).

## Tomorrow (Day 3)

Win32 and Store apps, Windows Update, Windows Autopilot for CL4.
