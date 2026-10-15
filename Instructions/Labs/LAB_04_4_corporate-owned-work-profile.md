---
title: 'Lab 4.4 – Corporate-owned work profile'
lab:
    title: 'Lab 4.4 – Corporate-owned work profile'
    module: 'Day 4 – Android'
---

# Lab 4.4 – Corporate-owned work profile

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Enroll a corporate-owned device with a work profile (COPE) by QR code and compare what you can manage with the BYOD device from Lab 4.2.

1. Intune admin center → Devices → Enrollment → Android → **Corporate-owned devices with work profile** → Create profile: profile `COPE`, note the QR code.
2. Factory reset your Android test device from Lab 4.3. On the welcome screen, tap the same spot several times until the QR code reader opens.
3. Scan the QR code, connect to Wi-Fi and sign in as User2.
4. Intune admin center → Devices → Configuration → Create → Android Enterprise → **Fully Managed, Dedicated, and Corporate-Owned Work Profile** → Device restrictions: profile `COPE Restrictions` that blocks the camera in the work profile, assigned to a group with User2.
5. Compare the device actions and the available configuration settings with the BYOD device from Lab 4.2.

### Checkpoint

- [ ] The device is listed in Intune with ownership **Corporate** and enrollment type corporate-owned with work profile
- [ ] `COPE Restrictions` shows **Succeeded**
- [ ] You can name three settings or actions you have on COPE but not on BYOD

**Note:** Fully managed (COBO) and dedicated devices (COSU, kiosk) use the same QR code mechanism with their own enrollment profiles.

**Why:** COPE gives IT control of the device and the work profile, while the user keeps a private profile.
<!-- VERIFY: tap count on the welcome screen – handbook: 10x, slides: "multiple times", Google/Learn: six taps. Kept generic. -->
<!-- VERIFY: configuration profile type label and camera setting for COPE (work profile level). -->
