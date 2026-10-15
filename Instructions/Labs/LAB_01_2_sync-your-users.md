---
title: 'Lab 1.2 – Sync your users'
lab:
    title: 'Lab 1.2 – Sync your users'
    module: 'Day 1 – Foundation and hybrid identity'
---

# Lab 1.2 – Sync your users

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Synchronize User1, User2 and the computer objects in `OU=Cloud` with Microsoft Entra Connect Sync, license the users and turn on MDM auto-enrollment.

1. DC1: Active Directory Domains and Trusts → Properties: add your custom domain from Lab 1.1 as UPN suffix (or your `onmicrosoft.com` domain if you have none).
2. DC1: Active Directory Users and Computers: change the UPN of User1 and User2 to the new suffix.
3. SRV1: download Microsoft Entra Connect Sync from the Entra admin center (Entra Connect → Connect Sync) and start the installation.
4. Choose **Customize**, sign-in method **Password Hash Synchronization**, connect `smart.etc` with `SMART\Administrator`.
5. Domain and OU filtering: sync only `OU=Cloud`. Finish the wizard with an initial synchronization.
6. SRV1: start a delta sync in PowerShell and watch it in the Synchronization Service Manager:

   ```powershell
   Start-ADSyncSyncCycle -PolicyType Delta
   ```

7. Microsoft 365 admin center → Users → Active users: set the usage location and assign a license to User1 and User2.
8. Intune admin center → Devices → Enrollment → Windows → Automatic Enrollment: set the **MDM user scope** to **All**.
9. Open an InPrivate window and sign in to office.com as User1.

### Checkpoint

- [ ] User1 and User2 are listed in Entra ID with **On-premises sync enabled** = Yes
- [ ] Both users have a license
- [ ] MDM user scope is **All**
- [ ] User1 signs in to office.com with the synced password

**Note:** Without a license with Intune and Entra ID P1, auto-enrollment does not run later – even with the MDM user scope set.

**Why:** The sync server is a Tier 0 system: whoever controls it controls your identities. Treat SRV1 like a domain controller.
<!-- VERIFY: SRV1 OS and Entra Connect Sync version supported on it; whether ETC uses Connect Sync (handbook) or Cloud Sync (SCMI). Hybrid join config in Lab 2.1 needs Connect Sync. -->
<!-- VERIFY: OU=Cloud content in the MDDMI pod (SCMI pod: User1, User2, CL1, CL2). -->
