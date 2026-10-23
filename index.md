---
title: MDDMI Lab Instructions
permalink: index.html
---

# MDDMI – Modern Device Management with Microsoft Intune

Lab instructions for the five-day MDDMI workshop: three days Windows, one day Android, half a day iOS/iPadOS. Use the copy button on every code block.

> **Before the course:** Create a new Google account (@gmail.com) at home and keep its sign-in at hand. You need it on Day 4 to connect your tenant to Managed Google Play. Don't use your work account or your main private account.

## Labs

### Day 1 – Foundation and hybrid identity

Lab tenant and licenses, custom domain and DNS records, hybrid identity with Microsoft Entra Connect Sync, dynamic groups, Company Portal.

**Day notes:** [Day 1 – Foundation and hybrid identity](Instructions/Notes/DAY_01_notes.html)

| Lab | Title | Time |
|---|---|---|
| 1.1 | [Set up your tenant](Instructions/Labs/LAB_01_1_set-up-your-tenant.html) | 30 min |
| 1.2 | [Add your custom domain](Instructions/Labs/LAB_01_2_add-your-custom-domain.html) | 30 min |
| 1.3 | [Sync your users](Instructions/Labs/LAB_01_3_sync-your-users.html) | 45 min |
| 1.4 | [Groups and Company Portal](Instructions/Labs/LAB_01_4_groups-and-company-portal.html) | 30 min |

### Day 2 – Windows management

Enrollment restrictions, roles and permissions, Entra join and single sign-on, Microsoft Entra hybrid join by GPO, co-management with Configuration Manager, configuration profiles, assignment filters and CSPs, Group Policy analytics.

**Day notes:** [Day 2 – Windows management](Instructions/Notes/DAY_02_notes.html)

| Lab | Title | Time |
|---|---|---|
| 2.1 | [Enrollment restrictions](Instructions/Labs/LAB_02_1_enrollment-restrictions.html) | 15 min |
| 2.2 | [Roles and permissions](Instructions/Labs/LAB_02_2_roles-and-permissions.html) | 15 min |
| 2.3 | [Join CL3 to Entra ID](Instructions/Labs/LAB_02_3_join-cl3-to-entra-id.html) | 45 min |
| 2.4 | [Hybrid join CL1 and CL2](Instructions/Labs/LAB_02_4_hybrid-join-cl1-and-cl2.html) | 60 min |
| 2.5 | [Co-management with Configuration Manager](Instructions/Labs/LAB_02_5_co-management.html) | 30 min |
| 2.6 | [Configuration profiles](Instructions/Labs/LAB_02_6_configuration-profiles.html) | 60 min |
| 2.7 | [Group Policy analytics](Instructions/Labs/LAB_02_7_group-policy-analytics.html) | 30 min |

### Day 3 – Windows apps, updates and Autopilot

Store, Microsoft 365, web link, MSI and Win32 apps, Windows Update rings, feature and driver updates, Windows Autopilot, device actions (talk).

**Day notes:** [Day 3 – Windows apps, updates and Autopilot](Instructions/Notes/DAY_03_notes.html)

| Lab | Title | Time |
|---|---|---|
| 3.1 | [Deploy Windows apps](Instructions/Labs/LAB_03_1_deploy-windows-apps.html) | 60 min |
| 3.2 | [Deploy a Win32 app](Instructions/Labs/LAB_03_2_deploy-a-win32-app.html) | 30 min |
| 3.3 | [Windows Update rings, feature and driver updates](Instructions/Labs/LAB_03_3_windows-update.html) | 45 min |
| 3.4 | [Deploy CL4 with Windows Autopilot](Instructions/Labs/LAB_03_4_deploy-cl4-with-autopilot.html) | 75 min |

### Day 4 – Android

Managed Google Play, personally owned work profile with web enrollment, compliance and Conditional Access, configuration, certificates and apps, one Windows compliance policy, fully managed devices with enrollment time grouping.

**Day notes:** [Day 4 – Android](Instructions/Notes/DAY_04_notes.html)

| Lab | Title | Time |
|---|---|---|
| 4.1 | [Connect Managed Google Play](Instructions/Labs/LAB_04_1_connect-managed-google-play.html) | 20 min |
| 4.2 | [BYOD with a work profile](Instructions/Labs/LAB_04_2_byod-with-a-work-profile.html) | 75 min |
| 4.3 | [Configure the BYOD device](Instructions/Labs/LAB_04_3_configure-the-byod-device.html) | 45 min |
| 4.4 | [Windows compliance policy](Instructions/Labs/LAB_04_4_windows-compliance-policy.html) | 30 min |
| 4.5 | [Fully managed devices](Instructions/Labs/LAB_04_5_fully-managed-devices.html) | 120 min |
| 4.6 | [Android security baseline with Graph](Instructions/Labs/LAB_04_6_android-security-baseline-with-graph.html) (if time permits) | 20 min |

### Day 5 – iOS/iPadOS

Apple MDM push certificate, configuration and compliance without a device, apps, app protection (optional test on your own iPhone without enrollment), passwordless sign-in and passkeys. Automated device enrollment, Shared iPad and shared device mode are a trainer demo. Half day.

