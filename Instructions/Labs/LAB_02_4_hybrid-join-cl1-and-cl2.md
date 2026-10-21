---
title: 'Lab 2.4 – Hybrid join CL1 and CL2'
lab:
    title: 'Lab 2.4 – Hybrid join CL1 and CL2'
    module: 'Day 2 – Windows management'
---

# Lab 2.4 – Hybrid join CL1 and CL2

**Estimated time:** 60 minutes
<!-- VERIFY: duration -->

**Goal:** Bring the domain-joined clients CL1 and CL2 to Microsoft Entra hybrid join and into Intune – and check both steps on the client.

Already done: users synced and licensed (Lab 1.3), MDM user scope **All** (Lab 2.3). CL1 and CL2 are in `OU=Cloud`, but Connect Sync takes them to Entra ID only after they wrote their `userCertificate` in this lab.

1. DC1: Group Policy Management → create a GPO `Intune Auto-Enrollment` and link it to `OU=Workstations` (under `OU=Cloud`, with the sub-OUs Finance for CL1 and Sales for CL2).
2. Edit the GPO: Computer Configuration → Policies → Administrative Templates → Windows Components → MDM → **Enable automatic MDM enrollment using default Azure AD credentials** = Enabled, credential type **User Credential**.
3. SRV1: start **Azure AD Connect** from the desktop → **Configure** → **Configure device options**. Sign in as Global Administrator; if Windows offers to register the device, choose **No, sign in to this app only**.
4. **Configure Hybrid Microsoft Entra ID join** → **Windows 10 or later domain-joined devices** → forest `smart.etc`, authentication service **Microsoft Entra ID**, enterprise admin `SMART\Administrator` → **Configure**. **Close the wizard afterwards** – an open wizard blocks the sync.
5. CL1 and CL2: run `gpupdate /force`, then **restart** (signing out is not enough).
6. SRV1: run a delta sync:

   ```powershell
   Start-ADSyncSyncCycle -PolicyType Delta
   ```

7. SRV1: Synchronization Service → Operations: the delta import shows **2 updates** – CL1 and CL2. You see the changed objects, not the `userCertificate` attribute itself.
8. Entra admin center → Devices → All devices: CL1 and CL2 show **Microsoft Entra hybrid joined** with registered **Pending**. To finish the join without waiting, on each client run Task Scheduler → Microsoft → Windows → Workplace Join → **Automatic-Device-Join** → **Run**, or in an elevated command prompt:

   ```cmd
   dsregcmd /join
   ```

9. CL1: run `dsregcmd /status` and compare it with CL3: CL1 shows `DomainJoined : YES` as well.
10. CL1: check the hybrid join in Event Viewer → Applications and Services Logs → Microsoft → Windows → **User Device Registration** → Admin.
11. CL1: check the MDM enrollment in Event Viewer → Applications and Services Logs → Microsoft → Windows → **DeviceManagement-Enterprise-Diagnostics-Provider** → Admin: event `75` (auto MDM enrollment succeeded) or `76` (failed). Task Scheduler → Microsoft → Windows → EnterpriseMgmt shows the enrollment task the GPO created.

### Checkpoint

- [ ] CL1 and CL2: `AzureAdJoined : YES` and `DomainJoined : YES`
- [ ] CL1 and CL2 have a registration date in Entra ID (no longer **Pending**)
- [ ] CL1 and CL2 are listed in Intune admin center → Devices → Windows
- [ ] You found the join in the User Device Registration log and event `75` or `76` in the DeviceManagement-Enterprise-Diagnostics-Provider log

**Note:** The ADMX on DC1 still uses the old name "Azure AD". **Device Credential** is only supported for co-management and Azure Virtual Desktop multi-session hosts.

**Note:** The MDM URL in `dsregcmd /status` can show up only after another restart. The EnterpriseMgmt task retries the enrollment every 5 minutes – a few minutes of waiting are normal.

**Note:** Running the sync cycle, the Automatic-Device-Join task and the restarts by hand only speeds things up for class. In production you just wait: the task runs at every sign-in and every hour, and the sync runs every 30 minutes.

**Note:** Azure AD Connect may show a banner about moving to Microsoft Entra Cloud Sync. Ignore it for this lab.

**Tip:** The wizard writes a service connection point (SCP) to AD. You see it on DC1 in ADSI Edit → Configuration partition → Services → Device Registration Configuration. Without the SCP the client doesn't know which tenant to join.

**Why:** The GPO only triggers the enrollment. Without hybrid join and a PRT for the user, the enrollment task fails.

At the end of today you have two hybrid joined clients (CL1, CL2) and one Entra joined client (CL3). If one client doesn't make it, continue – one device that went through the process is enough.
<!-- Source: Day 2 recording 2026-10-20 (AM/PM) and Michael's corrections 2026-10-20 (Sync Service shows 2 updates only after the sync cycle, userCertificate not visible there; ignore Cloud Sync banner; both event logs). Learn "Troubleshoot Microsoft Entra hybrid joined devices" (User Device Registration log), "Diagnose MDM enrollment failures" (events 75/76), "Enroll a Windows device automatically using Group Policy". -->
