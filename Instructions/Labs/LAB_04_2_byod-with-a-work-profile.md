---
title: 'Lab 4.2 – BYOD with a work profile'
lab:
    title: 'Lab 4.2 – BYOD with a work profile'
    module: 'Day 4 – Android'
---

# Lab 4.2 – BYOD with a work profile

**Estimated time:** 75 minutes

**Goal:** Prepare web enrollment, compliance, Conditional Access and an Outlook configuration first – then let User1 enroll the Android test device as a personal device because Outlook demands it.

## Prepare the tenant

1. Intune admin center → Devices → Enrollment → **Android** tab → **Personally owned devices with a work profile**: turn on **Use web enrollment for all users enrolling into Android personally owned work profile management** and save.
2. Devices → Compliance → Create policy → Android Enterprise → **Personally owned work profile**: policy `AE BY Basic Compliance`:

   | Setting | Value |
   |---|---|
   | Device Health → Rooted devices | Block |
   | System Security → Require a password to unlock mobile devices | Require |
   | System Security → Password complexity | Low |
   | Actions for noncompliance → Mark device noncompliant | Immediately |

   Assign it to `Cloud Users`.
3. Entra admin center → Conditional Access → Create new policy: `CA-001 Office 365 Only for Intune Enrolled Devices`:

   | Setting | Value |
   |---|---|
   | Users | include `Cloud Users` |
   | Target resources | Office 365 |
   | Conditions | none |
   | Grant | Require device to be marked as compliant |
   | Enable policy | On |

4. Intune admin center → Apps → Android → Create → **Managed Google Play app**: search for **Microsoft Outlook**, select it and **Select**. Nothing visible happens – select **Sync** and refresh until Outlook shows up in the list. Assign it as **Required** to `Cloud Users`.
5. Apps → Configuration → Create → **Managed devices**: policy `AE BY-CO Outlook Config`, platform **Android Enterprise**, profile type **All profile types**, targeted app **Microsoft Outlook**. Configuration designer:

   | Setting | Value |
   |---|---|
   | Configure email account settings | Yes |
   | Authentication type | Modern authentication |
   | Username attribute from Microsoft Entra ID | User principal name |
   | Email address attribute from Microsoft Entra ID | Primary SMTP address |
   | Allow only work or school accounts | Enabled |
   | Save contacts | On |
   | Connected apps | On |

   Permissions → Add → **Contacts (read)** and **Contacts (write)** = **Auto grant**. Assign it to `Cloud Users`.
6. Android test device: turn it on and connect it to Wi-Fi. Don't set a screen lock yet – you want to see the compliance prompt.

## Enroll as the user

7. Android test device: open Outlook (preinstalled on Samsung devices, otherwise install it from Google Play) and add User1. Conditional Access blocks the sign-in – select **Get started**.
8. Follow the setup: the work profile is created, then a checklist asks you to set a screen lock, install the work apps and register the device. Expect several sign-in prompts – there is no single sign-on before the registration. Use PIN `1234` on the test device.
9. Open the **Work** tab: start Outlook there, select **Add account** for the account that is already listed, and open the mailbox.

### Checkpoint

- [ ] The first sign-in in Outlook is blocked by `CA-001`
- [ ] Intune lists the device with ownership **Personal** and compliance **Compliant**
- [ ] The **Work** tab shows Outlook, Microsoft Intune and Microsoft Authenticator
- [ ] Outlook in the work profile opens User1's mailbox without typing the account

**Note:** Web enrollment is tenant-wide and **can't be turned off** again. Devices that enrolled before keep the old method until you move them with a **Move to Android Management API** profile (see the Day 4 notes).

**Note:** Use **Require a password to unlock mobile devices** under System Security, not the work profile password. By default the device and the work profile share one lock; if you only require the work profile password, only the work profile asks for a PIN.

**Note:** **Password complexity Low** allows repeating or ordered PINs like `1234`. **Medium** needs at least 4 characters and blocks repeating and ordered PINs, **High** at least 8 (6 for alphabetic or alphanumeric).

**Note:** In production, exclude your break-glass accounts from every Conditional Access policy and start with **Report-only**.

**Note:** Microsoft Outlook doesn't need a license count on Android – Managed Google Play apps show 0 licenses.

**Why this order:** If the user enrolls first, you don't see how Conditional Access drives the enrollment. In real life, this is how most BYOD users meet Intune: through an app that refuses to work.
<!-- Source: Day 4 recording 2026-10-22 AM 01:12–01:51 and 02:14–02:42. Learn: android-management-api-overview (web enrollment tenant-wide, can't be reversed; Intune app + Company Portal in the work profile), ref-android-enterprise-settings (password complexity Low/Medium/High; one lock), app-configuration-policies-outlook (configuration designer). Michael 14:48: Learn wording for Medium. VERIFY: exact Outlook configuration designer labels in the current portal. -->
