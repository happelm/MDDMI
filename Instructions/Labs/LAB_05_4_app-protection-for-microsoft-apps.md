---
title: 'Lab 5.4 – App protection for Microsoft apps'
lab:
    title: 'Lab 5.4 – App protection for Microsoft apps'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.4 – App protection for Microsoft apps

**Estimated time:** 30 minutes, plus 20 minutes for the optional test on your own iPhone

**Goal:** Protect company data inside the Microsoft apps with an app protection policy – on enrolled and on unenrolled devices.

## Create the policy

1. Intune admin center → Apps → iOS/iPadOS → Protection → Create policy → **iOS/iPadOS**: policy `iOS App Protection for MS Core Apps`. Apps: **Core Microsoft apps** (open the list to see which apps are included).
2. Data protection:

   | Setting | Value |
   |---|---|
   | Backup org data to iTunes and iCloud backups | Block |
   | Send org data to other apps | Policy managed apps |
   | Save copies of org data | Block |
   | Receive data from other apps | All apps |
   | Restrict cut, copy, and paste between other apps | Policy managed apps with paste in |
   | Encrypt org data | Require |
   | Org data notifications | Block org data |

3. Access requirements: **PIN for access** = Require, **App PIN when device PIN is set** = Not required.
4. Conditional launch: keep the defaults – max PIN attempts **5** → Reset PIN, offline grace period **1440** minutes → Block access, **90** days → Wipe data, jailbroken devices → Block access.
5. Create the policy without assignment. Look at the other data protection settings with the trainer – printing, third-party keyboards, web content transfer to Microsoft Edge.

### Checkpoint

- [ ] `iOS App Protection for MS Core Apps` exists with the settings above

## Optional: test on your own iPhone

Only if you want to – your iPhone isn't enrolled, only the work account in Outlook is protected. You remove it at the end.

6. Assign `iOS App Protection for MS Core Apps` to `Cloud Users`.
7. Entra admin center → Conditional Access → `CA-001 Office 365 Only for Intune Enrolled Devices` → Conditions → Device platforms: include **Any device**, exclude **iOS**. Then create `CA-002 Office 365 App Protection for iOS`: users `Cloud Users`, target resource **Office 365**, condition device platforms **iOS**, grant **Require app protection policy**, state **On**.
8. Your iPhone: install Microsoft Outlook and Microsoft Authenticator from the App Store. Add the account User2 in Outlook. Outlook asks you to restart it and then for an app PIN.
9. Copy text from a mail and paste it into the Notes app: it shows *Your organization's data cannot be pasted here.*
10. Remove the account from Outlook. Uninstall Outlook if you don't need it.

### Checkpoint (optional part)

- [ ] Outlook asks for an app PIN for User2
- [ ] Paste into Notes is blocked
- [ ] The account is removed from your iPhone again

**Note:** **App PIN when device PIN is set = Not required** skips the app PIN only on enrolled devices with the Company Portal and the `IntuneMAMUPN` app configuration. On your unenrolled iPhone the app PIN is always asked.

**Note:** Apps from the same publisher share one app PIN – after Outlook, Teams doesn't ask again.

**Note:** App protection needs no enrollment, so it is the only protection on BYOD devices without MDM – and the second layer on enrolled devices for a private account inside a managed app (trainer recommendation: use it on iOS always).

**Why:** Managed open-in on enrolled devices separates managed from unmanaged apps. App protection separates work from private accounts inside the same app.
<!-- Source: Day 5 recording 2026-10-23 02:59–03:27 (class: no assignment, no device). Optional part = option B (MAM without enrollment on own iPhone), Michael 2026-10-23. CA-001 from Lab 4.2 requires a compliant device for Cloud Users on all platforms, so iOS must be excluded and covered by an app protection CA policy – NOT run in class, VERIFY with Michael before class. Learn: ref-settings-ios (PIN per publisher, defaults 1440 min/90 days/5 attempts, App PIN when device PIN is set needs enrollment + IntuneMAMUPN), configure-teams-mobile (Org data notifications). -->
