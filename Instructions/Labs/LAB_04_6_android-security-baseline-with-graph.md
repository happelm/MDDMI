---
title: 'Lab 4.6 – Android security baseline with Graph'
lab:
    title: 'Lab 4.6 – Android security baseline with Graph'
    module: 'Day 4 – Android'
---

# Lab 4.6 – Android security baseline with Graph

**Estimated time:** 20 minutes (if time permits)

**Goal:** Create Microsoft's "fully managed basic security (level 1)" example with one script instead of clicking through two policies, and check that the script did what Learn says.

**Why:** Microsoft publishes recommended settings for Android Enterprise in three levels. Level 1 is the minimum for corporate-owned devices. A script built from that table is repeatable and reviewable – and an AI assistant can write most of it if you give it the right sources.

1. Open the Learn page [Android Enterprise fully managed security configurations](https://learn.microsoft.com/intune/device-security/security-configurations/android-fully-managed) and look at the two level 1 tables: **Device compliance** and **Device restrictions**.
2. vLab host: download `New-AndroidFMLevel1.ps1` from the [Labfiles](https://github.com/happelm/MDDMI/tree/main/Labfiles) folder to `C:\Scripts`. Open it in an editor and find each Learn setting in the script. Every setting has a comment with its name in the admin center.
3. vLab host: run the script and sign in with your tenant admin. Accept the permission request.

   ```powershell
   cd C:\Scripts
   PowerShell.exe -ExecutionPolicy Bypass -File .\New-AndroidFMLevel1.ps1
   ```

4. Intune admin center → Devices → Compliance: open `AE COBO ZT Level 1 Compliance` and compare the settings with the Learn table. Do the same for `AE COBO ZT Level 1 Device Restrictions` in Devices → Configuration. Both are not assigned yet.
5. Run the script a second time. It skips both policies because they already exist.

### Checkpoint

- [ ] `AE COBO ZT Level 1 Compliance` and `AE COBO ZT Level 1 Device Restrictions` exist without assignment
- [ ] The settings in the admin center match the level 1 tables on Learn
- [ ] The second run skips both policies

**Note:** By default the script assigns nothing. With `-Assignment` it assigns both new policies to `All Android Devices`, or to another group with `-GroupName`. They apply only to fully managed, dedicated and corporate-owned work profile devices, not to personal devices with a work profile.

**Note:** The profile blocks **Factory reset** in the device settings. Assign it only when you no longer need to reset your test device by hand. A wipe from Intune still works.

**Why the password is in both policies:** The device restrictions profile **enforces** the password: Android asks the user to set one, and only this profile can wipe the device after 10 failed attempts. The compliance policy **checks** it and reports the result to Conditional Access. **Reset passcode** only works when the passcode requirement comes from a device restrictions profile.

**Note:** For fully managed and corporate-owned work profile devices, compliance still uses **Required password type** and **Minimum password length**. The deprecation of these settings for Android 12 and later applies to personally owned work profiles, where **Password complexity** replaces them.

<details markdown="1">
<summary>How the script was built with AI</summary>

A prompt like this gives an AI assistant everything it needs. The sources matter more than the wording:

```text
Write a Windows PowerShell 5.1 script that creates the "Fully managed basic security (level 1)"
example from https://learn.microsoft.com/intune/device-security/security-configurations/android-fully-managed
as one Intune compliance policy and one device restrictions profile.

- Use Invoke-MgGraphRequest from Microsoft.Graph.Authentication only, Graph beta.
- Resources: androidDeviceOwnerCompliancePolicy and androidDeviceOwnerGeneralDeviceConfiguration.
  Use only property names from their Graph reference pages.
- Map every setting of both level 1 tables and comment each property with its admin center name.
- The compliance policy needs scheduledActionsForRule with one block action, grace period 0.
- Skip a policy if one with the same name exists. Assign new policies only with an -Assignment switch.
- List settings you could not map instead of guessing.
```

Then check the result yourself: compare every property with the Graph reference and every value with the Learn table before you run it in a tenant.

</details>
<!-- Source: Michael 2026-10-22 (Level 1 as Graph script, participants run it, show the AI prompt). Learn: android-fully-managed (level 1 tables), ref-android-enterprise-settings (fully managed compliance still uses password type/length; deprecation note is for personally owned work profile), Graph beta androidDeviceOwnerCompliancePolicy, androidDeviceOwnerGeneralDeviceConfiguration, deviceComplianceScheduledActionForRule. Script parsed without errors; run live in class 2026-10-23 by the trainer (policies created, not assigned). VERIFY mappings: "Time to lock screen" = passwordMinutesOfInactivityBeforeScreenTimeout, "User can configure credentials" = certificateCredentialConfigurationDisabled, "Threat scan on apps" = securityRequireVerifyApps. -->
