---
title: 'Lab 4.3 – Configure the BYOD device'
lab:
    title: 'Lab 4.3 – Configure the BYOD device'
    module: 'Day 4 – Android'
---

# Lab 4.3 – Configure the BYOD device

**Estimated time:** 45 minutes

**Goal:** Restrict the work profile, push the Smart PKI root certificate, deploy Edge and LinkedIn, and look at the device from the admin side.

## Device restrictions

1. Intune admin center → Devices → Android → Configuration → Create → Android Enterprise → Templates → **Device restrictions** in the section **Personally owned work profile** (not the fully managed, dedicated and corporate-owned section): profile `AE BY Device Restrictions`:

   | Setting | Value |
   |---|---|
   | Work profile settings → Work profile notifications while device locked | Block |
   | Prevent app installations from unknown sources in the personal profile | Block |

   Assign it to `All Android Devices`. After saving, open the profile again and check that the group is still assigned (see the note).

## Trusted root certificate

2. CL1 or CL2 (not CL3 or CL4): run `certlm.msc` → Trusted Root Certification Authorities → Certificates → double-click **Smart PKI** → Details → **Copy to File**. Keep the format **DER encoded binary X.509 (.CER)** and save it on the desktop as `SmartPKI`.
3. Copy the file with Ctrl+C. Intune admin center → Configuration → Create → Android Enterprise → Templates → **Trusted certificate** (personally owned work profile): profile `AE BY Smart PKI Root Certificate`. In the upload dialog go to **Downloads**, paste the file with Ctrl+V and open it.
4. Assign it to `All Android Devices` and check the group again after saving. On the phone, a notification says that a certificate authority was installed.

## Apps

5. Apps → Android → Create → **Managed Google Play app**: select **Microsoft Edge** and **LinkedIn** (one Sync covers both). Assign **Microsoft Edge** as **Required** and **LinkedIn** as **Available for enrolled devices** to `Cloud Users`.
6. Android test device: Edge shows up in the work profile with single sign-on. LinkedIn is in the Play Store of the work profile.

## Admin view

7. Intune admin center → Devices → Android → your device. Look at the device name, ownership, the OS entry and the discovered apps. Go through the device actions: which ones are greyed out on a personally owned work profile device?

### Checkpoint

- [ ] `AE BY Device Restrictions` and `AE BY Smart PKI Root Certificate` show **Succeeded** for your device
- [ ] The phone shows the notification about the installed certificate authority
- [ ] Edge is installed in the work profile, LinkedIn can be installed from the work profile's Play Store
- [ ] You can name the device actions that are missing for a personal device

**Note:** Known portal behavior on new Android configuration profiles: the group assignment sometimes isn't saved. Open the profile again and add the group, or create the profile without a group and assign it afterwards. (Trainer observation, not documented on Learn.)

**Note:** Copy and paste between the work and the personal profile is already blocked by default.

**Note:** On a personal device, **Wipe** is greyed out. **Retire** removes only the work profile with its apps and data. Serial number and personal apps stay hidden from IT.

**Note:** **Reset passcode** works only when the passcode requirement comes from a device configuration profile. In this course the PIN is required only by the compliance policy, so the reset would fail.

**Why:** The work profile is IT's part of the phone. You control what happens inside it and how it talks to the personal side, not the personal profile itself.
<!-- Source: Day 4 recording 2026-10-22 AM 02:42–03:25. Michael 16:24: Edge Required, LinkedIn Available. Learn: ref-device-restrictions-android-enterprise (personally owned work profile settings), reset-passcode (Android pivot: passcode must come from a device configuration policy). Portal assignment bug: trainer observation. Retire stays for Lab 4.5 (before the COBO enrollment). VERIFY: exact setting label "Prevent app installations from unknown sources in the personal profile". -->
