---
title: 'Lab 5.1 – Apple MDM push certificate'
lab:
    title: 'Lab 5.1 – Apple MDM push certificate'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.1 – Apple MDM push certificate

**Estimated time:** 20 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Create the Apple MDM push certificate – without it, Intune cannot manage any iPhone, iPad or Mac.

1. Intune admin center → Devices → Enrollment → Apple → **Apple MDM Push certificate**: agree to the terms and download the CSR.
2. Open the Apple Push Certificates Portal (identity.apple.com), sign in with an Apple Account and create a certificate from the CSR. Download the `.pem` file.
3. Back in Intune: enter the Apple Account you used and upload the `.pem` file.

### Checkpoint

- [ ] Status **Active** with an expiration date one year from today
- [ ] You noted which Apple Account you used

**Note:** Renew the certificate with the same Apple Account every year. A new certificate from another account means re-enrolling every Apple device.

**Why:** Intune wakes Apple devices through the Apple Push Notification service – the certificate ties your tenant to it.
