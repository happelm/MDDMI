---
title: 'Lab 3.2 – Windows LAPS'
lab:
    title: 'Lab 3.2 – Windows LAPS'
    module: 'Day 3 – Windows security'
---

# Lab 3.2 – Windows LAPS

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Let Windows LAPS manage the local administrator password of your Entra joined clients and read it as an admin.

1. Entra admin center → Identity → Devices → All devices → Device settings: **Enable Microsoft Entra Local Administrator Password Solution (LAPS)** = Yes.
2. Intune admin center → Endpoint security → Account protection → Create policy → Windows → **Local admin password solution (Windows LAPS)**: policy `LAPS` with backup directory **Backup the password to Microsoft Entra ID only** and a password age of `7` days, assigned to `All Windows 11 Devices`.
3. CL3: sync, then look at Event Viewer → Applications and Services Logs → Microsoft → Windows → LAPS → Operational.
4. Intune admin center → Devices → All devices → CL3 → **Local admin password**: show the password.
5. Intune admin center → Devices → All devices → CL3 → **Rotate local admin password**. Show the password again.

### Checkpoint

- [ ] Password of CL3 visible in Intune and in Entra ID
- [ ] After the rotation the password is different
- [ ] You know which role may read the password

**Note:** Reading the password is a separate permission. A help desk role without it sees the device, not the password.

**Why:** The same local administrator password on every device is one of the easiest ways to move laterally in a network.
<!-- VERIFY: built-in Administrator is disabled on OOBE-joined devices – does Michael want automatic account management (24H2+) or a named account? -->
