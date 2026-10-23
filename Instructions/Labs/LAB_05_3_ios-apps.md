---
title: 'Lab 5.3 – iOS apps and app configuration'
lab:
    title: 'Lab 5.3 – iOS apps and app configuration'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.3 – iOS apps and app configuration

**Estimated time:** 25 minutes

**Goal:** Add Microsoft Teams from the App Store and give it an app configuration.

1. Intune admin center → Apps → iOS/iPadOS → Create → **iOS store app** → **Search the App Store** → **Microsoft Teams**. Name, logo and minimum OS are filled in. Look at the assignment page: filters and the **VPN** column for per-app VPN. Create it without assignment.
2. Apps → Configuration → Create → **Managed apps**: policy `iOS Teams Config` for **Microsoft Teams**. Teams has no configuration designer – enter the key from the Learn article [Manage Teams for iOS and Android](https://learn.microsoft.com/intune/app-management/configuration/configure-teams-mobile):

   | Name | Value |
   |---|---|
   | `com.microsoft.teams.chat.notifications.IntuneMAMOnly` | `1` |

   Create it without assignment.

### Checkpoint

- [ ] Microsoft Teams listed under Apps → iOS/iPadOS
- [ ] `iOS Teams Config` exists with the notification key

**Note:** The notification key works together with **Org data notifications = Block org data** in an app protection policy (Lab 5.4). Then a locked iPhone shows "You have a new message" instead of the chat text.

**Note:** A **Managed apps** configuration policy is assigned to users and reaches the app through the Intune App SDK – on enrolled and unenrolled devices alike, no matter how the app was installed. A **Managed devices** policy works only for apps that Intune deployed to an enrolled device. Managed apps check for their configuration every 30 minutes when an app protection policy is assigned, otherwise every 720 minutes.

**Note:** App configuration keys are case sensitive. Outlook and Edge have their own keys and a designer; most other apps need the keys from their documentation.

**Note:** Corporate devices without an Apple Account get App Store apps through **Apps and Books** in Apple Business and an Apple VPP token (trainer demo). Device licensing needs no Apple Account on the device.

**Why:** Store apps on iOS need a user's Apple Account, VPP apps don't. App configuration sets app behavior without touching the device.
<!-- Source: Day 5 recording 2026-10-23 02:31–02:49. In class the Teams config was created as "Managed devices" with an integer key, value 1; Learn configure-teams-mobile documents the notification keys (value 1/0) for a Managed apps policy together with APP "Org data notifications = Block org data" – the lab follows Learn (Michael agreed 2026-10-23). Learn app-configuration overview: Managed apps independent of enrollment state; check-in 30/720 min. -->
