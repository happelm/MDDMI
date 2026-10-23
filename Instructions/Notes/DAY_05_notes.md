---
title: 'Day 5 notes – iOS/iPadOS'
---

# Day 5 notes – iOS/iPadOS

> Summary of what was covered on Day 5, with sources – not a transcript. Recommendations marked "trainer recommendation" are field experience, not Microsoft documentation. Apple sources are named as such. "Lab observation" means the trainer saw it in a lab tenant; it isn't documented by Microsoft.

## Key takeaways

- iOS/iPadOS has four ways in: app protection only (no enrollment), account-driven user enrollment, device enrollment and automated device enrollment (ADE). Shared iPad and shared device mode are options of the corporate enrollment, not separate enrollment types.
- The Apple MDM push certificate (APNs) is the base for every Apple device. Renew it every year with **Renew** and the same Apple Account. Missing the 30-day grace period or creating a new certificate means every Apple device must enroll again.
- Supervised means ADE. Many restrictions and most DDM software update settings work only on supervised devices.
- Apple software updates move to declarative device management (DDM). Settings (deferral, automatic actions, beta) need iOS/iPadOS 18, enforcement (target version and deadline) needs iOS/iPadOS 17.
- App protection policies protect data inside the app on every enrollment type, including no enrollment at all. For iOS they are the answer to "private account in a managed app".
- Synced passkeys are generally available in Microsoft Entra ID since March 2026. Passkeys in Microsoft Authenticator stay device-bound.

## 1. Enrollment options for iOS/iPadOS

| Option | Ownership | What the organization controls | Wipe |
|---|---|---|---|
| App protection only (MAM-WE) | personal | data in Microsoft and other protected apps | selective wipe of app data |
| Account-driven user enrollment | personal | managed Apple account volume, Wi-Fi, VPN, certificates, managed apps | no – retire only |
| Device enrollment (web-based) | personal or corporate | the device, not supervised | yes |
| Automated device enrollment (ADE) | corporate | the device, supervised | yes |

- **Account-driven user enrollment** needs **managed Apple accounts** and a **service discovery file** on your web server: `https://<domain>/.well-known/com.apple.remotemanagement` (JSON, no file extension). Authenticator handles the just-in-time registration. Federating Apple Business with Microsoft Entra ID is a **best practice**, not a requirement – with federation you don't create managed Apple accounts one by one.
- **Web-based device enrollment** runs on the Company Portal website instead of the Company Portal app, uses just-in-time registration and needs no managed Apple account. iOS/iPadOS 15 or later.
- For user-based enrollment you can let the user choose: **Determine based on user choice**.
- App protection policies apply on every option. Apple's data separation in user enrollment doesn't cover the inside of Microsoft apps.
- The platform filter in the admin center is called **Apple Mobile** (iOS/iPadOS, tvOS, visionOS).

