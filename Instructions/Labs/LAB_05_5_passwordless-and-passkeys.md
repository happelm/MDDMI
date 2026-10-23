---
title: 'Lab 5.5 – Passwordless sign-in and passkeys'
lab:
    title: 'Lab 5.5 – Passwordless sign-in and passkeys'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.5 – Passwordless sign-in and passkeys

**Estimated time:** 20 minutes

**Goal:** Register Microsoft Authenticator on the Android test device for User1, turn on phone sign-in, create a passkey and sign in without a password.

1. Android test device (fully managed from Lab 4.5): open Microsoft Authenticator. User1 is listed in grey – the account is there for single sign-on only, not for MFA.
2. CL3: open Edge and go to `aka.ms/mfasetup` (Security info) as User1. Skip the passkey suggestion. **Add sign-in method** → **Microsoft Authenticator** → scan the QR code with Authenticator on the test device. User1 turns white and shows a 6-digit code.
3. Test device → Authenticator → User1 → **Enable phone sign-in** and follow the steps.
4. Test device → Authenticator → User1 → **Create a passkey**. Android asks you to allow Microsoft Authenticator as a passkey provider (Settings → Passwords, passkeys and accounts) – allow it.
5. CL3: open an InPrivate window, go to `myaccount.microsoft.com` and enter User1. Windows offers a passkey – cancel it and choose **Approve a request on my Microsoft Authenticator app**. Confirm the number on the test device.

### Checkpoint

- [ ] User1 shows phone sign-in and a passkey in Authenticator
- [ ] Security info lists Microsoft Authenticator and the passkey
- [ ] You signed in to My Account on CL3 without typing a password

**Note:** The passkey in Authenticator is device-bound – it doesn't sync. Synced passkeys from iCloud Keychain, Google Password Manager or third-party providers such as 1Password are generally available in Entra ID since March 2026 and are controlled with passkey profiles.

**Note:** Using the phone's passkey from CL3 needs Bluetooth on both devices (cross-device sign-in). The VM has no Bluetooth, so Windows falls back to a USB security key – that's why you use phone sign-in here.

**Note:** If Authenticator doesn't offer **Create a passkey**, the **Passkey (FIDO2)** method isn't enabled for User1 in Entra ID → Authentication methods.

**Note:** One Authenticator can hold accounts from several tenants.

**Why:** Passwordless methods are phishing-resistant or at least resistant to password theft. Passkeys are bound to the sign-in site, so a fake site can't use them.
<!-- Source: Day 5 recording 2026-10-23 03:27–03:47 (Michael: Lab 5.5 on Day 5). Learn: how-to-enable-authenticator-passkey (device-bound, Android 14+/iOS 17+, passkey profile; no device registration requirement), whats-new March 2026 (synced passkeys GA), how-to-synced-passkeys, howto-authentication-passwordless-phone (multiple tenants). VERIFY: exact Android menu path for the passkey provider (Samsung), label "Enable phone sign-in". -->
