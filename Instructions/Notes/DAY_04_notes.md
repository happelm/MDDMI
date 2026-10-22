---
title: 'Day 4 notes – Android'
---

# Day 4 notes – Android

> Summary of what was covered on Day 4, with sources – not a transcript. Recommendations marked "trainer recommendation" are field experience, not Microsoft documentation. Links marked "community" point to non-Microsoft sources; Samsung sources are named as such. "Lab observation" means the trainer saw it in a lab tenant; it isn't documented by Microsoft.

## Key takeaways

- Android Enterprise needs a Managed Google Play binding first. Every enrollment type and every Google Play app depends on it.
- The enrollment type is decided at the first boot: personal work profile (BYOD), corporate-owned work profile (COPE), fully managed (COBO) or dedicated (COSU). Changing it later needs a factory reset.
- Personally owned work profiles move to the Android Management API with web enrollment. Turning web enrollment on is tenant-wide and can't be undone.
- Conditional Access drives BYOD enrollment: Outlook is blocked until the device is enrolled and compliant.
- Compliance checks, configuration enforces. Only a device configuration profile can enforce a passcode that **Reset passcode** can change.
- Enrollment time grouping puts corporate devices into a group during enrollment, so apps and policies arrive right away instead of up to 8 hours later.
- **Mark devices with no compliance policy assigned as Not compliant** closes the gap for devices without a policy.

## 1. Android Enterprise basics

- **Device administrator** is deprecated and no longer available for devices with Google Mobile Services. Use Android Enterprise.
- **Work profile (BYOD):** work apps and data live in a separate profile with its own apps (two Outlooks on one phone). **Retire** removes only the work profile.
- **Corporate-owned:** COPE (work profile on a corporate device), COBO (fully managed, one user), COSU (dedicated, kiosk). Intune uses the Android Management API for all three.
- The **Android Enterprise Recommended** list from Google shows devices that meet Google's requirements.
- Data protection beyond the device and the app (labels, DLP) is Microsoft Purview, not Intune.

