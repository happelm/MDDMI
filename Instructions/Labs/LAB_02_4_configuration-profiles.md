---
title: 'Lab 2.4 – Configuration profiles'
lab:
    title: 'Lab 2.4 – Configuration profiles'
    module: 'Day 2 – Windows management'
---

# Lab 2.4 – Configuration profiles

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Deploy a root certificate, a security setting from the settings catalog and a custom OMA-URI setting – and measure how long Intune takes.

1. Intune admin center → Devices → Configuration → Create → New policy → Windows 10 and later → Templates → **Trusted certificate**: profile `Root CA` with the root certificate of the `smart.etc` Enterprise CA (`.cer` – export it on CL1 from `certlm.msc` → Trusted Root Certification Authorities, where AD already put it), store **Computer certificate store - Root**, assigned to `All Windows 11 Devices`.
2. Create → Settings catalog: profile `Security Basics` with Local Policies Security Options → **Interactive Logon Machine Inactivity Limit** = `900`, assigned to `All Windows 11 Devices`. Note the time.
3. Create → Templates → **Custom**: profile `Reboot Once` with this OMA-URI, data type **String**, value: a date and time a few minutes in the future in the format the Reboot CSP documentation shows. Assign it to a group with CL3 only.

   ```text
   ./Device/Vendor/MSFT/Reboot/Schedule/Single
   ```

4. CL3: Settings → Accounts → Access work or school → your account → Info → **Sync**. Check `certlm.msc` → Trusted Root Certification Authorities for the root certificate.
5. Intune admin center → Devices → Configuration: open each profile and compare the device status with what you see on CL3. Note how long each profile needed.

### Checkpoint

- [ ] Root certificate in the local machine root store of CL3
- [ ] `Security Basics` shows **Succeeded** for CL3
- [ ] CL3 restarted at the scheduled time
- [ ] You know the time between assignment and **Succeeded**

**Note:** A device checks in about every 8 hours on its own. A manual sync or a restart speeds things up – the portal status follows the device, not the other way round.

**Why:** Templates, settings catalog and custom OMA-URI all end up as CSP settings on the device. The CSP documentation on Learn tells you path, format and scope of every setting.
<!-- 2026-10-20 Michael: PKI = one-tier Enterprise CA VM on the host, switched off; root cert is distributed in smart.etc via AD (CL1/CL2 have it already, CL3 needs this profile). VERIFY: where participants get the root .cer file. -->
<!-- VERIFY: Reboot CSP Schedule/Single value format and example from Learn before class; consider settings catalog alternative. -->
<!-- VERIFY: CL1/CL2 also in All Windows 11 Devices? Then they get the profiles too – intended. -->
