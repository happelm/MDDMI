---
title: 'Lab 3.1 – Endpoint security policies'
lab:
    title: 'Lab 3.1 – Endpoint security policies'
    module: 'Day 3 – Windows security'
---

# Lab 3.1 – Endpoint security policies

**Estimated time:** 60 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Create the core Endpoint security policies for your Windows clients in one block – and check them on the clients only at the end.

Create all policies in Intune admin center → Endpoint security, platform **Windows**, assigned to `All Windows 11 Devices`. Do not check the clients in between.

1. Antivirus → Microsoft Defender Antivirus: policy `AV Baseline` with real-time protection, cloud-delivered protection and an exclusion for `C:\Source`.
2. Disk encryption → BitLocker: policy `BitLocker OS Drive` – require device encryption, encrypt the OS drive silently, back up the recovery key to Microsoft Entra ID. Look at every other option with the trainer: TPM only vs. TPM and PIN, encryption method, recovery options.
3. Firewall → Windows Firewall Rules: policy `Firewall Rules` with one rule that blocks outbound TCP port `23`.
4. Attack surface reduction → Attack Surface Reduction Rules: policy `ASR Audit` with two rules in **Audit** mode: **Block all Office applications from creating child processes** and **Block credential stealing from the Windows local security authority subsystem**.
5. Account protection → Local user group membership: policy `Local Admins` that adds the group `Helpdesk` (create it with User2 as member) to the local group **Administrators** with action **Add (Update)**.
6. Now sync CL1, CL3 and CL4 and check each policy:

   ```powershell
   Get-MpPreference | Select-Object DisableRealtimeMonitoring, ExclusionPath, AttackSurfaceReductionRules_Ids, AttackSurfaceReductionRules_Actions
   ```

   ```cmd
   manage-bde -status C:
   ```

   ```cmd
   net localgroup Administrators
   ```

### Checkpoint

- [ ] All five policies show **Succeeded** for at least one client
- [ ] `ExclusionPath` contains `C:\Source`, two ASR rules in audit mode (value `2`)
- [ ] OS drive encrypted, recovery key visible in Intune admin center → Devices → device → Recovery keys
- [ ] `Helpdesk` member of the local Administrators group

**Note:** **Add (Replace)** in local user group membership removes every member that is not in the policy – including accounts you still need. Use **Add (Update)** in this lab.

**Why:** Configuration profiles and Endpoint security policies can set the same setting – that is a conflict. Keep security settings in one place.
<!-- VERIFY: vTPM on the pod VMs (BitLocker silent encryption needs TPM). -->
<!-- VERIFY: Endpoint security firewall rule check on the client (MDM rules: Get-NetFirewallRule -PolicyStore ActiveStore?). -->
<!-- VERIFY: ASR audit value 2 per Learn ASR rules reference. -->