Sources: [Android enrollment guide](https://learn.microsoft.com/intune/device-enrollment/android/guide) · [Assignment filter properties (device administrator note)](https://learn.microsoft.com/intune/fundamentals/filters/ref-device-properties)

## 2. Managed Google Play

- Microsoft recommends binding with a Microsoft Entra account. In this course you use a Gmail account because the Entra path fails in lab hoster tenants (lab observation).
- After the binding Intune adds default apps such as Microsoft Intune, Intune Company Portal, Managed Home Screen and Microsoft Authenticator.
- To reuse a Google account, delete the old organization at `play.google.com/work` → Admin settings.

Source: [Connect Intune to Managed Google Play](https://learn.microsoft.com/intune/device-enrollment/android/connect-managed-google-play)

## 3. Personally owned work profile and the Android Management API

- Intune moves personally owned work profiles from the Company Portal as custom device policy controller (DPC) to Google's **Android Management API** (AMAPI). The **Android Device Policy** app enforces the policies, the **Microsoft Intune** app replaces the Company Portal as the user's app.
- **Web enrollment** is turned on in Devices → Enrollment → Android → Personally owned devices with a work profile. It applies to the whole tenant and **can't be reversed**. Test it in a test tenant first.
- Users start web enrollment from a URL or are redirected from **Outlook or Teams** when Conditional Access requires enrollment.
- If passkeys are the only allowed authentication method in your tenant, don't turn on web enrollment yet.
- Already enrolled devices move only with the **Move to Android Management API** configuration profile. They need Android 9 or later and can't roll back. Track them in Devices → Monitor → **Personal Devices on Android Management API**.
- After enrollment or migration Intune installs Microsoft Intune, Company Portal (for app management), Android Device Policy (hidden) and Microsoft Authenticator in the work profile. With AMAPI, users can't uninstall required apps.
- Wi-Fi profiles with username and password lose the connection during migration – move to certificate-based Wi-Fi first.
- A QR code to `aka.ms/enrollmyandroid` is just a link. It doesn't control who enrolls; use enrollment restrictions for that (trainer recommendation).

Sources: [Android Management API for personally owned work profiles](https://learn.microsoft.com/intune/device-enrollment/android/android-management-api-overview) · [Set up personally owned work profile enrollment](https://learn.microsoft.com/intune/device-enrollment/android/setup-personal-work-profile)

## 4. Compliance

- **Password complexity** for personally owned work profiles (Android 12 and later): **Low** allows repeating or ordered PINs like `1234`, **Medium** needs at least 4 characters and blocks repeating and ordered PINs, **High** needs at least 8 characters (6 for alphabetic or alphanumeric).
- **Required password type** and **Minimum password length** are deprecated for Android 12 and later only for personally owned work profiles. Fully managed, dedicated and COPE compliance still use them.
- Device and work profile share one lock by default. If you require only the work profile password, only the work profile asks for a PIN.
- Conflicts: if two compliance policies check the same setting, the most restrictive value wins. If a compliance policy and a configuration profile set the same setting, the compliance policy wins.
- Tenant-wide **Compliance policy settings**: **Mark devices with no compliance policy assigned as** (default **Compliant**) and **Compliance status validity period** (default 30 days, 1–120). Set the first to **Not compliant**.
- Windows: the password settings under System Security apply only to local accounts. Entra ID and AD accounts get their password rules from Entra ID and AD.
- Windows: keep settings that need no grace (BitLocker) and settings that need time (security intelligence up-to-date) in separate policies with different actions for noncompliance (trainer recommendation). Notifications only make sense with a grace period.
- **Minimum OS version** is static – raise it yourself.

Sources: [Android Enterprise compliance settings](https://learn.microsoft.com/intune/device-security/compliance/ref-android-enterprise-settings) · [Compliance and configuration conflicts](https://learn.microsoft.com/intune/device-configuration/troubleshoot-device-profiles#compliance-and-device-configuration-policies-that-conflict) · [Compliance overview](https://learn.microsoft.com/intune/device-security/compliance/overview) · [Windows compliance settings](https://learn.microsoft.com/intune/device-security/compliance/ref-windows-settings) · [Password settings and local accounts](https://learn.microsoft.com/intune/fundamentals/ref-policy-map-access-requirements#require-a-password)

## 5. Configuration, certificates and Wi-Fi

- Device restrictions come in two sections: **Personally owned work profile** and **Fully managed, dedicated, and corporate-owned work profile**. Pick the right one – a BYOD profile doesn't apply to a COBO device and the other way round.
- The **settings catalog** for Android Enterprise exists but has fewer settings than the templates. If you can't find a setting in one, check the other.
- **Factory reset protection emails**: only the listed Google accounts can set the device up again after a non-user reset. Never set them on lab phones.
- **System update** on corporate devices: device default, automatic, postponed (30 days) or maintenance window. **Freeze periods** block all system updates for up to 90 days; recurring freeze periods must be at least 60 days apart. (The trainer's 60/30 days in class don't match Learn – Learn wins.)
- **Firmware over the air (FOTA)** for Samsung (Knox E-FOTA) and Zebra (LifeGuard) are separate integrations.
- **OEMConfig** apps (for example Knox Service Plugin, Zebra) add vendor settings through an app configuration profile. The **Knox Platform for Enterprise Premium** license that the Knox Service Plugin needs for its premium features has been free since July 1, 2021. You generate the key in the Knox Admin Portal. DualDAR and other special licenses stay paid.
- **Tethering and access to hotspots = Block** in device restrictions (corporate-owned section) turns off the hotspot. No Knox needed.
- **Wallpaper by URL:** in kiosk mode with the Managed Home Screen (**Set device wall paper** in the app configuration, also offered in the device restrictions profile), or with **Configure custom wallpaper** for the Microsoft Launcher on fully managed devices.
- **Wi-Fi with WPA pre-shared key** on personally owned work profiles: supported by Learn (Basic Wi-Fi type). A participant saw it fail on older devices – test it before you rely on it.
- Known portal behavior: on new Android configuration profiles the group assignment sometimes isn't saved. Check the assignment after saving (trainer observation).

Sources: [Android Enterprise device restrictions](https://learn.microsoft.com/intune/device-configuration/templates/ref-device-restrictions-android-enterprise) · [Managed Home Screen configuration](https://learn.microsoft.com/intune/app-management/configuration/configure-managed-home-screen) · [Knox Platform for Enterprise licenses (Samsung)](https://docs.samsungknox.com/admin/knox-platform-for-enterprise/before-you-begin/knox-platform-for-enterprise-licenses/) · [Knox release highlights July 2021 (Samsung)](https://samsungknox.com/en/blog/knox-release-highlights-july-2021) · [Android software updates planning guide](https://learn.microsoft.com/intune/device-updates/android/planning-guide) · [FOTA](https://learn.microsoft.com/intune/device-updates/android/manage-fota) · [OEMConfig](https://learn.microsoft.com/intune/device-configuration/templates/configure-oemconfig-android) · [Android Enterprise Wi-Fi settings](https://learn.microsoft.com/intune/device-configuration/templates/ref-wifi-settings-android-enterprise) · [Wi-Fi with a pre-shared key](https://learn.microsoft.com/intune/device-configuration/templates/create-wifi-preshared-key)

## 6. Corporate enrollment

- Corporate devices enroll with a **token** (20 digits or QR code), **Knox Mobile Enrollment** (Samsung) or **Google zero-touch** – the last two work like Autopilot with a reseller. Knox Mobile Enrollment itself needs no license.
- On Samsung devices, drawing a **plus sign** on the welcome screen opens the Knox deployment screen (Bluetooth, NFC, Wi-Fi Direct or QR code) for Knox Mobile Enrollment through the Knox Deployment App. (Community: [vmlabblog.com](https://vmlabblog.com/2020/09/plus-sign-gesture-samsung-kda/))
- The QR reader opens when you tap the welcome screen several times. Use the Intune QR code of the profile.
- **Device name template** for fully managed devices, for example `{{DEVICETYPE}}-{{SERIALLAST4DIGITS}}`. Other variables: `{{SERIAL}}`, `{{ENROLLMENTDATETIME}}`, `{{UPNPREFIX}}`, `{{USERNAME}}`, `{{RAND:x}}`. Only new enrollments get the name.
- **Enrollment time grouping:** one static Entra security group per enrollment profile, owner = service principal **Intune Provisioning Client** (AppId `f1346770-5b25-470b-88bd-d5744ab7952c`, sometimes shown as *Intune Autopilot ConfidentialClient*). Only new enrollments, not with the staging token. Failures: Devices → Monitor → **Enrollment time grouping failures**. Without it, apps and policies can take up to 8 hours.
- **Assignment filters** on `deviceManagementType` separate enrollment types: `Corporate-owned fully managed`, `Corporate-owned with work profile`, `Personally-owned work profile`, dedicated with or without Entra shared mode, AOSP. Filters on `enrollmentProfileName` break when the profile is renamed (trainer recommendation).

Sources: [Knox licenses (Samsung)](https://docs.samsungknox.com/admin/fundamentals/knox-licenses/) · [Set up fully managed enrollment](https://learn.microsoft.com/intune/device-enrollment/android/setup-fully-managed) · [Corporate enrollment methods](https://learn.microsoft.com/intune/device-enrollment/android/ref-corporate-methods) · [Knox Mobile Enrollment](https://learn.microsoft.com/intune/device-enrollment/android/setup-samsung-knox-mobile) · [Enrollment time grouping](https://learn.microsoft.com/intune/device-enrollment/setup-time-grouping) · [Assignment filter properties](https://learn.microsoft.com/intune/fundamentals/filters/ref-device-properties)

## 7. Apps

- **Managed Google Play apps** are approved, synced and then assigned. Licenses aren't counted.
- **Line-of-business APK**: direct upload only for fully managed and dedicated devices. COPE and BYOD need a private app in Managed Google Play with a package name that is unique in Google Play.
- **Android Enterprise system app** turns on a preinstalled but hidden app (for example the Samsung Gallery, `com.sec.android.gallery3d`). Only Required or Uninstall. It can't coexist with the same app from Managed Google Play and can't be edited later.
- **Outlook app configuration** (Managed devices) fills in the account, restricts Outlook to work accounts, saves contacts to the phone and grants the contacts permission automatically.
- App protection policies for Android follow on Day 5 with iOS – the feature works the same way.

Sources: [Add Managed Google Play apps](https://learn.microsoft.com/intune/app-management/deployment/add-managed-google-play) · [Add an Android LOB app](https://learn.microsoft.com/intune/app-management/deployment/add-lob-android) · [Android Enterprise system apps](https://learn.microsoft.com/intune/app-management/configuration/manage-system-apps-android)

## 8. Device actions

| Action | BYOD (work profile) | Fully managed |
|---|---|---|
| Retire | removes only the work profile | – |
| Wipe | not available | factory reset |
| Locate device | not available | needs **Locate device = Allow** in device restrictions |
| Reset passcode | work profile passcode | work profile passcode (as listed on Learn) |

- **Reset passcode** works only when a **device configuration profile** enforces the passcode – a compliance policy alone isn't enough. The new passcode shows in the admin center for 7 days. Dedicated and AOSP devices support only the device passcode reset.
- Lab observation: after **Retire** on a COPE device, the trainer's device couldn't enroll again.
- **Delete** removes the Intune object. The Entra device object often stays and needs a cleanup (trainer observation).
- The fully managed phone in Lab 4.5 shows **Wipe**; Retire on fully managed devices wasn't tested in class.

Sources: [Reset passcode](https://learn.microsoft.com/intune/device-management/actions/reset-passcode) · [Android Enterprise device restrictions – Locate device](https://learn.microsoft.com/intune/device-configuration/templates/ref-device-restrictions-android-enterprise)

## Before Day 5

> Keep the Android test device enrolled as it is. Day 5 ends with a passkey on the phone.