Sources: [iOS/iPadOS enrollment guide](https://learn.microsoft.com/intune/device-enrollment/apple/guide-ios-ipados) · [Account-driven user enrollment](https://learn.microsoft.com/intune/device-enrollment/apple/setup-account-driven-user#prerequisites)

## 2. Apple MDM push certificate

- Valid for **365 days**. After expiry there is a **30-day grace period** to renew.
- Renew with **Renew** in the Apple Push Certificates Portal and the **same Apple Account**. **Create a Certificate** creates a new certificate – then every Apple device must enroll again, the same as when the grace period runs out.
- Trainer recommendations: use a company Apple Account, not a private one; make sure several people can reach its mailbox; set calendar reminders; renew the APNs certificate, the ADE token and the VPP token on the same day once a year.

Source: [Get an Apple MDM push certificate](https://learn.microsoft.com/intune/device-enrollment/apple/create-mdm-push-certificate#renew-apple-mdm-push-certificate)

## 3. Apple Business and automated device enrollment

- **Apple Business** (announced by Apple in March 2026) unifies Apple Business Manager, Business Essentials and Business Connect and includes built-in device management for small companies. It works alongside a third-party MDM like Intune. Registration needs a D-U-N-S number and a verification call; plan about a week (trainer experience).
- **Enrollment program token (ADE token):** Intune → Enrollment program tokens → download the public key → in Apple Business add an MDM server with it → download the server token → upload it in Intune. Valid one year; when it expires, only the sync with Apple Business stops.
- Devices get into Apple Business through the reseller (organization ID) or **Apple Configurator** (Mac, or Apple Configurator for iPhone, iOS 16 or later). Apple Configurator for iPhone pairs by scanning a pattern on the other device with the camera – not by NFC. Devices added manually have a **30-day provisional period** in which the user can remove management.
- Used devices that the previous owner didn't release from their Apple Business can't be added.
- **Enrollment policies** replace the old enrollment profiles (the portal says profiles are no longer updated). A policy combines user affinity, userless, Shared iPad and Microsoft Entra shared device mode, **Setup Assistant with modern authentication**, **Locked enrollment**, a device name template, the Setup Assistant panes and a static device group (**enrollment time grouping**).
- A device gets one policy. Changes reach only devices that enroll (again) – existing devices need a reset.
- **Enrollment notifications** can send an email or push notification after enrollment.

Sources: [Set up automated device enrollment](https://learn.microsoft.com/intune/device-enrollment/apple/setup-automated-ios) · [Enrollment time grouping](https://learn.microsoft.com/intune/device-enrollment/setup-time-grouping) · [Introducing Apple Business (Apple Newsroom)](https://www.apple.com/de/newsroom/2026/03/introducing-apple-business/) · [Add devices using Apple Configurator (Apple)](https://support.apple.com/guide/apple-business-manager/add-devices-using-apple-configurator-axm200a54d59/web) · [Built-in device management alongside a third-party MDM (Apple Platform Deployment)](https://support.apple.com/guide/deployment/dep5a7629d2f/web)

## 4. Shared iPad vs. shared device mode

| | Shared iPad | Microsoft Entra shared device mode |
|---|---|---|
| Devices | iPad only (iPadOS 13.4+, 32 GB or more) | iPhone and iPad |
| Sign-in | managed Apple account (federation required) or a temporary session (guest) | Microsoft Entra account in apps that support shared device mode |
| Enrollment | ADE, Shared iPad in the enrollment policy | ADE without user affinity + Enterprise SSO plug-in + Authenticator |
| Sign-out | user's data stays in its own partition | sign out in one app signs out of all supporting apps |
| Conditional Access, app protection | not supported | supported |

- With federation, the managed Apple account is created automatically when the user signs in on a Shared iPad for the first time.
- **Temporary sessions** (guest, no account) are allowed on Shared iPad by default.
- Don't combine shared device mode with Shared iPad.

Sources: [Shared device solutions for iOS/iPadOS](https://learn.microsoft.com/intune/device-enrollment/apple/shared-device-solutions-ios#compare-solutions) · [Shared iPad](https://learn.microsoft.com/intune/device-enrollment/apple/shared-ipad) · [Frontline workers on iOS/iPadOS](https://learn.microsoft.com/intune/solutions/frontline-worker/ios-ipados#shared-ipad-vs-microsoft-entra-shared-device-mode)

## 5. Configuration and software updates

- The **Device restrictions** template is no longer updated; new settings come in the settings catalog. Lab 5.2 uses the template on purpose because it groups the settings by enrollment type (all enrollment types / device enrollment and ADE / ADE only).
- Settings that keep corporate data out of private apps: **Block viewing corporate documents in unmanaged apps**, **Allow unmanaged apps to read from managed contacts accounts** (so the Phone app shows Outlook contacts) and **Allow copy/paste to be affected by managed open-in**.
- A dynamic group for Apple mobile devices needs **iOS or iPadOS** in the rule – iPads report iPadOS.
- **Supervised** = ADE in Intune.
- **DDM software updates** (settings catalog → Declarative Device Management):
  - **Software Update Settings** (deferral, automatic actions, beta, notifications): iOS/iPadOS **18** or later. Deferral, automatic actions and beta enrollment work only on **supervised** devices.
  - **Software Update Enforcement Specific** (target version, build, local date and time): iOS/iPadOS **17** or later.
  - Deferral hides an update for 1–90 days; it doesn't install it. Compare with the Windows deadlines on Day 3.
  - DDM software update settings take precedence over the deferral in device restrictions.
- The portal no longer lets you create the legacy MDM update policies (lab observation). Apple deprecated MDM-based software updates.
- Apple developer documentation for DDM: [Declarative management data model](https://developer.apple.com/documentation/devicemanagement/leveraging-the-declarative-management-data-model-to-scale-devices) · [SoftwareUpdateSettings](https://developer.apple.com/documentation/devicemanagement/softwareupdatesettings) · [SoftwareUpdateEnforcementSpecific](https://developer.apple.com/documentation/devicemanagement/softwareupdateenforcementspecific) · [PasscodeSettings](https://developer.apple.com/documentation/devicemanagement/passcodesettings) · [AppManaged](https://developer.apple.com/documentation/devicemanagement/appmanaged) · [Setting definitions (YAML, GitHub)](https://github.com/apple/device-management) · [Intro to declarative device management (Apple Platform Deployment)](https://support.apple.com/guide/deployment/depb1bab77f8/web) · [Install and enforce software updates (Apple Platform Deployment)](https://support.apple.com/guide/deployment/depd30715cbb/web)
- The CIS benchmark for iOS (IG1–IG3) and Microsoft's iOS security configuration examples can be turned into a Graph script the same way as Lab 4.6.

Sources: [Apple settings catalog reference](https://learn.microsoft.com/intune/device-configuration/settings-catalog/ref-apple-settings) · [Update policies for Apple devices](https://learn.microsoft.com/intune/device-updates/apple/) · [Deprecated MDM update policies](https://learn.microsoft.com/intune/device-updates/apple/deprecated-mdm-policies-ios)

## 6. Apps

- **iOS store app:** for personal devices; the user installs it with their own Apple Account. The store country in the app link can break installs (trainer experience).
- **Apps and Books (VPP):** buy or get apps in Apple Business, assign them to a location, sync them to Intune with the **Apple VPP token** (Tenant administration → Connectors and tokens). Device licensing needs no Apple Account on the device; user licensing does. New assignments use device licensing by default. The token is valid one year; expiry stops the sync.
- VPP token **Management type DDM:** iOS/iPadOS 18 or later, only **Required** and **Uninstall** assignments, no app configuration policies yet. Don't re-upload an existing token as DDM if it has available assignments – they are lost.
- **Per-app VPN** is set in the app assignment and needs a VPN profile. iOS starts the VPN automatically when the app opens. Android Enterprise supports per-app VPN too (Cisco, F5, Pulse, Microsoft Tunnel and others), but opening the app doesn't start the VPN – that needs always-on VPN. Windows has per-app VPN in the VPN profile.
- **App configuration:** Outlook has a configuration designer; most apps need the keys from the vendor. For Teams, the notification keys (`com.microsoft.teams.chat.notifications.IntuneMAMOnly` and the channel/other variants, value `1`) belong in a **Managed apps** configuration policy together with the app protection setting **Org data notifications = Block org data**. A Managed apps policy is assigned to users and works on enrolled and unenrolled devices alike.
- Own PDFs or e-books can't be distributed with Intune; e-books come through Apps and Books.

Sources: [App configuration overview](https://learn.microsoft.com/intune/app-management/configuration/overview#apps-that-support-app-configuration) · [Manage Apple VPP apps](https://learn.microsoft.com/intune/app-management/deployment/manage-vpp-apple) · [Microsoft Tunnel – VPN profile](https://learn.microsoft.com/intune/device-security/microsoft-tunnel/install#create-a-vpn-profile) · [Android Enterprise VPN settings](https://learn.microsoft.com/intune/device-configuration/templates/ref-vpn-settings-android-enterprise) · [Configure Teams for iOS and Android](https://learn.microsoft.com/intune/app-management/configuration/configure-teams-mobile)

<!-- VERIFY before slides: Edge "Chromium keys" wording (Learn configure-edge-ios-android lists com.microsoft.intune.mam.managedbrowser.* keys and some Edge policy names); "restricted apps: Android can't"; private mailbox disappearing when Outlook becomes managed. Left out of the notes on purpose. -->

## 7. Compliance and app protection

- iOS compliance: **Jailbroken devices = Block**, minimum OS version, **Require a password**, and mark the device noncompliant immediately. **Restricted apps** marks the device noncompliant when a listed app is installed.
- Two different leaks need two different tools: a private mail app next to a managed Outlook is handled by managed open-in (device restrictions); a private account inside the managed Outlook is handled only by app protection (multi-identity).
- **App PIN** is shared by all apps of the same publisher. Defaults: 5 PIN attempts, offline grace period 1440 minutes (block access), 90 days (wipe data).
- **App PIN when device PIN is set = Not required** skips the app PIN only on **enrolled** devices with the Company Portal and the `IntuneMAMUPN` app configuration (Intune SDK 7.0.1 or later). On unenrolled devices the app PIN still applies.
- When paste is blocked, the app shows "Your organization's data cannot be pasted here." (lab observation).
- Trainer recommendation: use app protection on every iOS device, enrolled or not.

Sources: [iOS app protection settings](https://learn.microsoft.com/intune/app-management/protection/ref-settings-ios)

## 8. Passwordless and passkeys

- `aka.ms/mfasetup` opens **Security info**. There you add Microsoft Authenticator; **Enable phone sign-in** registers the device and turns on passwordless sign-in with number matching.
- **Passkeys in Microsoft Authenticator are device-bound** – they don't sync. The phone needs Android 14 or iOS 17 or later, and the passkey profile in Microsoft Entra ID must allow Authenticator. Device registration isn't a prerequisite for the passkey.
- **Synced passkeys** (iCloud Keychain, Google Password Manager and third-party providers like 1Password or Bitwarden) are generally available in Microsoft Entra ID since March 2026, controlled with passkey profiles.
- Using a passkey from a phone on another computer (cross-device) needs Bluetooth on both devices. Without Bluetooth – like on the lab VMs – Windows falls back to a USB security key.
- A passkey is bound to the sign-in domain (relying party), which makes it phishing-resistant.
- Authenticator can hold accounts from several tenants (no guest accounts for phone sign-in).
- On Windows, a **Microsoft Entra passkey on Windows** stores a device-bound passkey in the local Windows Hello container – the device doesn't have to be joined or registered. It complements Windows Hello for Business, it doesn't replace it.

Sources: [Synced passkeys](https://learn.microsoft.com/entra/identity/authentication/how-to-synced-passkeys) · [What's new in Microsoft Entra, March 2026](https://learn.microsoft.com/entra/fundamentals/whats-new#march-2026) · [Passkeys in Microsoft Authenticator](https://learn.microsoft.com/entra/identity/authentication/how-to-enable-authenticator-passkey) · [Microsoft Entra passkey on Windows](https://learn.microsoft.com/entra/identity/authentication/how-to-authentication-entra-passkeys-on-windows)
