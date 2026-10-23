---
title: 'Day 1 notes – Foundation and hybrid identity'
---

# Day 1 notes – Foundation and hybrid identity

> Summary of what was covered on Day 1, with sources – not a transcript. Recommendations marked "trainer recommendation" are field experience, not Microsoft documentation.

> **To do before Day 4:** Create a new Google account (@gmail.com) at home. You need it to connect your tenant to Managed Google Play. Don't use your work account or your main private account.

## Key takeaways

- Intune is built on Entra ID: identities, groups, device objects, licenses and Conditional Access all come from there.
- Use phishing-resistant sign-in (Windows Hello for Business, FIDO2, passkeys) and require MFA for device registration and enrollment.
- Single sign-on needs the same routable UPN suffix in AD and in Entra ID – that is why you add a custom domain.
- Password hash synchronization is the default sign-in method; Seamless SSO is legacy. Treat the sync server as Tier 0.
- Domain-joined computers show up in Entra ID only after the client starts the hybrid join and writes `userCertificate`.
- New Windows devices: Entra join. Hybrid join only for the existing domain-joined fleet.
- Assign to security groups, never mix users and devices in one group, and use filters where timing matters.

## Your lab environment

| System | Role |
|---|---|
| Lab tenant | Microsoft 365 E5 from GoDeploy, valid two weeks after launch |
| DC1 | AD DS and DNS for `smart.etc`; `OU=Cloud` holds User1, User2, CL1, CL2 |
| SRV1 | Microsoft Entra Connect Sync server (Tier 0) |
| SCCM | Configuration Manager, Hyper-V VM on the lab host |
| PKI | One-tier Enterprise CA, Hyper-V VM on the lab host – switched off, its root certificate is distributed in `smart.etc` through AD |
| CL1, CL2 | Domain joined, ConfigMgr client, User1/User2 – hybrid joined on Day 2 |
| CL3, CL4 | In OOBE – Entra join (Day 2) and Windows Autopilot (Day 3) |

Online participants find the vLab link in the ETC customer portal. Lab files are in `C:\Scripts` on your vLab host.

- Work **only on your lab host**, never on your own notebook. Your corporate browser is usually signed in to your production tenant – mixing up tenants is the most common and most dangerous lab mistake.
- If the Guacamole sign-in fails, press `Ctrl+Alt+Shift`, select **Logoff** in the side menu and open your link again.
- After two weeks the tenant is deleted for good. Keep nothing in it that you want to keep.

| Portal | URL | Used for |
|---|---|---|
| Microsoft 365 admin center | admin.cloud.microsoft | Licenses, domains and their DNS records, users |
| Microsoft Entra admin center | entra.microsoft.com | Users, groups, devices, custom domains, Entra Connect, Conditional Access |
| Microsoft Intune admin center | intune.microsoft.com | Devices, apps, endpoint security, tenant administration |

Several items in the Intune admin center – Conditional Access, for example – open Entra pages. If you get *access denied* there, you're missing an Entra role, not an Intune role.

## 1. Intune needs Entra ID

- Intune doesn't exist on its own: identities, groups, device objects, Conditional Access and licensing all come from Microsoft Entra ID. Good Entra knowledge is a prerequisite for working with Intune.
- Entra ID is not "Active Directory in the cloud". There are no OUs, no GPOs and no Kerberos domain in the classic sense. It is an identity provider for cloud and modern authentication.

## 2. Authentication and passwords

- Phishing hits passwords and weak MFA alike. Number matching in Microsoft Authenticator is the default for push notifications.
- Phishing-resistant methods are Windows Hello for Business, FIDO2 security keys and passkeys, and certificate-based authentication. Windows Hello resists phishing because the key is bound to the device's TPM and to the sign-in origin. The biometric gesture only unlocks that key locally.
- Periodic password changes are no longer recommended (NIST SP 800-63B, BSI). Change a password when there is a reason to.
- An Entra account always has a password, and you can't remove it. For passwordless users, Microsoft documents scrambling it to a random 64-character password so that nobody knows it. For synced users, scramble the password in the on-premises AD.
- Since 2025, MFA is mandatory for the Microsoft Intune admin center, the Entra admin center and the Azure portal.
- Avoid MFA fatigue: good single sign-on means fewer prompts, and fewer prompts mean users still pay attention when one appears.
- Require MFA for device registration and enrollment – it keeps rogue devices out of your tenant.

