---
title: 'Lab 5.1 – Apple MDM push certificate'
lab:
    title: 'Lab 5.1 – Apple MDM push certificate'
    module: 'Day 5 – iOS/iPadOS'
---

# Lab 5.1 – Apple MDM push certificate

**Estimated time:** 15 minutes (optional – only if you have an Apple Account)

**Goal:** Create the Apple MDM push certificate – without it, Intune can't manage any iPhone, iPad or Mac.

**You need:** an Apple Account. If you have a personal one, you can safely use it for this lab tenant – the certificate is only listed in the Apple Push Certificates Portal under your account. In production, use a company Apple Account (see the note below).

1. Intune admin center → Devices → Enrollment → **Apple** tab → Prerequisites → **Apple MDM Push certificate**: select **I agree** and **Download your CSR**. A `.csr` file lands in Downloads.
2. Select **Create your MDM Push Certificate**. The Apple Push Certificates Portal opens. Sign in with your Apple Account (two-step verification).
3. **Create a Certificate** → accept the terms → enter a note (for example your tenant name) → upload the `.csr` file → **Download**. You get a `.pem` file.
4. Back in Intune: enter the Apple Account you used and upload the `.pem` file.

### Checkpoint

- [ ] Status **Active**, **Days until expiration** 365
- [ ] You know which Apple Account owns the certificate

**Note:** Renew the certificate every year with **Renew** in the Apple portal and the **same Apple Account** – never with **Create a Certificate**. After the expiry date you have a 30-day grace period. A new certificate, another Apple Account or a missed grace period means every Apple device must enroll again.

**Note:** Use a company Apple Account that several admins can reach, with the mail address monitored, and put the renewal date in more than one calendar. Renew the push certificate, the ADE token and the VPP token on the same day (trainer recommendation).

**Why:** Intune wakes Apple devices through the Apple Push Notification service. The certificate ties your tenant to it.
<!-- Source: Day 5 recording 2026-10-23 00:35–00:47. Learn create-mdm-push-certificate (365 days, 30-day grace period, renew with same Apple account). Michael 2026-10-23: refer to .csr/.pem by extension only; personal Apple Account is fine for the lab. -->
