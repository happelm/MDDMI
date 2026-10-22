---
title: 'Lab 4.4 – Windows compliance policy'
lab:
    title: 'Lab 4.4 – Windows compliance policy'
    module: 'Day 4 – Android'
---

# Lab 4.4 – Windows compliance policy

**Estimated time:** 30 minutes

**Goal:** Treat devices without a compliance policy as noncompliant, build one Windows compliance policy and watch `CA-001` block a Windows client.

1. Intune admin center → Devices → Compliance → **Compliance policy settings**:

   | Setting | Value |
   |---|---|
   | Mark devices with no compliance policy assigned as | Not compliant |
   | Compliance status validity period (days) | 7 |

2. Devices → Compliance → Create policy → **Windows 10 and later**: policy `Win Basic Compliance`:

   | Setting | Value |
   |---|---|
   | Device Health → Require BitLocker | Require |
   | Device Health → Require Secure Boot to be enabled on the device | Require |
   | Device Security → Firewall | Require |
   | Device Security → Trusted Platform Module (TPM) | Require |
   | Device Security → Antivirus | Require |
   | Device Security → Microsoft Defender Antimalware | Require |
   | Device Security → Real-time protection | Require |
   | Actions for noncompliance → Mark device noncompliant | Immediately |

   Leave the System Security password settings empty. Assign the policy to `Cloud Users`.
3. Wait for the evaluation. CL1 and CL2 have no BitLocker and become **Not compliant**, CL3 and CL4 become **Compliant**.
4. CL3: open `office.com` and Outlook – both work. CL1: the same apps are blocked by `CA-001`. Select **Check compliance**: Software Center (co-managed) or the Company Portal shows that BitLocker isn't enabled.

### Checkpoint

- [ ] CL1 and CL2 noncompliant with the reason BitLocker
- [ ] CL3 and CL4 compliant, Office opens on CL3
- [ ] Office is blocked on CL1

**Note:** Keep settings with a 0-day grace period apart from settings that need time. **Security intelligence up-to-date** in a policy that marks devices noncompliant immediately blocks users after every missed signature update – put it in a second policy with a grace period and notifications.

**Note:** The password settings under System Security apply only to local accounts. Entra ID accounts get their password rules from Entra ID, Active Directory accounts from AD.

**Note:** **Minimum OS version** is static. You have to raise it yourself after every update cycle.

**Note:** Compliance policies go to user groups in this course. Use device groups for shared devices without a primary user.

**Why:** **Mark devices with no compliance policy assigned as Compliant** (the default) lets every device without a policy through Conditional Access. **Not compliant** closes that gap.
<!-- Source: Day 4 recording 2026-10-22 PM 00:02–00:20 and 01:19. Moved from Day 3 by Michael 2026-10-21; minimum-OS exercise replaced with the class exercise. Learn: compliance policy settings (default Compliant, validity 30 days, range 1–120; path also under Endpoint security → Device compliance → Compliance policy settings), ref-policy-map-access-requirements (password settings only local accounts). Policy name confirmed by Michael 2026-10-22. VERIFY: exact setting labels. -->
