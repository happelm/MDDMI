---
title: 'Lab 2.7 – Group Policy analytics'
lab:
    title: 'Lab 2.7 – Group Policy analytics'
    module: 'Day 2 – Windows management'
---

# Lab 2.7 – Group Policy analytics

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

**Goal:** Analyze two GPOs with Group Policy analytics, migrate what Intune supports into a settings catalog policy and see the limits.

1. DC1: Group Policy Management → `GPO-01` → **Save Report** → save as XML. Do the same for `GPO-02`.
2. Copy both XML files to the vLab host (RDCMan clipboard).
3. Intune admin center → Devices → Manage devices → **Group Policy analytics** → **Import**: upload both XML files.
4. Open the report for `GPO-01`: about half of the settings are supported. SmartScreen settings are supported, the PUA setting is not.
5. `GPO-01` → **Migrate**: select the supported settings and create the settings catalog policy `Win Migrated Defender Settings`. **Don't assign it** – it is your template.
6. Open `Win Migrated Defender Settings` in Devices → Configuration: it is a normal settings catalog policy you can edit.
7. Open the report for `GPO-02`: preferences and firewall settings are not supported.

### Checkpoint

- [ ] Both GPOs are listed in Group Policy analytics with an MDM support percentage
- [ ] `Win Migrated Defender Settings` exists without an assignment

**Note:** Firewall rules don't come over – they belong in an Endpoint security firewall policy. Group Policy preferences have no CSP at all.

**Why:** Migrating a GPO 1:1 carries old decisions into the cloud. Use the report to decide what you still need.
<!-- Source: Day 2 recording 2026-10-20 (PM). Learn "Analyze your on-premises GPOs using Group Policy analytics", "Create a settings catalog policy from imported GPOs". Wi-Fi steps removed per Day 2 change list. -->
