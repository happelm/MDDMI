---
title: 'Lab 2.1 – Enrollment restrictions'
lab:
    title: 'Lab 2.1 – Enrollment restrictions'
    module: 'Day 2 – Windows management'
---

# Lab 2.1 – Enrollment restrictions

**Estimated time:** 15 minutes
<!-- VERIFY: duration -->

**Goal:** Control how many devices a user can enroll and which iOS/iPadOS versions may enroll at all.

1. Intune admin center → Devices → Enrollment → **Device limit restriction** → **Create restriction**: name `10 Devices for Cloud Users`, device limit **10**, assigned to `Cloud Users`.
2. Look at the list of device limit restrictions: your new restriction sits above the default restriction.
3. Intune admin center → Devices → Enrollment → **Device platform restriction** → **iOS/iPadOS restrictions** tab → **Create restriction**: name `iOS 26 for Cloud Users`, MDM **Allow**, minimum version `26.0`, assigned to `Cloud Users`.

### Checkpoint

- [ ] `10 Devices for Cloud Users` has priority 1, the default restriction is last
- [ ] `iOS 26 for Cloud Users` is assigned to `Cloud Users`

**Note:** The device limit can be set from 1 to 15. In a normal tenant the default restriction allows 5 devices; your course tenant ships with 15.

**Note:** The restriction with the highest priority wins, the others are ignored. A new restriction is always placed just above the default.

**Note:** The Intune device limit doesn't count devices enrolled through GPO auto-enrollment, co-management, Windows Autopilot or a work account added in Windows Settings. CL1, CL2 and CL4 never count against it. Entra ID has its own device limit for joined and registered devices.

**Why:** Platform restrictions stop devices you don't support before they enroll. That is cheaper than blocking them afterwards with compliance.
<!-- Source: Day 2 recording 2026-10-20. Learn "Create device limit restrictions" (path, priority, Intune Service Administrator role), "Understand Intune and Microsoft Entra device limit restrictions" (1–15, excluded enrollment types), "Create device platform restrictions". Default 5 / GoDeploy 15: trainer fact 2026-10-20 (not in Learn text). -->
