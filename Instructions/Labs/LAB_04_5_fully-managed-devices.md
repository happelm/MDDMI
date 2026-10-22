---
title: 'Lab 4.5 – Fully managed devices'
lab:
    title: 'Lab 4.5 – Fully managed devices'
    module: 'Day 4 – Android'
---

# Lab 4.5 – Fully managed devices

**Estimated time:** 120 minutes

**Goal:** Turn the BYOD test device into a corporate-owned fully managed device (COBO) by QR code, with a naming template, enrollment time grouping, compliance, restrictions with a filter and corporate apps.

## Prepare the enrollment

1. Entra admin center → Groups → New group: security group `All Android COBO Devices`, membership type **Assigned**. Under **Owners** add the service principal **Intune Provisioning Client** (in some tenants it is listed as **Intune Autopilot ConfidentialClient**).
2. Intune admin center → Devices → Enrollment → **Android** tab → **Corporate-owned, fully managed user devices** → Create profile:

   | Setting | Value |
   |---|---|
   | Name | `AE COBO` |
   | Token type | Corporate-owned, fully managed (default) |
   | Apply device name template | Yes |
   | Device name template | `{{DEVICETYPE}}-{{SERIALLAST4DIGITS}}` |
   | Device group | `All Android COBO Devices` |

3. Open the profile → **Token**: you see the token and the QR code. Keep this page open.

## Retire and enroll

4. Intune admin center → Devices → Android → your BYOD device → **Retire**. The work profile disappears from the phone.
5. Android test device: Settings → General management → Reset → **Factory data reset**. Confirm with the PIN. Use only the test device, never your own phone.
6. On the welcome screen, tap the same spot about ten times until the QR code reader opens (Samsung: select the language first). Scan the QR code of **your** `AE COBO` profile – use the Intune QR code, not a self-made one.
7. Connect to Wi-Fi and follow the setup: *Your organization manages this phone* → *This device isn't private* → accept. Sign in as User1. Microsoft Intune and Microsoft Authenticator install, then the apps you assigned earlier (Outlook, Edge, LinkedIn).

## Compliance and restrictions

8. The device has no PIN yet and no compliance policy for corporate devices. Devices → Compliance → Create policy → Android Enterprise → **Fully managed, dedicated, and corporate-owned work profile**: policy `AE CO Basic Compliance`:

   | Setting | Value |
   |---|---|
   | Rooted devices | Block |
   | Require a password to unlock mobile devices | Require |
   | Required password type | At least numeric |
   | Minimum password length | 4 |
   | Mark device noncompliant | Immediately |

   Assign it to `Cloud Users`.
9. Phone: when it reports noncompliant, open the Intune app → your device, set a PIN (`1234`) and check the status again. Outlook opens when the device is compliant.
10. Tenant administration → Assignment filters → Create → **Managed devices**, platform **Android Enterprise**: filter `AE COBO` with the rule **deviceManagementType Equals Corporate-owned fully managed**:

    ```text
    (device.deviceManagementType -eq "Corporate-owned fully managed")
    ```

    The preview lists your phone.
11. Devices → Configuration → Create → Android Enterprise → Templates → **Device restrictions** in the section **Fully managed, dedicated, and corporate-owned work profile**: profile `AE CO Device Restrictions`:

    | Setting | Value |
    |---|---|
    | Date and Time changes | Block |
    | USB file transfer | Block |
    | Locate device | Allow |

    **Don't** set **Factory reset protection emails** – a lab phone with someone else's Google account in it can't be set up again. Assign the profile to `All Android Devices` with the filter `AE COBO` (**Include**) and check the group after saving.

## Apps and contacts

12. Apps → Android → Create → **Line-of-business app**: upload `C:\Scripts\intunepro.apk`. Assign it as **Required** to `Cloud Users`.
13. Apps → Android → Create → **Android Enterprise system app**:

    | Setting | Value |
    |---|---|
    | App name | `Samsung Gallery` |
    | Publisher | `Samsung` |
    | Package name | `com.sec.android.gallery3d` |

    Assign it as **Required** to `Cloud Users`. Intune turns on the hidden gallery app – it doesn't install anything.
14. CL3, signed in as User1: copy `C:\Scripts\DemoOutlookContacts.csv` to `C:\Temp`. Outlook on the web → People → **Import contacts** → select the CSV. The contacts show up in the phone's Contacts app.
15. Intune admin center → your phone → **Locate device**.

### Checkpoint

- [ ] The phone is named `<device type>-<last 4 digits of the serial>`, ownership **Corporate**, OS entry fully managed
- [ ] The phone is a member of `All Android COBO Devices` right after enrollment
- [ ] `AE CO Basic Compliance` compliant after setting the PIN
- [ ] `AE CO Device Restrictions` **Succeeded**; the date and time can't be changed on the phone
- [ ] Intune Pro and the Samsung Gallery are on the phone, the imported contacts are in Contacts
- [ ] **Locate device** shows the phone on the map

## Optional

- Create the trusted root certificate again for fully managed devices (`AE CO Smart PKI Root Certificate`) with the `.cer` from Lab 4.3.
- Devices → Configuration → Create → Android Enterprise → **Wi-Fi** (fully managed): profile `AE CO Fake WiFi`, type **Basic**, security **WPA pre-shared key**, any SSID and key.

**Note:** Enrollment time grouping puts the device into the group during enrollment, so apps and policies arrive right away. It works only with a static group whose owner is the Intune Provisioning Client, only for new enrollments, and not with the staging token. Failures show in Devices → Monitor → **Enrollment time grouping failures**. If the service principal is missing in your tenant, Learn shows how to add it with PowerShell.

**Note:** A line-of-business APK can be uploaded directly only for fully managed and dedicated devices. Corporate-owned work profile and personal devices need a **private app** in Managed Google Play.

**Note:** An Android Enterprise system app can't coexist with the same app from Managed Google Play, and you can't edit it later – fix a typo by deleting and recreating it. Find package names with a package name viewer app on a reference device.

**Note:** Filters on the enrollment profile name break when you rename the profile – enrolled devices keep the old name. `deviceManagementType` doesn't change.

**Note:** Keep the phone enrolled – Day 5 ends with a passkey on it.

**Why:** On a fully managed device IT owns the whole phone: wipe, locate, system apps, USB and date settings. The price is that the user has no private profile.
<!-- Source: Day 4 recording 2026-10-22 PM 00:20–03:01. Learn: enrollment-time-grouping (Android) (static group, owner Intune Provisioning Client AppId f1346770-5b25-470b-88bd-d5744ab7952c, not with staging token, report), android-fully-managed-enroll (device name template variables), filters-device-properties (deviceManagementType values), apps-ae-system (Android Enterprise system app; Required/Uninstall only; no coexistence; not editable), lob-apps-android (APK only fully managed/dedicated), ref-device-restrictions-android-enterprise (Date and Time changes, Locate device, FRP emails). Michael's device missed the ETG group with a self-built QR → Intune QR. Names, AE CO values and file names confirmed by Michael 2026-10-22 16:52. -->