Sources: [Authentication methods](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-methods) · [Mandatory MFA for admin portals](https://learn.microsoft.com/entra/identity/authentication/concept-mandatory-multifactor-authentication) · [NIST SP 800-63B](https://pages.nist.gov/800-63-4/sp800-63b.html) · [Remove password usage from Microsoft Entra ID](https://learn.microsoft.com/entra/identity/authentication/how-to-plan-password-scramble-phishing-resistant-passwordless-authentication)

## 3. Licensing

- Intune Plan 1 is included in Microsoft 365 E3/E5, EMS E3/E5 and Business Premium. Entra ID P1 (needed for automatic enrollment, dynamic groups and Conditional Access) comes with the same bundles.
- **From July 2026:** Microsoft 365 E3 includes Intune Plan 2, Remote Help and Advanced Analytics. E5/E7 additionally include Endpoint Privilege Management, Cloud PKI and Enterprise App Management. All other plans, including Business Premium, get the Intune Suite only as a separate subscription.
- Frontline licenses limit the Microsoft 365 apps, not Intune management. F3 allows the Microsoft 365 mobile apps only on devices with a screen of 10.9 inches or less. F1 has no desktop apps and read-only web and mobile apps.
- Security Copilot: since November 2025, Microsoft 365 E5/E7 include 400 SCU per month per 1,000 user licenses (up to 10,000). Without E5, a provisioned SCU costs $4 per hour. *Trainer's assessment:* the included amount (0.4 SCU per user per month) is too small for real use.
- Remote Help supports Windows, macOS and Android, not iOS/iPadOS. Unattended mode exists for Windows (corporate, physical, Entra or hybrid joined devices) and for Android dedicated devices.

Sources: [Intune planning guide](https://learn.microsoft.com/intune/fundamentals/planning-guide) · [Frontline licensing](https://learn.microsoft.com/microsoft-365/frontline/switch-from-enterprise-to-frontline) · [Security Copilot inclusion](https://learn.microsoft.com/copilot/security/security-copilot-inclusion) · [Remote Help](https://learn.microsoft.com/intune/intune-service/fundamentals/remote-help)

## 4. Custom domain and DNS

- Single sign-on needs the same UPN suffix on-premises and in the cloud. Neither `smart.etc` nor the `onmicrosoft.com` domain can be renamed, so a third, routable domain goes into both: as UPN suffix in AD and as verified custom domain in Entra ID.
- A custom domain needs a TXT record for verification in Entra ID. For mail and Intune, Microsoft 365 asks for MX, `autodiscover`, SPF and the two Intune CNAMEs.
- `enterpriseregistration` → `enterpriseregistration.windows.net`, and `enterpriseenrollment` → `enterpriseenrollment-s.manage.microsoft.com`. These CNAMEs only matter for enrollment without automatic enrollment, where Windows has to discover the server from the user's email address.
- Microsoft is ending support for CNAME auto-discovery for Windows MDM-only enrollment on or soon after **January 15, 2027** (Message Center MC1509780). Existing devices aren't affected; users then enter the enrollment server address manually. Entra join with automatic enrollment doesn't use it.
- Whoever can edit these DNS records can break Microsoft 365 for the whole company – mail, Teams, everything. Protect access to your DNS provider.

Sources: [Enable auto-discovery of the Intune enrollment server](https://learn.microsoft.com/intune/device-enrollment/windows/create-cname-autodiscovery) · [Intune Customer Success blog: Preparing for end of support for CNAME auto-discovery in Windows MDM-only enrollment](https://techcommunity.microsoft.com/blog/intunecustomersuccess/preparing-for-end-of-support-for-cname-auto-discovery-in-windows-mdm-only-enroll/4564973/)

Lab: [1.2 Add your custom domain](../Labs/LAB_01_2_add-your-custom-domain.html)

## 5. Hybrid identity

**Sign-in methods**

- **Password hash synchronization (PHS)** is the recommended default. Connect Sync syncs a hash of the AD password hash (per-user salt, 1,000 iterations of HMAC-SHA256), never the password itself. Sign-in keeps working when on-premises is down.
- **Pass-through authentication (PTA)** checks the password against AD. Use it when AD sign-in restrictions such as logon hours must apply in the cloud. Run at least three agents, and treat the agent servers as Tier 0.
- **Federation** (AD FS or third parties) is no longer recommended for new deployments.
- **Seamless SSO** is legacy. Windows 10/11 devices that are Entra joined or hybrid joined get single sign-on through the Primary Refresh Token. If you still use Seamless SSO, roll over its Kerberos key regularly.

| | Password hash sync | Pass-through auth | Federation |
|---|---|---|---|
| Password checked by | Entra ID | AD, through on-prem agents | On-prem federation service |
| On-prem down | Sign-in keeps working | Sign-in fails | Sign-in fails |
| AD logon hours, expiry enforced at sign-in | No | Yes | Yes |
| Extra infrastructure | None | At least 3 agents (Tier 0) | AD FS farm and proxies (Tier 0) |
| Recommendation | Default | When AD restrictions must apply | Not for new deployments |

**Connect Sync and Cloud Sync**

| | Connect Sync | Cloud Sync |
|---|---|---|
| Runs on | A Windows Server with SQL (Express) | Lightweight provisioning agents, configured in the cloud |
| High availability | Staging server as manual standby | Several agents, active at the same time |
| Hybrid join device sync | Yes | Yes |
| Future | Retired once Cloud Sync has feature parity | Strategic tool |


- Microsoft Entra Connect Sync runs on a server. Cloud Sync uses lightweight agents and is configured in the cloud. Microsoft will retire Connect Sync once Cloud Sync reaches feature parity; there is no date yet.
- Cloud Sync now also syncs devices for hybrid join. Both tools can run side by side with separate scopes.
- Connect Sync has no active/active mode. A second server in **staging mode** is the supported standby: it imports and syncs but doesn't export until you switch it over manually.
- The sync server is Tier 0: whoever controls it controls your identities.
- Filter by OU. Group filtering is meant for pilots only. Removing an OU from the filter deletes its objects in Entra ID; users can be restored for 30 days. The accidental-delete threshold (default 500) stops mass deletions.
- SQL Express (the default) covers about 100,000 objects.
- **Writeback:** password writeback is the basis for self-service password reset with synced users. Group provisioning to AD runs through Cloud Sync. Provisioning users from Entra ID to AD is in preview in Cloud Sync. Device writeback is replaced by cloud Kerberos trust.
- **Devices:** Connect Sync only syncs computers whose `userCertificate` attribute holds the certificate the client wrote during hybrid join. Domain-joined clients therefore don't show up in Entra ID before the client starts the hybrid join (after the SCP is in place). After the next sync they appear as **Pending** until registration completes.

**Decisions in the lab wizard (Lab 1.3)**

| Choice | Why |
|---|---|
| **Customize**, not Express | `smart.etc` isn't routable; the UPN suffix has to be your verified custom domain |
| Password hash synchronization | Recommended default, works when on-prem is down |
| Enable single sign-on **cleared** | Seamless SSO is legacy; joined Windows devices use the PRT |
| Filter on `OU=Cloud` only, no group filtering | Group filtering is for pilots only |
| **Create new AD account** for the sync | A domain admin must never be the sync account; the wizard refuses it |
| Password writeback **on** | Self-service password reset for synced users |
| Continue without all UPN suffixes verified | `smart.etc` can never be verified; only users with the custom suffix are needed |

Synced attributes are read-only in Entra ID – change them in Active Directory and let the next sync carry them over.

Sources: [Connect Sync](https://learn.microsoft.com/entra/identity/hybrid/connect/how-to-connect-sync-whatis) · [Cloud Sync](https://learn.microsoft.com/entra/identity/hybrid/cloud-sync/what-is-cloud-sync) · [Staging server](https://learn.microsoft.com/entra/identity/hybrid/connect/how-to-connect-sync-staging-server) · [PHS](https://learn.microsoft.com/entra/identity/hybrid/connect/how-to-connect-password-hash-synchronization) · [Seamless SSO](https://learn.microsoft.com/entra/identity/hybrid/connect/how-to-connect-sso) · [Entra ID to AD provisioning (preview)](https://learn.microsoft.com/entra/identity/hybrid/cloud-sync/overview-provision-entra-id-to-active-directory) · [Default sync rules for computers](https://learn.microsoft.com/entra/identity/hybrid/connect/concept-azure-ad-connect-sync-default-configuration#out-of-box-rules-from-on-premises-to-microsoft-entra-id)

Lab: [1.3 Sync your users](../Labs/LAB_01_3_sync-your-users.html)

## 6. Device management options

- Ownership and management depth go together: the more strictly a device is managed, the more sensitive the data it may access – and the less freedom the user has. Conditional Access weighs the device's compliance from Intune together with other signals such as location and risk.
- Each platform has several enrollment methods; Android alone has several: personally owned work profile, corporate-owned work profile, fully managed, dedicated, and AOSP for devices without Google Mobile Services. Choose carefully – changing the method later requires a device reset.
- Windows supports MDM enrollment and app protection for Microsoft Edge on unmanaged devices. Windows Information Protection is retired.
- Intune doesn't manage Windows Server through MDM. Defender for Endpoint security settings management can still apply endpoint security policies to servers.
- **Recommendation:** use Entra join for new Windows devices. Hybrid join only for existing domain-joined devices.
- **Trainer recommendation: no personal (BYOD) Windows devices in Intune.** Windows can't separate personal and corporate data (WIP tried and was retired), so MDM on a private PC gives IT far too much power over private data – a privacy minefield. On Android and iOS/iPadOS, personal devices are fine: the work profile and user enrollment separate the data by design.
- **Architecture options:** cloud-only (Intune only), co-management (ConfigMgr and Intune share workloads), tenant attach (ConfigMgr devices visible in the Intune admin center, no Intune management).

## 7. Groups, Company Portal, terms

- Assign to security groups and never mix users and devices in one group.
- Android devices report different OS types depending on the enrollment method (`AndroidEnterprise`, `AndroidForWork`, …) – use `-startsWith "Android"`.
- Dynamic groups need Entra ID P1. A tenant can have up to 15,000 of them. They update with a delay, so for time-critical assignments use **All devices** with an assignment filter.
- The rule builder doesn't cover every operator. Write rules such as `-match` (regular expressions) in the text box, and use `-match` sparingly.
- `deviceTrustType` values are `AzureAD` (Entra joined), `ServerAD` (hybrid joined) and `Workplace` (registered).
- Windows 11 versions report `10.0.2xxxx`. 26H2 is build 26300, 26H1 is build 28000. Windows Server reports `deviceOSType` as "Windows Server", so a rule on `deviceOSType -eq "Windows"` keeps servers out.
- Device categories can only be changed by an admin, not by the user.
- On Windows, deploy the Company Portal as one of the first apps – users install apps there, see their devices and find IT contact details.
- Company Portal branding lives in Tenant administration → Customization → Default (edit). Hide Remove and Reset for corporate devices only works in the default policy; up to 25 additional policies can target user groups.
- Intune terms and conditions and Entra terms of use both exist. Entra terms of use, enforced through Conditional Access, are the more flexible option.

Sources: [Dynamic membership rules](https://learn.microsoft.com/entra/identity/users/groups-dynamic-membership) · [Windows 11 release information](https://learn.microsoft.com/windows/release-health/windows11-release-information) · [Terms and conditions](https://learn.microsoft.com/intune/intune-service/enrollment/terms-and-conditions-create)

Lab: [1.4 Groups and Company Portal](../Labs/LAB_01_4_groups-and-company-portal.html)

## Trainer recommendations

- Use the portals and all object names in English – error messages and documentation are easier to match.
- Fill in descriptions: who created an object and why it was changed.
- Automate. AI makes writing scripts easy – but understand what you run.

## What you did today

1. Launched your Microsoft 365 E5 lab tenant, secured the admin with MFA and freed licenses ([Lab 1.1](../Labs/LAB_01_1_set-up-your-tenant.html)).
2. Added and verified your custom domain with all Microsoft 365 and Intune records ([Lab 1.2](../Labs/LAB_01_2_add-your-custom-domain.html)).
3. Installed Entra Connect Sync on SRV1 with PHS and password writeback, synced `OU=Cloud` and licensed User1 and User2 ([Lab 1.3](../Labs/LAB_01_3_sync-your-users.html)).
4. Built the dynamic groups `All Windows 11 Devices` and `All Android Devices` and branded the Company Portal ([Lab 1.4](../Labs/LAB_01_4_groups-and-company-portal.html)).

## Tomorrow (Day 2)

Enrollment restrictions, roles and permissions, joining CL3 to Entra ID, hybrid join of CL1 and CL2, co-management, configuration profiles and Group Policy analytics.

## Links

- [MDDMI link collection](https://github.com/happelm/Intune-Resources/blob/main/Intune1Links.md)
- [Microsoft Intune documentation](https://learn.microsoft.com/intune/)
- [Microsoft Entra hybrid identity documentation](https://learn.microsoft.com/entra/identity/hybrid/)
