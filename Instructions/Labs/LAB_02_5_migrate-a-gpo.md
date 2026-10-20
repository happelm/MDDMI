---
title: 'Lab 2.5 – Migrate a GPO'
lab:
    title: 'Lab 2.5 – Migrate a GPO'
    module: 'Day 2 – Windows management'
---

# Lab 2.5 – Migrate a GPO

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Analyze a computer-based GPO with Group Policy analytics, migrate what Intune supports and see the limits.

1. DC1: Group Policy Management → a GPO with computer settings → **Save Report** as XML.
2. Intune admin center → Devices → Manage devices → Group Policy analytics → **Import**: upload the XML.
3. Open the report: which settings are supported by MDM, which are not, which are deprecated?
4. Select the supported settings → **Migrate**: create a settings catalog profile `GPO Migration` and assign it to `All Windows 11 Devices`.
5. Intune admin center → Devices → Configuration → Create → Windows 10 and later → Templates → **Wi-Fi**: profile `Lab Wi-Fi` for a fake WLAN with SSID `LAB-WLAN`, assigned to `All Windows 11 Devices`.
6. CL3: sync and check the Wi-Fi profile with `netsh wlan show profiles`.

### Checkpoint

- [ ] Group Policy analytics report with MDM support per setting
- [ ] `GPO Migration` profile created from the report
- [ ] `LAB-WLAN` listed on CL3

**Note:** Not every GPO setting has a CSP. Firewall rules, for example, do not come over – they belong in an Endpoint security firewall policy.

**Why:** Migrating a GPO 1:1 carries old decisions into the cloud. Use the report to decide what you still need.
<!-- VERIFY: which GPO participants export (pod has GPOs? SCMI pod: GPO-01..04). Handbook "Übung: Beispiel mit einem Fake-WLAN (WLAN-Policy)" – does Michael mean a GPO wireless policy that cannot be migrated, or an Intune Wi-Fi profile? -->
<!-- VERIFY: netsh output on a VM without a WLAN adapter (WLAN AutoConfig service may not run). -->
