---
title: 'Lab 3.4 – Compliance and Conditional Access'
lab:
    title: 'Lab 3.4 – Compliance and Conditional Access'
    module: 'Day 3 – Windows security'
---

# Lab 3.4 – Compliance and Conditional Access

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Make Microsoft 365 access depend on a compliant Windows device – and see Intune evaluate and Entra ID enforce.

1. CL3: run `ver` and note the OS version.
2. Intune admin center → Devices → Compliance → Create policy → Windows 10 and later: policy `Win Compliance` with **Minimum OS version** set higher than the version from step 1 and **Require BitLocker**, assigned to `Lab Users`.
3. Entra admin center → Identity → Overview → Properties → **Manage security defaults**: turn security defaults off – otherwise you cannot create Conditional Access policies.
4. Entra admin center → Protection → Conditional Access → Create new policy: `Require compliant Windows` for `Lab Users` (exclude your admin account), target resource **Office 365**, condition device platforms **Windows**, grant **Require device to be marked as compliant**. Set it to **Report-only** first.
5. CL3 as User1: open office.com in Microsoft Edge. Entra admin center → Monitoring & health → Sign-in logs: find the sign-in and read the Report-only tab.
6. Set the policy to **On**. CL3: Company Portal → **Check access**, wait until the device is noncompliant, open office.com again.
7. Change the minimum OS version in `Win Compliance` to the version from step 1 or lower, **Check access** again – office.com opens.
8. Trainer demo: Microsoft Defender for Endpoint connected to Intune, machine risk score in the compliance policy.

### Checkpoint

- [ ] CL3 noncompliant with the reason minimum OS version
- [ ] Sign-in from CL3 blocked with a compliance message
- [ ] CL3 compliant again, office.com opens
- [ ] Sign-in log shows the Conditional Access result

**Note:** Never target all users without excluding an admin account – a mistake in a Conditional Access policy can lock you out of your own tenant.

**Why:** Configuration profiles set settings, compliance policies evaluate them. BitLocker can be enforced by a profile – the compliance policy only checks whether it is on.
<!-- VERIFY: Entra admin center menu paths (Identity / Protection / Monitoring & health) – Entra nav changes often; check before class. -->
<!-- VERIFY: CL1/CL2 users User1/User2 are in Lab Users too – hybrid clients will also be evaluated; intended? -->
