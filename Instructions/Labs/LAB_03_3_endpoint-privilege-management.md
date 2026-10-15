---
title: 'Lab 3.3 – Endpoint Privilege Management'
lab:
    title: 'Lab 3.3 – Endpoint Privilege Management'
    module: 'Day 3 – Windows security'
---

# Lab 3.3 – Endpoint Privilege Management

**Estimated time:** 30 minutes (optional)
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Optional:** This lab needs an Endpoint Privilege Management or Intune Suite license (trial) in your tenant. Without it, the trainer shows it as demo.

**Goal:** Let a standard user run a specific installer and a specific admin command with elevation – without making the user a local administrator.

1. Intune admin center → Endpoint security → Endpoint Privilege Management → Create policy → Windows → **Elevation settings policy**: policy `EPM Settings` with Endpoint Privilege Management **Enabled**, assigned to `Win11 Devices`.
2. Create policy → **Elevation rules policy**: policy `EPM Rules` with two rules, elevation type **User confirmed**:
   - the Notepad++ installer (file name and file hash or certificate)
   - `sc.exe` from `C:\Windows\System32`
3. CL3 as a standard user: right-click the Notepad++ installer → **Run with elevated access**, confirm with a reason.
4. CL3: in a command prompt started with elevated access, stop and start the spooler:

   ```cmd
   sc.exe stop spooler
   ```

   ```cmd
   sc.exe start spooler
   ```

5. Intune admin center → Endpoint security → Endpoint Privilege Management → Reports: find your elevations.

### Checkpoint

- [ ] Notepad++ installed by a standard user
- [ ] Spooler restarted with `sc.exe`
- [ ] Both elevations listed in the EPM report

**Why:** Least privilege with exceptions per file instead of local admin rights for everyone.
<!-- VERIFY: CL3 user User1 is a local admin after Entra join by OOBE (first user = admin) – need a standard user for the test. -->
<!-- VERIFY: rule for sc.exe in a cmd shell – elevation of sc.exe itself vs. cmd; test in tenant. -->
