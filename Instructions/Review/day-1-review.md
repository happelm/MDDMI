---
title: 'Morning review – Day 1'
---

# Morning review – Day 1

Think each question through – ideally with your neighbor – before you open the answer. There is rarely one right sentence; the answer shows the reasoning behind it.

<details markdown="1">
<summary><strong>1. A colleague asks: "Why did we spend half an hour on a custom domain? Our users could just sign in with the onmicrosoft.com address." What would break without it?</strong></summary>

Single sign-on. Users sign in to Windows with their AD account and to Microsoft 365 with their Entra account. For both to be the same identity, the UPN suffix must be the same on both sides. `smart.etc` isn't routable and can never be verified in Entra ID, and the `onmicrosoft.com` domain can't be used in AD as a real suffix. So a third, routable domain goes into both: as UPN suffix in AD and as verified custom domain in Entra ID. That is also why the Connect Sync wizard needed **Customize** instead of Express. (Labs 1.2, 1.3)

</details>

<details markdown="1">
<summary><strong>2. An auditor asks why your users no longer change their password every 90 days, and why your "passwordless" users still have a password at all. What do you answer?</strong></summary>

Periodic password changes are no longer recommended (NIST SP 800-63B, BSI): they lead to predictable passwords. You change a password when there is a reason, such as a leak. And an Entra account always has a password – you can't remove it. Microsoft documents scrambling it to a random 64-character password that nobody knows; for synced users you scramble it in the on-premises AD, because that is where the password comes from. Passwordless means nobody *uses* the password, not that it doesn't exist.

</details>

<details markdown="1">
<summary><strong>3. Friday evening, both domain controllers are down. Which users can still sign in to Teams and Outlook – with password hash sync, with pass-through authentication, with federation?</strong></summary>

Only with **password hash sync**: Entra ID checks the password itself, so on-premises can be completely down. With **pass-through authentication** the password is checked against AD through the on-premises agents – no DC, no sign-in. **Federation** has the same problem with the federation servers. PTA still has its place: when AD sign-in restrictions such as logon hours must apply in the cloud. Then you run at least three agents and treat their servers as Tier 0. (Lab 1.3)

</details>

<details markdown="1">
<summary><strong>4. In the Connect Sync wizard you cleared "Enable single sign-on". How do your users get single sign-on to the cloud on CL1 or CL3 then?</strong></summary>

Through the **Primary Refresh Token (PRT)**. A Windows 10/11 device that is Entra joined or hybrid joined gets a PRT when the user signs in, and the PRT gives single sign-on to cloud apps. Seamless SSO is legacy – it only helps older domain-joined devices that are not joined to Entra ID. If you still run it, you have to roll over its Kerberos key regularly. (Lab 1.3, Day 2)

</details>

<details markdown="1">
<summary><strong>5. Why did the wizard insist on creating a new AD account for the sync, and why is SRV1 called a Tier 0 server even though it is "just a sync server"?</strong></summary>

Whoever controls the sync server controls your identities: it can change and delete users, and with password writeback it writes back to AD. That makes it as sensitive as a domain controller – Tier 0. A domain admin must never be the sync account; the wizard refuses it and creates a dedicated account with only the permissions the sync needs. Protect SRV1 like DC1: few admins, no browsing, no other roles. (Lab 1.3)

</details>

<details markdown="1">
<summary><strong>6. A colleague "cleans up" the OU filter in Connect Sync and removes OU=Cloud. What happens in Entra ID, and what saves you?</strong></summary>

At the next sync, every object from that OU is out of scope and gets **deleted** in Entra ID – users lose their cloud identity, licenses and access. Users can be restored for 30 days. The **accidental-delete threshold** (default 500) stops an export that would delete more objects than that, but a small OU stays under it. Filter by OU and change the filter only with a plan; group filtering is meant for pilots only. (Lab 1.3)

</details>

<details markdown="1">
<summary><strong>7. After the first sync, User1 and User2 are in Entra ID, but CL1 and CL2 aren't – although they sit in the same OU. Is the sync broken?</strong></summary>

No. Connect Sync only takes computers whose `userCertificate` attribute holds the certificate the client wrote during the hybrid join. The client does that only after it has read the service connection point (SCP). Before that, there is nothing to sync. After the next sync the computer shows up as **Pending** until the registration completes. That is Day 2 – and the reason why "the device isn't in Entra ID" is often a client problem, not a sync problem. (Labs 1.3, 2.4)

</details>

<details markdown="1">
<summary><strong>8. Why does the Android group use <code>-startsWith "Android"</code> while the Windows group uses <code>-eq "Windows"</code> plus a version check?</strong></summary>

Android devices report different OS types depending on the enrollment method (`AndroidEnterprise`, `AndroidForWork`, …). An `-eq` rule would catch only one of them. For Windows, `deviceOSType -eq "Windows"` is exact on purpose: Windows Server reports "Windows Server", so servers stay out. The version check `-startsWith "10.0.2"` keeps it to Windows 11, which reports `10.0.2xxxx`. Know your attribute values before you write a rule. (Lab 1.4)

</details>

<details markdown="1">
<summary><strong>9. A required app must be on new devices right after enrollment. Your dynamic device group takes a while to pick them up. What do you do instead of waiting?</strong></summary>

Dynamic groups aren't real time – their membership is calculated with a delay. For time-critical assignments, assign to **All devices** and narrow it with an **assignment filter**. Filters are evaluated at check-in, so they don't wait for group membership. (On Android and iOS, enrollment time grouping solves the same problem – Days 4 and 5.) (Lab 1.4, Day 2)

</details>

<details markdown="1">
<summary><strong>10. Management wants employees' private Windows laptops in Intune "just like their phones". What is the trainer's recommendation, and why is the phone a different story?</strong></summary>

**No personal Windows devices in Intune** (trainer recommendation). Windows can't separate personal and corporate data – Windows Information Protection tried and was retired. MDM on a private PC gives IT far too much power over private data. On Android and iOS/iPadOS the platform separates the data by design: the work profile and user enrollment keep the corporate part apart, and IT can remove only that part. For private Windows PCs, app protection for Microsoft Edge on unmanaged devices is the safer path.

</details>

<details markdown="1">
<summary><strong>11. The helpdesk tries to change the department of User1 in the Entra admin center and can't save. Missing permission?</strong></summary>

No. User1 is synced from AD, and synced attributes are read-only in Entra ID – AD is the source of authority. Change the department in AD and let the next sync carry it over. (Lab 1.3)

</details>

<details markdown="1">
<summary><strong>12. Your new Windows devices are Entra joined with automatic enrollment. Do you still need the <code>enterpriseenrollment</code> CNAME – and what changes in 2027?</strong></summary>

Not for them. The CNAMEs only matter for enrollment without automatic enrollment, where Windows has to find the enrollment server from the user's email address. Microsoft ends CNAME auto-discovery for Windows MDM-only enrollment on or soon after January 15, 2027 (MC1509780) – then users enter the server address manually. Entra join with automatic enrollment doesn't use it. Whoever can edit these DNS records can still break Microsoft 365 for the whole company, so protect access to your DNS provider. (Lab 1.2)

</details>
