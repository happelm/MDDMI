---
title: 'Lab 5.2 – Enroll an iPhone'
lab:
    title: 'Lab 5.2 – Enroll an iPhone'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.2 – Enroll an iPhone

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Enroll an iPhone or iPad with the Company Portal, give it a restrictions profile, a root certificate and a compliance policy – and know what a personal device lets you do.

1. Entra admin center → Groups: create an assigned security group `iOS Users` with User1.
2. Intune admin center → Devices → Configuration → Create → iOS/iPadOS → Templates → **Device restrictions**: profile `iOS Restrictions` that blocks the camera, assigned to `iOS Users`.
3. Create → iOS/iPadOS → Templates → **Trusted certificate**: profile `iOS Root CA` with the root certificate `SmartPKI.cer` you exported in [Lab 4.3](LAB_04_3_configure-the-byod-device.html), assigned to `iOS Users`.
4. Devices → Compliance → Create policy → iOS/iPadOS: policy `iOS Compliance` that blocks jailbroken devices and requires a passcode, assigned to `iOS Users`.
5. iPhone: install the Company Portal from the App Store, sign in as User1 and follow the enrollment. Install the downloaded management profile in Settings.
6. Intune admin center → Devices → iOS/iPadOS → your device: go through the device actions with the trainer – which do you have on a personal device, which only on a supervised one?
7. Trainer demo: Automated Device Enrollment with Apple Business Manager – enrollment profile, supervision, Volume Purchase Program apps.

### Checkpoint

- [ ] The device is listed in Intune with ownership **Personal** and is compliant
- [ ] The camera icon is gone
- [ ] The root certificate is listed in Settings → General → VPN & Device Management → management profile

**Note:** Many restrictions – for example blocking the App Store – only apply to supervised devices. On a personal device Intune shows them as not applicable.

**Why:** Device enrollment gives you the device, account-driven user enrollment only a separate work area, app protection only the apps. Pick by ownership and how much the user accepts.
<!-- VERIFY: devices for Day 5 – participants' own iPhones (device enrollment is invasive) or test devices? Consider account-driven user enrollment (needs ABM federation + managed Apple accounts). -->
<!-- VERIFY: block camera is available without supervision on current iOS (Apple MDM restrictions payload allowCamera). Check Apple docs. -->
<!-- VERIFY: Settings path on current iOS for management profile. -->
