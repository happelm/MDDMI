---
title: 'Lab 4.5 – Windows compliance policy'
lab:
    title: 'Lab 4.5 – Windows compliance policy'
    module: 'Day 4 – Android'
---

# Lab 4.5 – Windows compliance policy

**Estimated time:** 20 minutes

> **Draft:** This lab is new and has not been run in this environment yet. If a step behaves differently, tell the trainer.

**Goal:** Build a Windows compliance policy the same way as the Android one, make CL3 noncompliant on purpose and compliant again.

1. CL3: run `winver` and note the OS build.
2. Intune admin center → Devices → Compliance → Create policy → **Windows 10 and later**: policy `Win Compliance` with **Minimum OS version** set higher than the build from step 1. Assign it to `All Windows 11 Devices`.
3. CL3: Company Portal → your device → **Check access**. Wait until CL3 shows as noncompliant in the Company Portal and in the Intune admin center.
4. Change **Minimum OS version** in `Win Compliance` to the build from step 1 or lower. **Check access** again.

### Checkpoint

- [ ] CL3 noncompliant with the reason minimum OS version
- [ ] CL3 compliant again after the change

**Note:** The Conditional Access policy from Lab 4.2 targets Android only. A Windows policy with **Require device to be marked as compliant** works the same way – exclude your admin account, start in **Report-only**.

**Why:** Configuration profiles set settings, compliance policies only check them. Conditional Access uses the result to allow or block access.
<!-- Moved from Day 3 (old Lab 3.4) by Michael's decision 2026-10-21 16:59: compliance on the Android day, one Windows policy taken along. CA and the MDE demo stay with Lab 4.2 / the trainer. VERIFY: version format for Minimum OS version (e.g. 10.0.26200.xxxx). -->
