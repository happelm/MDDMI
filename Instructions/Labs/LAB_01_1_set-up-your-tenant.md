---
title: 'Lab 1.1 – Set up your tenant'
lab:
    title: 'Lab 1.1 – Set up your tenant'
    module: 'Day 1 – Foundation and hybrid identity'
---

# Lab 1.1 – Set up your tenant

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

**Goal:** Launch your own Microsoft 365 E5 lab tenant, sign in as Global Administrator with MFA and free up licenses for your lab users.

Do every step on your lab host, never on your own notebook: your corporate browser is often signed in to your production tenant.

1. Lab host: open `https://lms.godeploy.it` → **Register Now** and create your own account. **Sign in with Microsoft** usually fails – use the registration form.
2. Register the product key you got from the trainer. Open the course and select **Launch Lab**. Provisioning takes a few minutes.
3. Copy the user name and the *complete* password from **Office 365 Tenant Credentials** into Notepad – the password field scrolls, so make sure you get all of it. Ignore the VMs and lab instructions in the GoDeploy portal.
4. Open the Microsoft 365 admin center (`admin.cloud.microsoft`) on your lab host and sign in as **MOD Administrator** with these credentials.
5. Register MFA when you are asked. Any authenticator app works – for a non-Microsoft app choose **I want to use a different authenticator app**.
6. Microsoft 365 admin center → Billing → Your products: your tenant has 20 Microsoft 365 E5 licenses and none are free.
7. Microsoft 365 admin center → Users → Active users: delete two or three demo users, for example Megan Bowen, Lynne Robbins and Joni Sherman. **Never delete MOD Administrator.**
8. Open the Entra admin center (`entra.microsoft.com`) and the Intune admin center (`intune.microsoft.com`) in the same window and check that both load.

### Checkpoint

- [ ] Admin sign-in with MFA works
- [ ] At least two Microsoft 365 E5 licenses are available
- [ ] Entra admin center and Intune admin center open with your admin account

**Note:** The tenant expires two weeks after you launch it and is then deleted. Don't store anything in it that you want to keep.

**Note:** If the MFA push doesn't arrive, close the browser and sign in again.

**Note for online students:** The vLab can't take files from your notebook. Copy links and text into the session, not files.
<!-- Source: Day 1 recording 2026-10-19 (AM 02:45–03:13). VERIFY: exact admin UPN format of the GoDeploy tenant. -->
