---
title: MDDMI Lab Instructions
permalink: index.html
---

# MDDMI – Modern Device Management with Microsoft Intune

Lab instructions for the five-day MDDMI workshop: three days Windows, one day Android, half a day iOS/iPadOS. Use the copy button on every code block.

## Labs

### Day 1 – Foundation and hybrid identity

Lab tenant and licenses, custom domain and DNS records, hybrid identity with Microsoft Entra Connect Sync, dynamic groups, Company Portal.

| Lab | Title | Time |
|---|---|---|
| 1.1 | [Set up your tenant](Instructions/Labs/LAB_01_1_set-up-your-tenant.html) | 30 min |
| 1.2 | [Add your custom domain](Instructions/Labs/LAB_01_2_add-your-custom-domain.html) | 30 min |
| 1.3 | [Sync your users](Instructions/Labs/LAB_01_3_sync-your-users.html) | 45 min |
| 1.4 | [Groups and Company Portal](Instructions/Labs/LAB_01_4_groups-and-company-portal.html) | 30 min |

### Day 2 – Windows management

MDM auto-enrollment, Entra join vs. registration, Microsoft Entra hybrid join by GPO, roles and permissions, configuration profiles and CSPs, Group Policy analytics, Win32 and Store apps, Windows Autopilot.

| Lab | Title | Time |
|---|---|---|
| 2.1 | [Join CL3 to Entra ID](Instructions/Labs/LAB_02_1_join-cl3-to-entra-id.html) | 30 min |
| 2.2 | [Hybrid join CL1 and CL2](Instructions/Labs/LAB_02_2_hybrid-join-cl1-and-cl2.html) | 60 min |
| 2.3 | [Roles and permissions](Instructions/Labs/LAB_02_3_roles-and-permissions.html) | 20 min |
| 2.4 | [Configuration profiles](Instructions/Labs/LAB_02_4_configuration-profiles.html) | 45 min |
| 2.5 | [Migrate a GPO](Instructions/Labs/LAB_02_5_migrate-a-gpo.html) | 30 min |
| 2.6 | [Deploy a Win32 app](Instructions/Labs/LAB_02_6_deploy-a-win32-app.html) | 45 min |
| 2.7 | [Deploy CL4 with Windows Autopilot](Instructions/Labs/LAB_02_7_deploy-cl4-with-autopilot.html) | 60 min |

### Day 3 – Windows security

Endpoint security policies, Windows LAPS, Endpoint Privilege Management, compliance and Conditional Access, Microsoft Defender for Endpoint (demo).

| Lab | Title | Time |
|---|---|---|
| 3.1 | [Endpoint security policies](Instructions/Labs/LAB_03_1_endpoint-security-policies.html) | 60 min |
| 3.2 | [Windows LAPS](Instructions/Labs/LAB_03_2_windows-laps.html) | 30 min |
| 3.3 | [Endpoint Privilege Management](Instructions/Labs/LAB_03_3_endpoint-privilege-management.html) | 30 min (optional) |
| 3.4 | [Compliance and Conditional Access](Instructions/Labs/LAB_03_4_compliance-and-conditional-access.html) | 45 min |

### Day 4 – Android

Managed Google Play, personally owned work profile with compliance and Conditional Access, apps and retire, corporate-owned work profile.

| Lab | Title | Time |
|---|---|---|
| 4.1 | [Connect Managed Google Play](Instructions/Labs/LAB_04_1_connect-managed-google-play.html) | 20 min |
| 4.2 | [BYOD with a work profile](Instructions/Labs/LAB_04_2_byod-with-a-work-profile.html) | 60 min |
| 4.3 | [Apps and retire](Instructions/Labs/LAB_04_3_apps-and-retire.html) | 30 min |
| 4.4 | [Corporate-owned work profile](Instructions/Labs/LAB_04_4_corporate-owned-work-profile.html) | 45 min |

### Day 5 – iOS/iPadOS

Apple MDM push certificate, device enrollment with the Company Portal, profiles and compliance, app protection. Half day.

| Lab | Title | Time |
|---|---|---|
| 5.1 | [Apple MDM push certificate](Instructions/Labs/LAB_05_1_apple-mdm-push-certificate.html) | 20 min |
| 5.2 | [Enroll an iPhone](Instructions/Labs/LAB_05_2_enroll-an-iphone.html) | 45 min |
| 5.3 | [Protect Outlook with app protection](Instructions/Labs/LAB_05_3_protect-outlook-with-app-protection.html) | 30 min |

### Appendix

[Log map, join types, collecting logs](Instructions/Appendix.html)

### Resources

[MDDMI link collection](https://github.com/happelm/Intune-Resources/blob/main/Intune1Links.md) – Learn articles, blogs and tools for this workshop.

## About this guide

> **Draft:** This lab guide is new. Every lab is marked as draft until it has been tested in this course.

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
| PKI | One-tier Enterprise CA (Hyper-V VM on your lab host) | Switched off – not needed. Its root certificate is already distributed in `smart.etc` through AD (Lab 2.4, 5.2) |
| ConfigMgr server | Configuration Manager (Hyper-V VM on your lab host) | CL1 and CL2 have the ConfigMgr client |
| CL1 | Windows 11, domain joined | Signs in automatically as User1 – hybrid joined on Day 2 |
| CL2 | Windows 11, domain joined | Signs in automatically as User2 – hybrid joined on Day 2 |
| CL3 | Windows 11, no domain | In OOBE – you join it to Entra ID on Day 2 |
| CL4 | Windows 11, no domain | In OOBE – you deploy it with Windows Autopilot on Day 2 |
| Tenant | Microsoft 365 E5 (GoDeploy, 20 licenses) | You launch it in Lab 1.1; it expires after two weeks |

On Day 4 you get an Android test device from the trainer. For Day 5 the trainer tells you which iPhone or iPad to use.

### Accounts

| Account | Where | Used for |
|---|---|---|
| SMART\Administrator | DC1, SRV1 | Domain administration, Entra Connect Sync setup |
| User1 | Synced from `OU=Cloud` | CL1, CL3, Android and iOS labs |
| User2 | Synced from `OU=Cloud` | CL2, CL4, COPE and app protection labs |
| Tenant admin | Your tenant | Microsoft 365 admin center, Entra admin center, Intune admin center |

Passwords are on the pod card from the trainer.

### Tools

- Lab files: the trainer gives you a link to the course share; copy its `Scripts` folder to `C:\Scripts`. Later the lab files come as a ZIP download from this repository.
- Work on your lab host, never on your own notebook. Use Remote Desktop Connection Manager on the lab host to reach the VMs. If one client misbehaves, continue on the other one and tell the trainer.
- Full screen in the lab portal (Guacamole): press `F11`, move the mouse to the top edge to bring back the address bar and click **Reload** (inside the session `F5` goes to the VM) – the connection to the VM reconnects at full screen size without black borders.
- CMTrace for all .log files – Intune Management Extension logs in `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`
- Microsoft 365 admin center: admin.cloud.microsoft · Intune admin center: intune.microsoft.com · Entra admin center: entra.microsoft.com
- Scripts used in the labs: [Labfiles folder in this repository](https://github.com/happelm/MDDMI/tree/main/Labfiles)
