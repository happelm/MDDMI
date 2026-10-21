---
title: 'Lab 1.3 – Sync your users'
lab:
    title: 'Lab 1.3 – Sync your users'
    module: 'Day 1 – Foundation and hybrid identity'
---

# Lab 1.3 – Sync your users

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

**Goal:** Synchronize `OU=Cloud` with Microsoft Entra Connect Sync on SRV1 using password hash synchronization, and license User1 and User2.

1. DC1: Active Directory Domains and Trusts → right-click the top node **Active Directory Domains and Trusts** (not the domain) → Properties → add your custom domain from Lab 1.2 as UPN suffix.
2. DC1: Active Directory Users and Computers → `OU=Cloud`: change the UPN suffix of User1 and User2 to your custom domain.
3. SRV1 (`SMART\Administrator`): sign in to the Entra admin center in Microsoft Edge. If you are asked to create a passkey, choose **Not now**.
4. Entra admin center → Entra ID → Entra Connect → **Get started** → **Manage** → **Download Connect Sync Agent**, then start the installation.
5. Choose **Customize**. Leave the required components unchanged.
6. User sign-in: **Password Hash Synchronization**. Leave **Enable single sign-on** cleared. Sign in with your tenant admin; if Windows offers to register the device, choose **No, sign in to this app only**.
7. Connect your directories: add `smart.etc`, keep **Create new AD account** and enter `SMART\Administrator`.
8. Microsoft Entra sign-in configuration: your custom domain shows **Verified**, `smart.etc` shows **Not added**. Select **Continue without matching all UPN suffixes to verified domains** and keep `userPrincipalName` as the sign-in attribute.
9. Domain and OU filtering: select only `OU=Cloud`. Don't use group filtering.
10. Optional features: turn on **Password writeback**. Finish the wizard with an initial synchronization.
11. Microsoft 365 admin center → Users → Active users: select User1 and User2 → **Manage product licenses** → **Assign more** → **Microsoft 365 E5**.

### Checkpoint

- [ ] User1 and User2 are listed in Entra ID with **On-premises sync enabled** = Yes and the UPN of your custom domain
- [ ] The group `Cloud Users` is synced with User1 and User2 as members
- [ ] Both users have a Microsoft 365 E5 license

**Note:** Synced users get the usage location United States automatically – that is fine for the lab.

**Note:** The wizard shows a TPM warning on SRV1 – that is expected. If password writeback fails at the end, go **Previous** and **Next** once. The Health agent warning clears after **Exit**.

**Note:** Synced attributes are read-only in Entra ID. Change them in AD.

**Note:** If you later remove an OU from the filter, its users are deleted in Entra ID. You can restore them for 30 days.

**Note:** CL1 and CL2 are in `OU=Cloud`, but they don't show up in Entra ID yet. Connect Sync only takes computers whose `userCertificate` was written by the client during hybrid join. That happens on Day 2.

**Why Customize:** Express settings expect a routable domain. `smart.etc` isn't routable, so the sign-in suffix has to be your custom domain.

**Why no Seamless SSO:** Windows devices get single sign-on through the Primary Refresh Token (PRT) once they are joined (Day 2). Seamless SSO is only needed for older domain-joined devices.

**Why Tier 0:** The sync server controls your identities. Treat SRV1 like a domain controller.

**Optional:** SRV1: start a delta sync in PowerShell and watch it in the Synchronization Service Manager:

```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```
<!-- Source: Day 1 recording 2026-10-19 (PM 00:12–01:28). Connect device filter: Learn "Entra Connect Sync: Understanding the default configuration" (userCertificate ISNOTNULL). -->
