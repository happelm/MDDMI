---
title: 'Review – Day 5'
---

# Review – Day 5

For the end of the course or for later: think each question through before you open the answer. There is rarely one right sentence; the answer shows the reasoning behind it.

<details markdown="1">
<summary><strong>1. The Apple MDM push certificate expired ten days ago. A colleague wants to fix it quickly with "Create a Certificate". Stop them – why, and what is the right move?</strong></summary>

A new certificate breaks the link to every enrolled Apple device – all of them must enroll again. After expiry there is a **30-day grace period**: select **Renew** for the existing certificate in the Apple Push Certificates Portal, with the **same Apple Account**, and upload the renewed certificate in Intune. Miss the grace period and you are in the same place as with a new certificate. (Lab 5.1)

</details>

<details markdown="1">
<summary><strong>2. The admin who created the push certificate with their own Apple Account leaves the company. Why is that a problem next year, and how do you avoid it?</strong></summary>

You must renew with the same Apple Account – without access to it, you can only create a new certificate, and every device re-enrolls. Use a company Apple Account whose mailbox several admins can reach, put the renewal date in more than one calendar, and renew the push certificate, the ADE token and the VPP token on the same day once a year (trainer recommendation). For the lab, a personal Apple Account was fine. (Lab 5.1)

</details>

<details markdown="1">
<summary><strong>3. Works council requirement: "IT must never be able to wipe a private iPhone." Which iOS options are left?</strong></summary>

**App protection only** (no enrollment): IT protects and selectively wipes the data in Outlook, Teams and the other protected apps – nothing else. **Account-driven user enrollment**: IT manages a separate managed Apple account volume, Wi-Fi, VPN, certificates and managed apps, but can only retire, not wipe; it needs managed Apple accounts and the service discovery file on your web server. **Device enrollment** is out – it allows a full wipe. App protection applies on top of every option. (Labs 5.2, 5.4, Day 5 notes)

</details>

<details markdown="1">
<summary><strong>4. You assigned <code>iOS CO Update Settings (SC)</code> with a 2-day deferral to device-enrolled BYOD iPhones. Nothing changes on them. Why?</strong></summary>

Two reasons can stack. **Deferrals**, **Automatic actions** and **Beta program enrollment** in the DDM Software Update Settings work only on **supervised** devices – that means automated device enrollment, not device enrollment. And the Software Update Settings need iOS/iPadOS 18 or later. Enforcing a target version with a deadline is a separate declaration and needs iOS/iPadOS 17 or later. (Lab 5.2)

</details>

<details markdown="1">
<summary><strong>5. A colleague who manages Windows asks: "So the iOS deferral is like our deadline?" Explain the difference.</strong></summary>

A deferral **hides** an update for 1–90 days; it doesn't install it. A Windows deadline does the opposite: once it has passed, the update installs and the restart is forced. On iOS, enforcing a version by a date is the separate **Software Update Enforcement Specific** declaration. (Lab 5.2, Day 3)

</details>

<details markdown="1">
<summary><strong>6. The lock screen of an iPhone still shows the text of Teams chats although you created <code>iOS Teams Config</code>. What is missing?</strong></summary>

The configuration key alone isn't enough. The notification keys belong in a **Managed apps** configuration policy and work together with **Org data notifications = Block org data** in an app protection policy – then the lock screen shows "You have a new message" instead of the chat text. A Managed apps policy is assigned to users and works on enrolled and unenrolled devices. It refreshes every 30 minutes when an app protection policy is assigned, otherwise only every 720 minutes. (Labs 5.3, 5.4)

</details>

<details markdown="1">
<summary><strong>7. On an enrolled iPhone, a user copies text from the managed Outlook into a private mail app – and on another iPhone, the user has added a private account inside the managed Outlook. Which tool stops which leak?</strong></summary>

The first is a leak **between apps**: managed open-in on enrolled devices separates managed from unmanaged apps (**Block viewing corporate documents in unmanaged apps**, **Allow copy/paste to be affected by managed open-in**). The second is a leak **inside one app**: only app protection separates the work account from the private account in the same Outlook (multi-identity). That is why the trainer recommends app protection on every iOS device, enrolled or not. (Labs 5.2, 5.4)

</details>

<details markdown="1">
<summary><strong>8. In the optional part of Lab 5.4, User2 signs in to Outlook on a private, unenrolled iPhone. CA-001 requires a compliant device for <code>Cloud Users</code>. How did the lab make that work without weakening the other platforms?</strong></summary>

An unenrolled iPhone can never be compliant, so CA-001 would block it. The lab excludes iOS from CA-001 and adds `CA-002 Office 365 App Protection for iOS` with **Require app protection policy**. iOS users now need a protected app instead of a compliant device; Windows and Android still need compliance. (Lab 5.4)

</details>

<details markdown="1">
<summary><strong>9. Your app protection policy says "App PIN when device PIN is set = Not required". The user on the unenrolled iPhone still gets an app PIN prompt. Is the policy broken?</strong></summary>

No. The setting skips the app PIN only on **enrolled** devices with the Company Portal and the `IntuneMAMUPN` app configuration – Intune can't know the device PIN of an unenrolled phone. And because apps from the same publisher share one app PIN, the user sets it once in Outlook and Teams doesn't ask again. (Lab 5.4)

</details>

<details markdown="1">
<summary><strong>10. A hospital wants shared iPhones for nurses with Teams, protected by Conditional Access and app protection. Shared iPad or Microsoft Entra shared device mode?</strong></summary>

**Shared device mode.** Shared iPad is iPad only and supports neither Conditional Access nor app protection. Shared device mode works on iPhone and iPad, needs no federation, and signing out in one supporting app signs the user out of all of them. It is set up with automated device enrollment without user affinity, the Enterprise SSO plug-in and Authenticator. Don't combine the two. (Day 5 notes)

</details>

<details markdown="1">
<summary><strong>11. Corporate iPhones have no Apple Account. How do they get App Store apps – and what changes with the VPP token management type DDM?</strong></summary>

Through **Apps and Books** in Apple Business: assign the apps to a location and sync them to Intune with the Apple VPP token. With **device licensing** (the default for new assignments) the device needs no Apple Account. Management type **DDM** needs iOS/iPadOS 18 or later and supports only Required and Uninstall – no Available assignments and no app configuration policies yet. Don't re-upload an existing token with Available assignments as DDM; they are lost. (Lab 5.3, Day 5 notes)

</details>

<details markdown="1">
<summary><strong>12. A user created a passkey in Authenticator on their phone, then loses the phone. What happens to the passkey – and what would synced passkeys change?</strong></summary>

Passkeys in Microsoft Authenticator are **device-bound**: they don't sync, so the passkey is gone with the phone and the user registers a new one on the new phone. **Synced passkeys** (iCloud Keychain, Google Password Manager, third-party providers such as 1Password or Bitwarden) are generally available in Entra ID since March 2026, controlled with passkey profiles – they survive a lost phone, at the price that the key lives in a provider's cloud. Either way the passkey is bound to the sign-in domain, which makes it phishing-resistant. (Lab 5.5)

</details>

<details markdown="1">
<summary><strong>13. In the lab, the passkey on the phone couldn't be used to sign in on the VM; Windows offered a USB security key instead. Why, and how did you sign in?</strong></summary>

Using a phone's passkey on another computer (cross-device) needs **Bluetooth on both devices** – the lab VMs have none. So you used **Approve a request on my Microsoft Authenticator app**: phone sign-in with number matching, also without a password. (Lab 5.5)

</details>
