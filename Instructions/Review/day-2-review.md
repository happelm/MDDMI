---
title: 'Morning review – Day 2'
---

# Morning review – Day 2

Think each question through – ideally with your neighbor – before you open the answer. There is rarely one right sentence; the answer shows the reasoning behind it.

<details markdown="1">
<summary><strong>1. Your manager compares two lists: Entra ID shows 40 Windows devices, Intune only 32. "Something is broken – fix it." Is something broken?</strong></summary>

Not necessarily. **Registration** puts a device object into Entra ID, **enrollment** puts the device into Intune management. A device can be registered without being enrolled – a hybrid joined PC whose MDM enrollment hasn't run yet, a registered personal device, a device without a license that includes Intune. The lists don't have to match. The question is which of the eight *should* be enrolled, and why they aren't. (Labs 2.3, 2.4)

</details>

<details markdown="1">
<summary><strong>2. A user already has two hybrid joined PCs and an Autopilot laptop. The device limit restriction allows 3. Can the user still enroll a phone?</strong></summary>

Yes. The Intune device limit doesn't count devices enrolled through GPO auto-enrollment, co-management, Windows Autopilot, a work account added in Windows Settings or a device enrollment manager. Those are treated as shared or admin-enrolled devices. Keep in mind that Entra ID has its own device limit for joined and registered devices – that one is separate. (Lab 2.1)

</details>

<details markdown="1">
<summary><strong>3. Two device limit restrictions target the same user: the default with 5 and yours with 10. Which one applies – and what if you create a third one later?</strong></summary>

Only the one with the highest priority applies; the others are ignored for that user. A new restriction is always placed just above the default, so a restriction you create later can end up below the one you meant to win. Check the priority order after every new restriction. (Lab 2.1)

</details>

<details markdown="1">
<summary><strong>4. Your Policy and Profile Manager assignment has the scope group <code>All Windows 11 Devices</code>. Can these admins assign a profile to Android devices? And why can't they create a device limit restriction?</strong></summary>

No to the first: the **scope group** decides which users and devices an admin can target, and Android phones aren't in it. Scope tags decide which objects they can see – both must match. The second has a different cause: some settings need an Entra role no matter which Intune role you have. Creating device limit restrictions needs the Entra role Intune Administrator; every Intune role has read-only access to them. Intune roles limit *where* you act, Entra roles work on the whole tenant. (Lab 2.2)

</details>

<details markdown="1">
<summary><strong>5. A user adds the work account in Teams on a private PC and clicks through the dialog. The next day the PC is in Intune. How did that happen, and how do you stop it?</strong></summary>

Adding a work account in an app or in Edge shows "Allow my organization to manage my device". If the user accepts, the device is registered and – with the MDM user scope covering the user – enrolled. **Disable MDM enrollment when adding work or school account** (Automatic Enrollment, preview) removes that path without affecting Entra join or Autopilot. Trainer recommendation: **Yes** in production; the lab keeps **No**. A platform restriction that blocks personally owned Windows devices is a second layer. (Labs 2.1, 2.3)

</details>

<details markdown="1">
<summary><strong>6. CL3 is Entra joined, not domain joined. Yet User1 opens <code>\\dc1\labfiles</code> without a prompt. How? And why did it fail after the sign-in with the Hello PIN?</strong></summary>

At sign-in the device gets a **Primary Refresh Token**. With line of sight to a DC, the device uses it to get Kerberos tickets for on-premises resources – after a sign-in with the **password**. After a sign-in with **Windows Hello for Business** there is no password to hand over, so the device needs **cloud Kerberos trust** for those tickets. That is outside this course. (Lab 2.3)

</details>

<details markdown="1">
<summary><strong>7. CL2 stays "Pending" in Entra ID for hours. Walk through the chain and name where you would look.</strong></summary>

The chain: SCP in AD → the client reads it and writes `userCertificate` (scheduled task **Automatic-Device-Join**, at every sign-in and every hour) → sync takes the computer to Entra ID (**Pending**) → the client completes the registration and gets a PRT → the GPO triggers the MDM enrollment. **Pending** means the last client step hasn't happened. Run the task or `dsregcmd /join` elevated, then check `dsregcmd /status` (the Diagnostic Data section shows phase and error) and the **User Device Registration** log. The enrollment itself is in **DeviceManagement-Enterprise-Diagnostics-Provider**: event 75 success, 76 failure. (Lab 2.4)

</details>

<details markdown="1">
<summary><strong>8. On CL1, a GPO and an Intune profile set the same setting to different values. Which one wins, and what is the better question to ask?</strong></summary>

By default the GPO wins on a hybrid device. The MDM setting **ControlPolicyConflict/MDMWinsOverGP** reverses that. The better question is who should own this setting at all: decide per setting whether GPO or Intune is responsible, because two sources for the same setting make troubleshooting hard (trainer recommendation). (Lab 2.4)

</details>

<details markdown="1">
<summary><strong>9. CL1 is co-managed after Cloud Attach, but your new Intune configuration profile never arrives. Why?</strong></summary>

With the default settings, Cloud Attach enrolls the client into co-management, but **every workload stays on Configuration Manager**. Each workload has exactly one owner. Until you move the device configuration workload to Intune (for all clients or for a pilot collection), Intune profiles don't reach the device. In Intune its compliance shows **ConfigMgr**. (Lab 2.5)

</details>

<details markdown="1">
<summary><strong>10. You assign a custom OMA-URI starting with <code>./Device/...</code> to a user group. Does it apply to the user or to the device?</strong></summary>

To the device – the CSP path decides the scope, not the group type. The group only decides which devices get the profile: a user group delivers it to the devices that user signs in to. `./User/...` paths apply to the signed-in user. Templates, the settings catalog and custom OMA-URI all end up as CSP settings, so the CSP reference tells you path, format and scope. (Lab 2.6)

</details>

<details markdown="1">
<summary><strong>11. Two of your configuration profiles set the same setting to different values. What does Intune do?</strong></summary>

Nothing – Intune doesn't resolve conflicts between configuration profiles. The setting shows **Conflict**, and the device keeps whatever it had. You have to fix it by removing the setting from one profile. A naming pattern and clear ownership per setting prevent most of these conflicts. (Lab 2.6)

</details>

<details markdown="1">
<summary><strong>12. You want <code>Win CO Device Restrictions</code> only on corporate devices. Why a filter instead of excluding a group of personal devices?</strong></summary>

You can't mix user and device groups across include and exclude, and exclusions based on dynamic groups are risky: while a group is still being calculated, a device can briefly fall outside the exclusion. A filter is evaluated at check-in from the device's own properties – here `deviceOwnership -eq "Corporate"` – with no group calculation involved. A tenant can have up to 200 filters. (Lab 2.6)

</details>

<details markdown="1">
<summary><strong>13. A project plan says: "Week 1 – migrate all 300 GPOs with Group Policy analytics." What is wrong with that plan?</strong></summary>

It migrates 1:1. Group Policy analytics shows per setting whether an MDM equivalent exists – use that report to decide what you still need; many old settings are no longer relevant. Preferences and firewall rules don't come over at all (firewall rules belong in an Endpoint security policy). **Migrate** creates a settings catalog policy: leave it unassigned and review it before you use it. (Lab 2.7)

</details>
