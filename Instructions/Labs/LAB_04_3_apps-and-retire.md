---
title: 'Lab 4.3 – Apps and retire'
lab:
    title: 'Lab 4.3 – Apps and retire'
    module: 'Day 4 – Android'
---

# Lab 4.3 – Apps and retire

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** See the difference between required and available apps in the work profile, use the device actions and remove the work profile from Intune.

1. Apps → Android → Create → Managed Google Play app: approve **Microsoft Teams** and **Microsoft Authenticator**.
2. Assign Teams as **Required** and Authenticator as **Available for enrolled devices** to `Android Users`.
3. Android test device: check the work profile – one app arrives on its own, the other one is in the work profile's Play Store.
4. Intune admin center → Devices → Android → your device: go through the device actions with the trainer (sync, restart, remove passcode, retire, wipe) – which do you have on a personally owned work profile device?
5. Run **Retire** on your device.

### Checkpoint

- [ ] Teams installed in the work profile without user action
- [ ] Authenticator available in the work profile's Play Store
- [ ] After retire, the work profile and its apps are gone – the personal profile stays

**Note:** Retire on a work profile device removes only the work profile. A full wipe is not possible on a personally owned device.

**Why:** BYOD devices leave the company with the user. Corporate data must go, personal data must stay.
<!-- VERIFY: handbook says "Gerät aus Intune löschen → Work Profile verschwindet"; Learn: Retire removes the work profile. Michael to confirm which action he shows. -->
<!-- VERIFY: available device actions for personally-owned work profile per current Learn table. -->
