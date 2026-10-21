---
title: 'Lab 1.4 – Groups and Company Portal'
lab:
    title: 'Lab 1.4 – Groups and Company Portal'
    module: 'Day 1 – Foundation and hybrid identity'
---

# Lab 1.4 – Groups and Company Portal

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

**Goal:** Build the dynamic device groups the later labs assign to and brand the Company Portal.

Use English for object names and fill in a description for every object you create.

1. Entra admin center → Groups → New group: security group `All Windows 11 Devices`, membership type **Dynamic Device**, with this rule:

   ```text
   (device.deviceOSType -eq "Windows") and (device.deviceOSVersion -startsWith "10.0.2")
   ```

2. Create a second dynamic device group `All Android Devices` with this rule:

   ```text
   (device.deviceOSType -startsWith "Android")
   ```

3. For user assignments in this course you use the synced group `Cloud Users` from Lab 1.3 – no new user group needed.
4. Intune admin center → Tenant administration → Customization → **Default** → Edit:

   | Setting | Value |
   |---|---|
   | Organization name | Your custom domain |
   | Color | Your choice |
   | Logo | `C:\Scripts\ETCLogoTransparent.png` |
   | IT contact | Your choice |
   | Privacy statement URL | Any URL (required) |
   | Hide Remove and Reset buttons on corporate Windows devices | **Yes** |

5. Check the result on the Company Portal website.
6. Optional: compare Intune admin center → Tenant administration → Terms and conditions with Entra admin center → Conditional Access → Terms of use.

### Checkpoint

- [ ] `All Windows 11 Devices` and `All Android Devices` exist with a dynamic rule
- [ ] Company Portal customization saved with Remove and Reset hidden

**Note:** Dynamic groups are not real time – a new device can take minutes to show up. For time-critical assignments use **All devices** with a filter.

**Note:** `10.0.2` is deliberately broad: it catches every Windows 11 build. Windows Server reports `deviceOSType` as "Windows Server", so the `-eq "Windows"` part keeps servers out.

**Note:** Hide Remove and Reset only works in the **Default** customization policy. Additional customization policies (up to 25) can only target user groups.

**Why hide the buttons:** A user who sees a Reset button will press it.
<!-- Source: Day 1 recording 2026-10-19 (PM 02:46–03:26). Server deviceOSType "Windows Server": Michael's lab finding 2026-10-20. VERIFY: exact label of the hide setting; Android OS type strings (Learn examples: AndroidEnterprise, AndroidForWork). -->
