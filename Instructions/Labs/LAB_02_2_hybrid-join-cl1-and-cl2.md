---
title: 'Lab 2.2 – Hybrid join CL1 and CL2'
lab:
    title: 'Lab 2.2 – Hybrid join CL1 and CL2'
    module: 'Day 2 – Windows management'
---

# Lab 2.2 – Hybrid join CL1 and CL2

**Estimated time:** 60 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Bring the domain-joined clients CL1 and CL2 to Microsoft Entra hybrid join and into Intune with the five-step program – and troubleshoot it on the client.

Already done: users synced and licensed (Lab 1.3), MDM user scope **All** (Lab 2.1). CL1 and CL2 are in `OU=Cloud`, but Connect Sync takes them to Entra ID only after they wrote their `userCertificate` in this lab.

1. SRV1: Microsoft Entra Connect → Configure → **Configure device options** → **Configure Hybrid Microsoft Entra join**: select **Windows 10 or later domain-joined devices**, forest `smart.etc`, authentication service **Microsoft Entra ID**, enterprise admin `SMART\Administrator`.
2. DC1: Group Policy Management: create a GPO `MDM Auto-Enrollment` linked to `OU=Cloud` with Computer Configuration → Policies → Administrative Templates → Windows Components → MDM → **Enable automatic MDM enrollment using default Microsoft Entra credentials** = Enabled, credential type **User Credential**.
3. CL1 (User1) and CL2 (User2): run `gpupdate /force`, sign out and in again.
4. SRV1: run a delta sync, then check that CL1 and CL2 show up in Entra ID as **Microsoft Entra hybrid joined**:

   ```powershell
   Start-ADSyncSyncCycle -PolicyType Delta
   ```

5. CL1: `dsregcmd /status`. If the device is not joined yet, look at Event Viewer → Applications and Services Logs → Microsoft → Windows → User Device Registration → Admin.
6. CL1: Task Scheduler → Microsoft → Windows → EnterpriseMgmt: find the enrollment task created by the GPO. Event Viewer → Applications and Services Logs → Microsoft → Windows → DeviceManagement-Enterprise-Diagnostics-Provider → Admin: find event `75` (auto MDM enrollment succeeded) or `76` (failed).
7. DC1: Active Directory Users and Computers (Advanced Features) → CL1 → Attribute Editor: look at `userCertificate` – the device key that the sync takes to Entra ID.

### Checkpoint

- [ ] CL1 and CL2: `AzureAdJoined : YES` and `DomainJoined : YES`
- [ ] CL1 and CL2 are listed in Intune admin center → Devices → Windows
- [ ] You found event `75` or `76` on one client and know what it means

**Note:** The hybrid join needs a sync cycle after the client wrote its certificate. After that sync the device shows up in Entra ID as **Pending** until the client completes the registration – then it shows **Microsoft Entra hybrid joined** with a registration date. MDM enrollment often needs another sign-in or a restart – a few minutes of waiting are normal.

**Why:** The GPO only triggers the enrollment. Without hybrid join and a PRT for the user, the enrollment task fails.

At the end of today you have two hybrid joined clients (CL1, CL2) and one Entra joined client (CL3). If one client does not make it, continue – one device that went through the process is enough.
<!-- VERIFY: GPO setting name in the ADMX on DC1 (older ADMX: "...default Azure AD credentials"). -->
<!-- VERIFY: event IDs 75/76 per Learn "Enroll a Windows device automatically using Group Policy". -->