**Day notes:** [Day 5 – iOS/iPadOS](Instructions/Notes/DAY_05_notes.html)

| Lab | Title | Time |
|---|---|---|
| 5.1 | [Apple MDM push certificate](Instructions/Labs/LAB_05_1_apple-mdm-push-certificate.html) (optional) | 15 min |
| 5.2 | [iOS device configuration and compliance](Instructions/Labs/LAB_05_2_ios-device-configuration-and-compliance.html) | 30 min |
| 5.3 | [iOS apps and app configuration](Instructions/Labs/LAB_05_3_ios-apps.html) | 25 min |
| 5.4 | [App protection for Microsoft apps](Instructions/Labs/LAB_05_4_app-protection-for-microsoft-apps.html) | 30 min |
| 5.5 | [Passwordless sign-in and passkeys](Instructions/Labs/LAB_05_5_passwordless-and-passkeys.html) | 20 min |

### Day notes

Summary of each day with sources, for after the course.

| Day | Notes |
|---|---|
| 1 | [Foundation and hybrid identity](Instructions/Notes/DAY_01_notes.html) |
| 2 | [Windows management](Instructions/Notes/DAY_02_notes.html) |
| 3 | [Windows apps, updates and Autopilot](Instructions/Notes/DAY_03_notes.html) |
| 4 | [Android](Instructions/Notes/DAY_04_notes.html) |
| 5 | [iOS/iPadOS](Instructions/Notes/DAY_05_notes.html) |

### Appendix

[Log map, join types, collecting logs](Instructions/Appendix.html)

### Resources

[MDDMI link collection](https://github.com/happelm/Intune-Resources/blob/main/Intune1Links.md) – Learn articles, blogs and tools for this workshop.

## About this guide

> **Status:** All labs have been tested in this course.

Each lab lists its goal, the steps at task level (not every click) and a checkpoint you confirm before moving on. The Windows labs build on each other – work through them in order and do not reset your VMs between days.

- **Steps** say what to do and where. Menu paths use → between levels.
- **Checkpoint** items are the definition of done. If one fails, tell the trainer before you continue.
- **Notes** explain what to expect and where it typically goes wrong.

### Your lab pod

One pod and one Microsoft 365 tenant per participant – nothing is shared, you are Global Administrator of your own tenant.

| System | Role | State at the start |
|---|---|---|
| DC1 | AD DS and DNS, domain `smart.etc` | `OU=Cloud` is the sync scope (User1, User2, CL1, CL2) |
| SRV1 | Windows Server, domain joined | Becomes your Microsoft Entra Connect Sync server on Day 1 |
| PKI | One-tier Enterprise CA (Hyper-V VM on your lab host) | Switched off – not needed. Its root certificate is already distributed in `smart.etc` through AD (Lab 2.6, 5.2) |
| SCCM | Configuration Manager (Hyper-V VM on your lab host) | CL1 and CL2 have the ConfigMgr client |
| CL1 | Windows 11, domain joined | Signs in automatically as User1 – hybrid joined on Day 2 |
| CL2 | Windows 11, domain joined | Signs in automatically as User2 – hybrid joined on Day 2 |
| CL3 | Windows 11, no domain | In OOBE – you join it to Entra ID on Day 2 |
| CL4 | Windows 11, no domain | In OOBE – you deploy it with Windows Autopilot on Day 3 |
| Tenant | Microsoft 365 E5 (GoDeploy, 20 licenses) | You launch it in Lab 1.1; it expires after two weeks |

On Day 4 you get an Android test device from the trainer. Day 5 needs no iPhone – if you want, you can test app protection on your own iPhone without enrolling it. An Apple Account is only needed for the optional Lab 5.1.

### Accounts

| Account | Where | Used for |
|---|---|---|
| SMART\Administrator | DC1, SRV1 | Domain administration, Entra Connect Sync setup |
| User1 | Synced from `OU=Cloud` | CL1, CL3, Android and iOS labs |
| User2 | Synced from `OU=Cloud` | CL2, CL4, COPE and app protection labs |
| Tenant admin | Your tenant | Microsoft 365 admin center, Entra admin center, Intune admin center |

Passwords are on the pod card from the trainer.

### Tools

- Lab files: the trainer gives you a link to the course share; copy its `Scripts` folder to `C:\Scripts` on your vLab host. Later the lab files come as a ZIP download from this repository.
- Online participants open the vLab host with the link from the ETC customer portal; in the classroom you sit in front of your lab host. Work on your lab host, never on your own notebook. Use Remote Desktop Connection Manager on the lab host to reach the VMs. If one client misbehaves, continue on the other one and tell the trainer.
- Full screen in the lab portal (Guacamole): press `F11`, move the mouse to the top edge to bring back the address bar and click **Reload** (inside the session `F5` goes to the VM) – the connection to the VM reconnects at full screen size without black borders.
- CMTrace for all .log files – Intune Management Extension logs in `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`
- Microsoft 365 admin center: admin.cloud.microsoft · Intune admin center: intune.microsoft.com · Entra admin center: entra.microsoft.com
- Scripts used in the labs: [Labfiles folder in this repository](https://github.com/happelm/MDDMI/tree/main/Labfiles)
