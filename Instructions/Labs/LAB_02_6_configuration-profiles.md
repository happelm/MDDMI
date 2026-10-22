---
title: 'Lab 2.6 – Configuration profiles'
lab:
    title: 'Lab 2.6 – Configuration profiles'
    module: 'Day 2 – Windows management'
---

# Lab 2.6 – Configuration profiles

**Estimated time:** 60 minutes
<!-- VERIFY: duration -->

**Goal:** Deploy settings with a template, a custom OMA-URI, the settings catalog and the properties catalog, and narrow assignments with assignment filters.

All profiles: Intune admin center → Devices → Configuration → **Create** → **New policy** → platform **Windows 10 and later**.

1. Templates → **Device restrictions**: profile `Win CO Device Restrictions` with General → **End processes from Task Manager** = Block and Start → hide **Recently added apps** and **Most used apps**. Assign it to `All Windows 11 Devices`.
2. Intune admin center → Tenant administration → **Assignment filters** → **Create** → **Managed devices**: filter `Win Corporate Devices`, platform **Windows 10 and later**, rule:

   ```text
   (device.deviceOwnership -eq "Corporate")
   ```

   Select **Preview devices**: CL1, CL2 and CL3 are listed. Save the filter.
3. Open `Win CO Device Restrictions` → Properties → Assignments → **Edit filter** → **Include filtered devices in assignment** → `Win Corporate Devices`.
4. Templates → **Custom**: profile `Win CO CS Daily Reboot` with one OMA-URI setting, data type **String**, value: today at 18:00 in ISO 8601 format, for example `2026-10-20T18:00:00`. Assign it to `All Windows 11 Devices`.

   ```text
   ./Device/Vendor/MSFT/Reboot/Schedule/DailyRecurrent
   ```

5. **Settings catalog**: profile `Win CO SC OneDrive Settings` with OneDrive → **Silently sign in users to the OneDrive sync app with their Windows credentials** = Enabled. Assign it to `Cloud Users`.
6. **Properties catalog**: profile `Win Inventory` with all property classes except Registry. Assign it to `All Windows 11 Devices`.
7. CL3: Access work or school → your account → Info → **Sync**. Then check:
    - Task Manager: **End task** is blocked.
    - Access work or school → Info → **Create report**: the profiles are listed.
8. Intune admin center → Devices → Windows → CL3 → **Device configuration**: status per profile. Open a profile → **Device assignment status** → **Generate report**.

### Checkpoint

- [ ] All profiles show **Succeeded** for CL3
- [ ] `Win Corporate Devices` preview lists CL1–CL3
- [ ] CL3 restarts at 18:00

**Note:** A tenant can have up to 200 assignment filters. You can't mix user and device groups in exclusions – use a filter instead.

**Note:** Properties catalog data shows up in Resource Explorer after up to 24 hours.

**Note:** A device checks in about every 8 hours on its own. A manual sync or a restart speeds things up – the portal status follows the device, not the other way round.

**Why:** Templates, settings catalog and custom OMA-URI all end up as CSP settings on the device. The CSP documentation on Learn tells you path, format and scope of every setting.
<!-- Source: Day 2 recording 2026-10-20 (PM) and Michael's decisions 2026-10-20 (names without hyphens). 2026-10-22 Michael: trusted root certificate exercise removed here – it is the same exercise on Android (Day 4). Learn: Reboot CSP (DailyRecurrent, ISO 8601), "Assignment filter properties" (deviceTrustType "Azure AD joined", deviceOwnership), filters overview (200). VERIFY: properties catalog class list / Resource Explorer wording. -->
