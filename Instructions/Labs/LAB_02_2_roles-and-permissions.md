---
title: 'Lab 2.2 – Roles and permissions'
lab:
    title: 'Lab 2.2 – Roles and permissions'
    module: 'Day 2 – Windows management'
---

# Lab 2.2 – Roles and permissions

**Estimated time:** 15 minutes
<!-- VERIFY: duration -->

**Goal:** Give a group of admins policy permissions for Windows devices only, with a built-in Intune role, a scope group and a scope tag.

1. Intune admin center → Tenant administration → Roles → All roles: open **Policy and Profile Manager** → Permissions and look at what the role can do.
2. **Policy and Profile Manager** → Assignments → **Assign**:

   | Setting | Value |
   |---|---|
   | Name | `Cloud Users - Policy and Profile Managers for all Windows Devices` |
   | Admin groups | `Cloud Users` |
   | Scope groups | `All Windows 11 Devices` |
   | Scope tags | `Default` |

3. Entra admin center → Roles & admins: find **Intune Administrator** and compare it with the Intune role from step 1.

### Checkpoint

- [ ] The assignment is listed under **Policy and Profile Manager** → Assignments
- [ ] You can explain the difference between admin group, scope group and scope tag

**Note:** Built-in Intune roles can't be changed. To change permissions, **Duplicate** a built-in role and edit the copy.

**Note:** Scope groups decide which users and devices an admin can target. Scope tags decide which objects (policies, apps, devices) an admin can see. An object without a tag has the tag `Default`.

**Why:** Entra roles such as Intune Administrator work on the whole tenant. Intune roles with scope groups and scope tags limit an admin to part of the devices.
<!-- Source: Day 2 recording 2026-10-20 (AM). Learn "Role-based access control (RBAC) with Microsoft Intune", "Use RBAC and scope tags for distributed IT". -->
