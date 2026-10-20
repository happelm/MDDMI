---
title: 'Lab 2.1 – Join CL3 to Entra ID'
lab:
    title: 'Lab 2.1 – Join CL3 to Entra ID'
    module: 'Day 2 – Windows management'
---

# Lab 2.1 – Join CL3 to Entra ID

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Turn on MDM auto-enrollment, join CL3 natively to Microsoft Entra ID as User1 from OOBE – without Autopilot – and see it enroll in Intune automatically. Then watch the trainer register a device instead of joining it.

1. Intune admin center → Devices → Enrollment → Windows → **Automatic Enrollment**: set the **MDM user scope** to **All**. Leave the MAM user scope at **None**.
2. CL3 starts at OOBE. Go through region and keyboard, choose any privacy settings.
3. Sign in with User1 as work or school account. Complete MFA and set up Windows Hello when Windows asks for it.
4. CL3: run `dsregcmd /status` in a command prompt.
5. CL3: Settings → Accounts → Access work or school → your account → Info: check the MDM enrollment.
6. Intune admin center → Devices → Windows: find CL3.
7. Trainer demo on CL2: device registration with a Microsoft Edge profile, **Sign in to this app only** vs. **Allow my organization to manage my device**. Only watch – do not register CL1 or CL2 yourself.

### Checkpoint

- [ ] MDM user scope is **All**
- [ ] CL3: `AzureAdJoined : YES` and `AzureAdPrt : YES`
- [ ] CL3 is listed in Intune with User1 as primary user
- [ ] You can explain registered vs. Entra joined vs. hybrid joined

**Note:** Without a license that includes Intune and Entra ID P1, auto-enrollment doesn't run – even with the MDM user scope set. If MDM and MAM user scope both include a user, MAM wins on registered devices.

**Note:** A registration on CL1 or CL2 would get in the way of the hybrid join in Lab 2.2.

**Why:** A device joined to Entra ID gives single sign-on to cloud and – with cloud Kerberos or line of sight to a DC – on-premises resources. Choosing **Sign in to this app only** keeps a private device out of Intune.
