---
title: 'Lab 2.3 – Join CL3 to Entra ID'
lab:
    title: 'Lab 2.3 – Join CL3 to Entra ID'
    module: 'Day 2 – Windows management'
---

# Lab 2.3 – Join CL3 to Entra ID

**Estimated time:** 45 minutes
<!-- VERIFY: duration -->

**Goal:** Turn on MDM auto-enrollment, join CL3 to Microsoft Entra ID as User1 from OOBE without Autopilot, see it enroll in Intune and test single sign-on to cloud and on-premises resources.

1. Intune admin center → Devices → Enrollment → Windows → **Automatic Enrollment**: set the **MDM user scope** to **All**. Leave the MAM user scope at **None** and don't change the MDM URLs. You find the same setting in the Entra admin center → Entra ID → Mobility (MDM and MAM) → Microsoft Intune.
2. On the vLab host, open **Hyper-V Manager** and connect to CL3. CL3 starts at OOBE: name the device `CL3`, choose **Set up for work or school** and sign in with `User1@<your domain>`. Answer the questions regarding privacy settings at your own discretion.
3. Register MFA for User1. **Close the enhanced session dialog before Windows Hello starts** – Hello setup only works in the basic console. Set up a 6-digit PIN.
4. Entra admin center → Devices → All devices: CL3 is **Microsoft Entra joined**, MDM **Microsoft Intune**, owner User1, and member of `All Windows 11 Devices`. Intune admin center → Devices → Windows: CL3 shows up a few minutes later.
5. CL3: Start → type `MDM` → **Access work or school** → your account → **Info**: check the management server address (`manage.microsoft.com`), select **Sync**, then **Create report** and open the exported report.
6. CL3: run `dsregcmd /status` in a command prompt.
7. Test single sign-on: sign out, connect with **enhanced session** and sign in as User1 with the **password**.
   - File Explorer: open `\\dc1\LabFiles` – it opens without a prompt.
   - Command prompt: run `klist` – you see tickets for `krbtgt` and `cifs`.
   - Microsoft Edge: sign in with the work account, then open `https://outlook.office.com` – no prompt.

### Checkpoint

- [ ] MDM user scope is **All**
- [ ] CL3: `AzureAdJoined : YES` and `AzureAdPrt : YES`
- [ ] CL3 is listed in Intune with User1 as primary user
- [ ] `\\dc1\LabFiles` and Outlook on the web open without a prompt

**Note:** **Disable MDM enrollment when adding work or school account** stays **No** in the lab. In production, **Yes** keeps private devices out of Intune when a user adds a work account.

**Note:** Without a license that includes Intune and Entra ID P1, auto-enrollment doesn't run – even with the MDM user scope set. If MDM and MAM user scope both include a user, MAM wins on registered devices.

**Note:** The trainer shows that `\\dc1` doesn't open after a sign-in with the Hello PIN – the PIN needs Cloud Kerberos trust, which is out of scope for this course.

**Why:** An Entra joined device gets a Primary Refresh Token (PRT) at sign-in. With the PRT the device gets single sign-on to cloud apps, and with line of sight to a DC it also gets Kerberos tickets for on-premises resources.
<!-- Source: Day 2 recording 2026-10-20 (AM). Learn "Enable Windows automatic enrollment", "Primary Refresh Token". Old step 7 (registration demo on CL2) removed per Michael 2026-10-20. -->
