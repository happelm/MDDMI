---
title: 'Lab 2.3 – Roles and permissions'
lab:
    title: 'Lab 2.3 – Roles and permissions'
    module: 'Day 2 – Windows management'
---

# Lab 2.3 – Roles and permissions

**Estimated time:** 20 minutes
<!-- VERIFY: duration, position in Day 2, and the content Michael actually shows -->

> **Draft:** This lab is new and not yet tested in this course. If a step behaves differently, tell the trainer.

**Goal:** See where permissions for device management live in Entra ID and in Intune, and how the built-in Intune roles differ.

1. Entra admin center → Roles & admins: find **Intune Administrator** and see what it covers.
2. Intune admin center → Tenant administration → Roles → All roles: compare the built-in roles **Help Desk Operator** and **Read Only Operator**.
<!-- VERIFY: role assignment step (members, scope groups, scope tags) – fill in after Michael's Day 2 delivery. -->

### Checkpoint

- [ ] You can name one Entra role and one Intune role that manage devices

**Why:** Entra roles control the directory and – like Intune Administrator – can reach into Intune. Intune roles control only what you can do in Intune, and with scope groups and scope tags you can limit them to part of your devices.
