---
title: 'Lab 4.1 – Connect Managed Google Play'
lab:
    title: 'Lab 4.1 – Connect Managed Google Play'
    module: 'Day 4 – Android'
---

# Lab 4.1 – Connect Managed Google Play

**Estimated time:** 20 minutes

**Goal:** Connect your tenant to Managed Google Play with the Google account you created before the course – the base for every Android Enterprise enrollment and every app from Google Play.

1. Intune admin center → Devices → Enrollment → **Android** tab → Prerequisites → **Managed Google Play**: select **I agree** (Microsoft may share data with Google), then **Launch Google to connect now**.
2. Enter your @gmail.com address. Google warns that this is a personal email address – select **Sign up for Android only** (link at the bottom of the page) and sign in. Google may ask for a phone number.
3. Fill in the sign-up:

   | Setting | Value |
   |---|---|
   | Organization name | your tenant domain |
   | Enterprise mobility management (EMM) provider | Microsoft Intune |
   | Data protection officer, EU representative | optional, leave empty |

   Accept the Managed Google Play agreement and select **Complete registration**.
4. Back in the Intune admin center: the redirect often fails the first time. Refresh the page. If the status isn't green yet, run steps 1–3 again – the second run is short because you are already signed in.

### Checkpoint

- [ ] Managed Google Play shows a green status in the Intune admin center
- [ ] Apps → Android lists the default apps Intune adds after the binding, for example Microsoft Intune, Intune Company Portal, Managed Home Screen and Microsoft Authenticator

**Note:** Microsoft recommends binding with a Microsoft Entra account instead of a Gmail account. In lab hoster tenants that path fails at the last step, so in this course you use a Gmail account. Existing Gmail bindings stay supported.

**Note:** To reuse a Google account for a new tenant, delete the old organization first: sign in at `play.google.com/work` → Admin settings → delete the organization.

**Note:** The binding belongs to the tenant. If you disconnect it later, every Android Enterprise device loses its management.

**Why:** Intune manages Android Enterprise devices through Google's APIs. Without this connection there is no work profile, no corporate-owned enrollment and no Managed Google Play app.
<!-- Source: Day 4 recording 2026-10-22 AM 00:52–01:12. Learn "Connect your Intune account to your managed Google Play account" (Entra account recommended, Gmail bindings still supported). Entra path fails in lab hoster tenants: Michael's lab finding (assumed cause). Default apps after binding: trainer in class (01:38). VERIFY: exact Prerequisites menu path and label "Sign up for Android only". -->
