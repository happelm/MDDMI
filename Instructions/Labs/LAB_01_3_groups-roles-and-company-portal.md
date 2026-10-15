---
title: 'Lab 1.3 – Groups, roles and Company Portal'
lab:
    title: 'Lab 1.3 – Groups, roles and Company Portal'
    module: 'Day 1 – Foundation and hybrid identity'
---

# Lab 1.3 – Groups, roles and Company Portal

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** Build the groups the later labs assign to, see where RBAC lives in Entra ID and Intune, and brand the Company Portal.

1. Entra admin center → Groups → New group: security group `Win11 Devices`, membership type **Dynamic Device**, rule for Windows devices with a Windows 11 build:

   ```text
   (device.deviceOSType -eq "Windows") and (device.deviceOSVersion -startsWith "10.0.2")
   ```

2. Create an assigned security group `Lab Users` with User1 and User2.
3. Entra admin center → Roles & admins: find **Intune Administrator** and see what it covers.
4. Intune admin center → Tenant administration → Roles: compare the built-in roles **Help Desk Operator** and **Read Only Operator**.
5. Intune admin center → Tenant administration → Customization: set the organization name, a color and a logo for the Company Portal. Check the result in the preview.
6. Walk through the Intune admin center menus with the trainer: Devices, Apps, Endpoint security, Reports, Users, Groups, Tenant administration.

### Checkpoint

- [ ] `Win11 Devices` with a dynamic rule, `Lab Users` with User1 and User2
- [ ] You can name one Entra role and one Intune role that manage devices
- [ ] Company Portal customization saved

**Note:** Dynamic groups need Entra ID P1 and update with a delay – a new device can take minutes to show up.

**Why:** Every assignment in this course goes to a group. Entra roles control the directory, Intune roles control what you can do in Intune.
<!-- VERIFY: dynamic rule – handbook says "Windows 11 with a specific build number"; Michael to pick the exact build (e.g. 10.0.26100 / 26200). -->
