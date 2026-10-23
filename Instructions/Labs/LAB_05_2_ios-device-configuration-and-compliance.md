---
title: 'Lab 5.2 – iOS device configuration and compliance'
lab:
    title: 'Lab 5.2 – iOS device configuration and compliance'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.2 – iOS device configuration and compliance

**Estimated time:** 30 minutes

**Goal:** Build a device restrictions profile, a declarative software update policy and a compliance policy for iOS/iPadOS – without a device, so nothing is assigned.

## Device restrictions

1. Intune admin center → Devices → Configuration → Create → New policy → **iOS/iPadOS** → Templates → **Device restrictions**: profile `iOS CO Device Restrictions`. Look at the blocks: settings for **all enrollment types**, for **device enrollment and automated device enrollment**, and for **automated device enrollment (supervised)** only.
2. App Store, Doc Viewing, Gaming:

   | Setting | Value |
   |---|---|
   | Block viewing corporate documents in unmanaged apps | Yes |
   | Allow unmanaged apps to read from managed contacts accounts | Yes |
   | Allow copy/paste to be affected by managed open-in | Yes |

   Create the profile without assignment.

## Software updates with declarative device management

3. Configuration → Create → New policy → **iOS/iPadOS** → **Settings catalog**: profile `iOS CO Update Settings (SC)`. Add settings → **Declarative Device Management (DDM)** → **Software Update Settings**:

   | Setting | Value |
   |---|---|
   | Deferrals → combined deferral period | 2 days |
   | Beta → Program enrollment | Always Off |
   | Automatic actions → Download, Install OS updates, Install security update | Always On |

   Create it without assignment.

## Compliance

4. Devices → Compliance → Create policy → **iOS/iPadOS**: policy `iOS Basic Compliance`:

   | Setting | Value |
   |---|---|
   | Device Health → Jailbroken devices | Block |
   | System Security → Require a password to unlock mobile devices | Require |
   | System Security → Required password type | Numeric |
   | System Security → Minimum password length | 4 |
   | Actions for noncompliance → Mark device noncompliant | Immediately |

   Look at **Restricted apps** and **Minimum OS version**. Create it without assignment.

### Checkpoint

- [ ] `iOS CO Device Restrictions`, `iOS CO Update Settings (SC)` and `iOS Basic Compliance` exist
- [ ] You can name one setting that needs a supervised (ADE) device

**Note:** The device restrictions template is no longer updated – Microsoft recommends the settings catalog for new policies. The lab uses the template because it shows which enrollment type a setting needs.

**Note:** The DDM **Software Update Settings** need iOS/iPadOS 18 or later. **Deferrals**, **Automatic actions** and **Beta program enrollment** work only on supervised devices, so they affect only devices from automated device enrollment. Enforcing a target version with a deadline is a separate declaration and needs iOS/iPadOS 17 or later.

**Note:** A deferral hides an update for that many days, it doesn't install it – unlike the Windows deadline from Day 3.

**Note:** A device group for iOS must also include iPads – they report iPadOS (trainer).

**Why:** Configuration enforces, compliance checks. On iOS, many restrictions depend on the enrollment type, so plan the enrollment before the policies.
<!-- Source: Day 5 recording 2026-10-23 01:54–02:31 and 02:56–02:59. Learn ref-apple-settings (template no longer updated), Apple developer SoftwareUpdateSettings (iOS 18, supervised-only keys), SoftwareUpdateEnforcementSpecific (iOS 17). Replaces the old "Enroll an iPhone" lab (not run, no devices; Michael 2026-10-23). VERIFY: exact setting labels in the DDM settings catalog and the compliance password type label. -->
