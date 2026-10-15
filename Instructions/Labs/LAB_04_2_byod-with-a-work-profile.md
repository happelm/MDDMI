---
title: 'Lab 4.2 – BYOD with a work profile'
lab:
    title: 'Lab 4.2 – BYOD with a work profile'
    module: 'Day 4 – Android'
---

# Lab 4.2 – BYOD with a work profile

**Estimated time:** 60 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Prepare compliance, Conditional Access and an Outlook configuration first – then let the user enroll a personal Android device because Outlook demands it.

1. Entra admin center → Groups: create an assigned security group `Android Users` with User1.
2. Intune admin center → Devices → Compliance → Create policy → Android Enterprise → **Personally-owned work profile**: policy `Android Compliance` that requires a device password with at least six characters, assigned to `Android Users`.
3. Entra admin center → Protection → Conditional Access → Create new policy: `Require compliant Android` for `Android Users`, target resource **Office 365**, condition device platforms **Android**, grant **Require device to be marked as compliant**, state **On**.
4. Apps → Android → **Microsoft Outlook**: assign it as **Required** to `Android Users`.
5. Apps → Configuration → Create → **Managed devices**: policy `Outlook Config` for Android Enterprise and Microsoft Outlook – configure the email account with modern authentication and the user principal name, assigned to `Android Users`.
6. Android device: install Outlook from Google Play in the personal profile and sign in as User1. Follow the instructions: install the Company Portal, sign in, create the work profile.
7. Android device: open Outlook in the work profile (briefcase icon).

### Checkpoint

- [ ] The first sign-in in the personal Outlook is blocked
- [ ] The device is listed in Intune with ownership **Personal** and is compliant
- [ ] Outlook in the work profile shows User1's mailbox without typing the account

**Note:** Do it in this order. If the user enrolls first, you do not see how Conditional Access drives the enrollment.

**Why:** With a work profile, protection is built in – work apps and data stay in the profile. App protection policies on top are only needed for devices without enrollment.
<!-- VERIFY: devices for Day 4 – participants' own phones (BYOD) or provided test devices? Requires a Google account on the device for personal profile setup (handbook). -->
<!-- VERIFY: CA from Lab 3.4 targets Windows only – both policies coexist; check Office 365 vs. Exchange Online targeting. -->
<!-- VERIFY: compliance setting name "Required password type / minimum password length" for personally-owned work profile (device vs. work profile password). -->
