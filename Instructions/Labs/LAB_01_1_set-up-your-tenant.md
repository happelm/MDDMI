---
title: 'Lab 1.1 – Set up your tenant'
lab:
    title: 'Lab 1.1 – Set up your tenant'
    module: 'Day 1 – Foundation and hybrid identity'
---

# Lab 1.1 – Set up your tenant

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Sign in to your own lab tenant as Global Administrator with MFA, know your licenses and add your custom domain.

1. Sign in to the Microsoft 365 admin center (admin.microsoft.com) with the tenant admin account from your lab hoster. Register MFA with the Microsoft Authenticator app when you are asked.
2. Microsoft 365 admin center → Billing → Your products: note which licenses your tenant has and how many are free.
3. Open the Intune admin center (intune.microsoft.com) and the Entra admin center (entra.microsoft.com) in the same browser profile and check that both load with your admin account.
4. Entra admin center → Identity → Settings → Domain names → Add custom domain: add the third-level domain the trainer assigned to you (for example `i37.mslab.live`).
5. Create the TXT record shown by Entra ID in the DNS zone of your third-level domain, as the trainer shows you, then select **Verify**.

### Checkpoint

- [ ] Admin sign-in with MFA works
- [ ] You know your license type (for example Microsoft 365 E5 or EMS E5) and the number of free licenses
- [ ] Your custom domain shows **Verified** in Entra ID

**Note:** DNS changes can take a few minutes. If verification fails, wait and verify again – do not delete and re-add the domain.

**Why:** In real projects you almost always use a custom domain for UPNs. The `onmicrosoft.com` domain works for every lab in this course – if the custom domain cannot be verified in class, continue with it.
<!-- Trainer: mslab.live is delegated in third-level zones, counter at i37 (2026-10-15). VERIFY: DNS provider/self-service portal for the delegated zones. -->
