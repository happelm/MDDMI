---
title: 'Lab 5.3 – Protect Outlook with app protection'
lab:
    title: 'Lab 5.3 – Protect Outlook with app protection'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.3 – Protect Outlook with app protection

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Protect company data in Outlook on an unmanaged device with an app protection policy and make it mandatory with Conditional Access.

1. Intune admin center → Apps → App protection policies → Create policy → iOS/iPadOS: policy `Outlook APP` for **Microsoft Outlook**, assigned to `Cloud Users`:
   - Data protection: send org data only to policy-managed apps, cut, copy and paste only between policy-managed apps
   - Access requirements: PIN for access
2. Entra admin center → Protection → Conditional Access → Create new policy: `Require APP on iOS` for `Cloud Users`, target resource **Office 365**, condition device platforms **iOS**, grant **Require app protection policy**, state **On**.
3. iPhone without enrollment (or after retire of Lab 5.2): install Outlook and sign in as User2. Follow the request to install Microsoft Authenticator.
4. Outlook: set the app PIN. Copy text from a mail and paste it into Notes.

### Checkpoint

- [ ] Outlook asks for the app PIN
- [ ] Pasting company data into Notes is blocked
- [ ] Intune admin center → Apps → Monitor → App protection status lists User2

**Note:** Without a broker app (Microsoft Authenticator on iOS) the device cannot register in Entra ID – Conditional Access then does not let Outlook in.

**Why:** App protection works without device enrollment – the right choice for BYOD when users do not accept device management.
<!-- VERIFY: CA grant "Require approved client app" retirement status (handbook mentions it) – lab uses "Require app protection policy" only. -->
<!-- VERIFY: device enrolled in Lab 5.2 plus APP – policy targets all app types by default; fine either way, but the test is clearer on an unenrolled device. -->
<!-- VERIFY: User2 in Cloud Users and not in iOS Users. -->
