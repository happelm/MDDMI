---
title: 'Lab 4.1 – Connect Managed Google Play'
lab:
    title: 'Lab 4.1 – Connect Managed Google Play'
    module: 'Day 4 – Android'
---

# Lab 4.1 – Connect Managed Google Play

**Estimated time:** 20 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Connect your tenant to Managed Google Play – the base for every Android Enterprise enrollment and every app from Google Play.

1. Intune admin center → Devices → Enrollment → Android → **Managed Google Play**: accept the permission and select **Launch Google to connect now**.
2. Sign in with the Google account (@gmail.com) you created before the course and bind your Intune tenant.
3. Intune admin center → Devices → Enrollment → Device platform restriction → Android restrictions: check that **Android Enterprise (work profile)** is allowed for personally owned devices.
4. Apps → Android → Create → **Managed Google Play app**: approve **Microsoft Outlook** and sync.

### Checkpoint

- [ ] Managed Google Play status **Setup** in Intune
- [ ] Microsoft Outlook listed under Apps → Android

**Note:** Microsoft recommends binding with your Microsoft Entra account instead of a Gmail account. Google blocks that method for lab hoster tenants, so in this course you use a Gmail account. Existing Gmail bindings stay supported.

**Note:** The binding belongs to the tenant. If you disconnect it later, every Android Enterprise device loses its management.

**Why:** Intune manages Android Enterprise devices through Google's APIs. Without this connection there is no work profile, no corporate-owned enrollment and no Managed Google Play app.
<!-- Source: Learn "Connect your Intune account to your managed Google Play account" (Entra account recommended since Aug 2024, Gmail bindings still supported). Gmail needed because Google blocks the Entra method for lab hoster tenants: Michael's lab finding 2026-10-22. -->
<!-- VERIFY: Managed Google Play status label after binding. -->
