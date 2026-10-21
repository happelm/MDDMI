---
title: 'Lab 2.5 – Co-management with Configuration Manager'
lab:
    title: 'Lab 2.5 – Co-management with Configuration Manager'
    module: 'Day 2 – Windows management'
---

# Lab 2.5 – Co-management with Configuration Manager

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

**Goal:** Cloud attach the Configuration Manager site and move all co-management workloads to Intune, so Intune policies reach CL1 and CL2.

1. Look at the symptom first. Entra admin center → Devices → All devices: CL1 and CL2 show MDM **Microsoft Configuration Manager**. Intune admin center → Devices → Windows: their compliance shows **ConfigMgr**. Intune policies only reach CL3.
2. Connect to the SCCM VM and open the Configuration Manager console → Administration → Cloud Services → **Cloud Attach** → **Configure Cloud Attach** in the ribbon.
3. Azure environment **Azure Public Cloud** → **Sign In** as Global Administrator → keep **Use default settings (recommended)** → **Next** → **Yes** to the app registration → finish the wizard.
4. Cloud Attach → **CoMgmtSettingsProd** → Properties → **Workloads**: move all sliders to **Intune** → **Apply**.
5. CL1: Control Panel → **Configuration Manager** → Actions → run **Machine Policy Retrieval & Evaluation Cycle**. On the General tab, the co-management capabilities value goes up once the new workloads arrive.

### Checkpoint

- [ ] Cloud Attach shows `CoMgmtSettingsProd` with all workloads on Intune
- [ ] CL1 and CL2 no longer show **ConfigMgr** as compliance in Intune

**Note:** The account you sign in with in step 3 needs an Intune license – without one, the wizard aborts.

**Note:** With the default settings, Cloud Attach enrolls eligible clients into co-management, but all workloads stay on Configuration Manager. Only step 4 hands them to Intune.

**Note:** After tenant attach, you may see CL1 and CL2 twice in Intune for a while. The records merge by themselves – don't delete them.

**Why:** Co-management lets Configuration Manager and Intune manage the same Windows device. Each workload has exactly one owner, so you can move one workload at a time.
<!-- Source: Day 2 recording 2026-10-20 (PM). Learn "Enable cloud attach for Configuration Manager" (path, default settings = all workloads on ConfigMgr, Global Administrator), "Co-management workloads". Intune license needed for the signing-in admin: trainer fact 2026-10-20 (Learn only names Global Administrator). VERIFY: control panel wording for co-management capabilities. -->
