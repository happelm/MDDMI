---
title: 'Morning review – Day 4'
---

# Morning review – Day 4

Think each question through – ideally with your neighbor – before you open the answer. There is rarely one right sentence; the answer shows the reasoning behind it.

<details markdown="1">
<summary><strong>1. A colleague wants to "clean up" the tenant and disconnect the Managed Google Play binding that "some trainee" created with a Gmail account. What happens?</strong></summary>

Every Android Enterprise device loses its management. The binding belongs to the tenant: every enrollment type and every Managed Google Play app depends on it. Microsoft recommends binding with a Microsoft Entra account for new tenants; existing Gmail bindings stay supported. Make sure the Google account is one the company controls and can reach. (Lab 4.1)

</details>

<details markdown="1">
<summary><strong>2. A user enrolled a corporate phone with a personal work profile. Now IT wants it fully managed. Can you switch it in Intune?</strong></summary>

No. The enrollment type is decided at the first boot – personal work profile, corporate-owned work profile, fully managed or dedicated. Changing it needs a factory reset and a new enrollment with the right method (for corporate devices: token or QR code, Knox Mobile Enrollment or zero-touch). Decide the type before the devices go out. (Labs 4.2, 4.5)

</details>

<details markdown="1">
<summary><strong>3. Why did the trainer warn twice before you turned on web enrollment for personally owned work profiles?</strong></summary>

It applies to the whole tenant and **can't be reversed** – test it in a test tenant first. With it, personally owned work profiles use Google's Android Management API: the Microsoft Intune app replaces the Company Portal as the user's app, and Android Device Policy enforces the policies. Already enrolled devices move only with a **Move to Android Management API** profile (Android 9 or later, no rollback). And if passkeys are the only allowed sign-in method in your tenant, don't turn it on yet. (Lab 4.2)

</details>

<details markdown="1">
<summary><strong>4. In Lab 4.2 you prepared compliance, Conditional Access and Outlook first, and enrolled last. Why that order?</strong></summary>

That is how most BYOD users meet Intune: through an app that refuses to work. Outlook is blocked by Conditional Access, the user selects **Get started**, and the enrollment follows from there – work profile, screen lock, work apps, registration. If the device had been enrolled first, you wouldn't have seen how Conditional Access drives the enrollment. It also means your policies are in place before the first device arrives. (Lab 4.2)

</details>

<details markdown="1">
<summary><strong>5. Your BYOD compliance policy requires a password with complexity Low. A user sets the PIN 1234. Compliant? What would Medium change?</strong></summary>

Compliant – **Low** allows repeating or ordered PINs like `1234`. **Medium** needs at least 4 characters and blocks repeating and ordered PINs; **High** needs at least 8 (6 for alphabetic or alphanumeric). Also note which password you require: **Require a password to unlock mobile devices** covers the device, and by default the device and the work profile share one lock. If you require only the work profile password, only the work profile asks for a PIN. (Lab 4.2)

</details>

<details markdown="1">
<summary><strong>6. A user forgot the work profile PIN. The helpdesk selects Reset passcode, but the action does nothing useful. The compliance policy clearly requires a passcode. Why doesn't it work?</strong></summary>

Compliance only **checks**. **Reset passcode** works only when a **device configuration profile** enforces the passcode – that is what gives Intune control over it. Compliance checks, configuration enforces. With a configuration profile in place, the new passcode shows in the admin center for 7 days. (Lab 4.3, Day 4 notes)

</details>

<details markdown="1">
<summary><strong>7. Two compliance policies check the minimum password length, one with 4 and one with 6. A configuration profile sets 8. What does the device have to meet?</strong></summary>

Between two compliance policies, the most restrictive value wins – 6. Between a compliance policy and a configuration profile, the compliance policy wins. So the compliance result is measured against 6, whatever the configuration profile says. Keep each setting in one place to avoid surprises. (Lab 4.4, Day 4 notes)

</details>

<details markdown="1">
<summary><strong>8. A new Windows device has no compliance policy assigned yet. Conditional Access requires a compliant device. Does the user get to Outlook?</strong></summary>

By default yes – Intune marks devices with no compliance policy assigned as **Compliant**. That is the gap **Mark devices with no compliance policy assigned as = Not compliant** closes; Microsoft recommends it as soon as you use Conditional Access. The second tenant-wide setting, the **compliance status validity period** (default 30 days), decides how long a device stays compliant without checking in – in the lab you set it to 7. (Lab 4.4)

</details>

<details markdown="1">
<summary><strong>9. Fully managed phones get their apps and policies only hours after enrollment. What did Lab 4.5 do about that?</strong></summary>

**Enrollment time grouping**: the enrollment profile puts the device into a static group during enrollment, so apps and policies arrive right away instead of up to 8 hours later. It needs a static group owned by the **Intune Provisioning Client**, works only for new enrollments and not with the staging token. Failures show in Devices → Monitor → Enrollment time grouping failures. (Lab 4.5)

</details>

<details markdown="1">
<summary><strong>10. You assign COBO device restrictions to <code>All Android Devices</code>. Why add a filter, and why on <code>deviceManagementType</code> instead of the enrollment profile name?</strong></summary>

`All Android Devices` also contains BYOD phones; the filter narrows the assignment to fully managed devices at check-in. `deviceManagementType` describes how the device is enrolled and doesn't change. A filter on the enrollment profile name breaks when someone renames the profile, because enrolled devices keep the old name. Also check that you used the right section of the device restrictions: **Fully managed, dedicated, and corporate-owned work profile** – a BYOD section doesn't apply to a COBO device. (Lab 4.5)

</details>

<details markdown="1">
<summary><strong>11. Your in-house APK works on the fully managed phones. Now the BYOD users need it too. Same upload?</strong></summary>

No. A line-of-business APK can be uploaded directly only for fully managed and dedicated devices. Corporate-owned work profiles and personal devices need a **private app** in Managed Google Play, with a package name that is unique in Google Play. (Lab 4.5)

</details>

<details markdown="1">
<summary><strong>12. You saved a new Android configuration profile with a group assignment. Next morning, no device has it. What do you check first?</strong></summary>

The assignment itself. On new Android configuration profiles the group assignment sometimes isn't saved (trainer observation) – open the profile again and check that the group is still there. Only then look at the device side. (Labs 4.3, 4.5)

</details>

<details markdown="1">
<summary><strong>13. A customer believes they need Knox licenses to block the hotspot on Samsung phones and to set a wallpaper. What do you tell them?</strong></summary>

Neither needs Knox. **Tethering and access to hotspots = Block** in the device restrictions (corporate-owned section) turns off the hotspot. A wallpaper comes from the Managed Home Screen in kiosk mode or from Microsoft Launcher on fully managed devices. Where Knox does help – the Knox Service Plugin through OEMConfig – the Knox Platform for Enterprise Premium license has been free since July 1, 2021 (Samsung). (Day 4 notes)

</details>
