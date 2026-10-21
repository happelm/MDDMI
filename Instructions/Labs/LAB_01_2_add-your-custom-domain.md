---
title: 'Lab 1.2 – Add your custom domain'
lab:
    title: 'Lab 1.2 – Add your custom domain'
    module: 'Day 1 – Foundation and hybrid identity'
---

# Lab 1.2 – Add your custom domain

**Estimated time:** 30 minutes
<!-- VERIFY: duration -->

**Goal:** Add the third-level domain the trainer assigned to you (for example `i44.mslab.live`) to your tenant, verify it and create all DNS records Microsoft 365 and Intune ask for.

**Why:** Without these records there is no mailbox and no device registration with the custom domain, and the UPNs of your synced users in Lab 1.3 need a verified domain.

1. Entra admin center → Entra ID → Domain names → **Add custom domain**: add your domain and note the TXT value.
2. On your lab host, open the ClouDNS panel `https://panel.cloudns.com` – it only accepts connections from the public IPs of the lab hosts. The trainer gives you the sign-in.
3. ClouDNS panel → **Add new** → **Master Zone**: enter only your domain → **Create**. Wait until the zone is listed (2–3 minutes).
4. In your zone → **Add new record** → type **TXT**: paste the value from Entra ID into **Points to** and save. Wait 1–2 minutes, then select **Verify** in Entra ID.
5. Microsoft 365 admin center → Settings → Domains (**Show all**) → your domain (status **Incomplete setup**) → **Continue setup**.
6. Create the records the wizard shows: MX, CNAME `autodiscover` and the SPF TXT record. Under **Advanced options** select **Intune and Mobile Device Management for Microsoft 365** and create both CNAMEs:

   | Host | Points to |
   |---|---|
   | `enterpriseregistration` | `enterpriseregistration.windows.net` |
   | `enterpriseenrollment` | `enterpriseenrollment-s.manage.microsoft.com` |

7. Finish the wizard.

### Checkpoint

- [ ] Your domain shows **Verified** in the Entra admin center
- [ ] Your domain shows **Healthy** in the Microsoft 365 admin center

**Note:** You see all zones in the ClouDNS panel. Change only your own.

**Note:** Leave **Host** empty for MX and TXT records: the panel appends the zone name itself. Typing `i44` as host gives `i44.i44.mslab.live`. The enrollment target has `-s` in it (`enterpriseenrollment-s`), the host name doesn't.

**Note:** CNAME auto-discovery is only used for MDM-only enrollment, where the user types an email address and Windows has to find the enrollment server. Microsoft is ending support for it for Windows MDM-only enrollment. Entra join with automatic enrollment doesn't need the record.

**Note:** DNS changes can take a few minutes. If verification fails, wait and verify again – don't delete and re-add the domain.
<!-- Source: Day 1 recording 2026-10-19 (PM 00:16–00:44). CNAME values: Learn "Enable auto-discovery of Intune enrollment server". CNAME end of support: https://techcommunity.microsoft.com/blog/intunecustomersuccess/preparing-for-end-of-support-for-cname-auto-discovery-in-windows-mdm-only-enroll/4564973/ (date VERIFY). -->
