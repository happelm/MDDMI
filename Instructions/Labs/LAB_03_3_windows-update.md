---
title: 'Lab 3.3 – Windows Update rings, feature and driver updates'
lab:
    title: 'Lab 3.3 – Windows Update rings, feature and driver updates'
    module: 'Day 3 – Windows apps, updates and Autopilot'
---

# Lab 3.3 – Windows Update rings, feature and driver updates

**Estimated time:** 45 minutes

**Goal:** Build a test ring and a broad ring, pause and resume a ring, pin the Windows version with a feature update policy and control driver updates.

**Why:** Update rings control *when* and *how* a device installs updates. Feature update policies control *which* Windows version it gets. Driver update policies decide which drivers Windows Update may install.

All steps: Intune admin center → Devices → Windows → **Windows updates**, unless the step says otherwise.

1. Read the hotpatch banner at the top. Hotpatch is on by default – don't opt out.
2. **Update rings** → Create profile `Test Ring`:

   | Setting | Value |
   |---|---|
   | Quality update deferral period (days) | 0 |
   | Feature update deferral period (days) | 0 |
   | Microsoft product updates, Windows drivers | Allow (default) |
   | Automatic update behavior | Auto install and restart at maintenance time |
   | Deadline for quality updates (days) | 1 |
   | Grace period (days) | 0 |
   | Auto reboot before deadline | Yes |

   Assign it to `All Windows 11 Devices`.
3. Create a second ring `Broad Ring` with the same settings, but quality update deferral period **10** days. Don't assign it – your lab devices are all in the test ring.
4. `Test Ring` → **Pause** → **Quality** updates. Look at the ring status, then **Resume** quality updates.
5. **Feature updates** → Create profile `Anchor Windows 11 26H2`: feature update to deploy **Windows 11, version 26H2**, **Make available to users as a required update**, rollout option **Make update available as soon as possible**. Assign it to `All Windows 11 Devices`.
6. **Driver updates** → Create profile `Driver Updates` with approval method **Manually approve and deploy driver updates**. Assign it to `All Windows 11 Devices`.
7. Tenant administration → Connectors and tokens → **Windows data**: turn on **Enable features that require Windows diagnostic data in processor configuration** and save.
8. Reports → **Windows updates**: look at the reports that are available.

### Checkpoint

- [ ] `Test Ring` assigned to `All Windows 11 Devices`, `Broad Ring` created
- [ ] `Test Ring` paused and resumed for quality updates
- [ ] `Anchor Windows 11 26H2` and `Driver Updates` assigned
- [ ] Windows diagnostic data turned on

**Note:** A pause lasts up to 35 days, then the ring resumes on its own. **Uninstall** in a paused ring removes only the latest update.

**Note:** In production you assign every ring to its own device group, and the broad ring to all devices excluding the groups of the earlier rings. One device in two rings gets conflicting settings.

**Note:** The VMs are already on 26H2 and get no hardware drivers, so the feature update and driver reports stay empty in the lab.

**Why deadline and grace period:** The deadline counts from when the device finds the update, the grace period from when a restart is pending. Whichever ends later is the moment Windows forces the restart. Details are in the [Day 3 notes](../Notes/DAY_03_notes.html).

**Why the deadline field accepts 1:** The Intune documentation lists 2–30 days, but the portal saved 1 in class. The Windows Update CSP allows 0–30, and Microsoft recommends 1 day for quality updates.
<!-- Source: Day 3 recording 2026-10-21 PM 00:20–01:16 and Michael's decisions 2026-10-22 (deadline 1 saved in portal, only Test Ring and Broad Ring in the guide, all other steps hands-on). Learn: manage update rings (pause 35 days, uninstall), ref-update-ring-settings, policy-csp-update, update-policies, configure-feature-update-policy (required update, rollout options), enable-windows-diagnostic-data (toggle name), Autopatch tenant settings (hotpatch). Expedite and the Windows quality update policy: talk only. -->
