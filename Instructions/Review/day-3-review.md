---
title: 'Morning review – Day 3'
---

# Morning review – Day 3

Think each question through – ideally with your neighbor – before you open the answer. There is rarely one right sentence; the answer shows the reasoning behind it.

<details markdown="1">
<summary><strong>1. You assigned Microsoft 365 Apps as "Available" to <code>All Windows 11 Devices</code>. Nobody sees it in the Company Portal. Why?</strong></summary>

**Available** apps wait for a user to install them from the Company Portal, so they need a **user group**. A device group works for **Required** apps, which install on their own. Assign Microsoft 365 Apps as Available to `Cloud Users`, as in the lab. (Lab 3.1)

</details>

<details markdown="1">
<summary><strong>2. A user says: "The ETC Homepage link never arrived." Intune reports it as installed. Who is right?</strong></summary>

Probably both. A Windows web link shows up in the **All** list of the Start menu; in class, Start search and the category view didn't show it, so it looked as if it was missing. Before you troubleshoot a deployment, check where the app type actually lands on the device. (Lab 3.1)

</details>

<details markdown="1">
<summary><strong>3. Your install script for a Win32 app exits with 0, but Intune reports the app as failed. What is the first thing you check?</strong></summary>

The **detection rule**. Intune reports **Installed** only when the detection rule finds the app after the install – the exit code alone isn't enough. If the rule points to the wrong path or file, the app counts as failed no matter how well the install ran. `AppWorkload.log` in `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs` shows download, install and detection step by step. (Lab 3.2)

</details>

<details markdown="1">
<summary><strong>4. On a freshly enrolled device, the first Win32 app takes much longer than the next ones. Why – and how do you speed up a test?</strong></summary>

The Intune Management Extension isn't there yet. It installs itself the first time a Win32 app, PowerShell script or remediation targets the user or device. After that it checks for new Win32 apps every hour and at service or device restart – so for a test, a restart is faster than waiting. (Lab 3.2)

</details>

<details markdown="1">
<summary><strong>5. Deadline 2 days, grace period 2 days. A laptop finds the quality update on Tuesday 10:00, then the user shuts it down and comes back from vacation the next Monday. When is the restart forced?</strong></summary>

The deadline clock started at the scan on Tuesday 10:00 and ended Thursday 10:00 – while the laptop was off. On Monday the laptop installs the update right away; say the restart is pending from 09:00. The grace clock now runs from there and ends **Wednesday 09:00**. Windows forces the restart when both clocks have run out, so the later one decides. Without a grace period, the restart would be forced right after the install – during the user's first hour back. (Lab 3.3, Day 3 notes)

</details>

<details markdown="1">
<summary><strong>6. You set a deadline in the ring. A colleague says: "The automatic update behavior still decides when the update installs." Correct?</strong></summary>

Only until the deadline. Once a deadline is set, the device downloads and installs the update as soon as it is offered; the automatic update behavior applies before the deadline and is ignored after it. With **Auto reboot before deadline = Yes**, Windows restarts outside active hours before the deadline; with **No** it waits for the deadline and then restarts even during active hours. (Lab 3.3)

</details>

<details markdown="1">
<summary><strong>7. Why did the test ring set the feature update deferral to 0, and why is it a bad idea to put a device into two rings?</strong></summary>

With a **feature update policy** deciding the Windows version, the ring's feature deferral would only get in the way – set it to 0 and let the policy pin the version. Two rings on one device give it conflicting settings. In production every ring targets its own device group, and the broad ring targets all devices excluding the groups of the earlier rings. (Lab 3.3)

</details>

<details markdown="1">
<summary><strong>8. Since autumn 2026 you can also set a deferral in a Windows quality update policy. Your ring says 10 days, the policy says 3. What does the device do – and where do deadlines come from?</strong></summary>

The deferral of the quality update policy overrides the ring's deferral, so 3 days. Deadlines and grace period still come from the ring. And a device in such a policy only gets the updates that are approved there – monthly security, preview, out-of-band and .NET updates, automatically or manually. (Day 3 notes)

</details>

<details markdown="1">
<summary><strong>9. CL4's hardware hash was uploaded, but CL4 ran a normal OOBE and never showed your branding. What went wrong?</strong></summary>

The profile wasn't **Assigned** yet when CL4 started OOBE. After the group assignment it takes a few minutes until the profile status changes from **Not assigned** to **Assigned**, and **Sync** doesn't speed that up. The device reads its profile at the start of OOBE – if there is none, it runs a normal OOBE. Reset and start again once the status shows Assigned. (Lab 3.4)

</details>

<details markdown="1">
<summary><strong>10. CL4 finished Autopilot, but the Company Portal arrived only some time after the first sign-in. Bug?</strong></summary>

No. The Company Portal is assigned to `All Windows 11 Devices`, a dynamic group. The group needs time to pick up the new device, so the app arrives after the membership is calculated. Apps that must be there during setup belong in an assignment that doesn't wait for a dynamic group – and, if they are essential, into the Enrollment Status Page. (Lab 3.4)

</details>

<details markdown="1">
<summary><strong>11. A security colleague is alarmed: "Anyone can press Shift+F10 in OOBE and get a command prompt." Is that a risk, and what can you do?</strong></summary>

It is how you uploaded the hash in the lab – and yes, it gives a command prompt before anyone has signed in. You can turn it off with the empty file `DisableCMDRequest.TAG` in `C:\Windows\Setup\Scripts`, for example in the image. A reset deletes the file, so recreate it with a provisioning package. Windows in S mode has it off by default. (Lab 3.4, community: Michael Niehaus)

</details>

<details markdown="1">
<summary><strong>12. An employee leaves and the Entra joined laptop goes to a new colleague. Retire, Wipe or Autopilot reset?</strong></summary>

Not **Retire** – the portal says retiring isn't supported for Entra joined Windows devices, and afterwards nobody can sign in with an Entra account. **Autopilot reset** removes personal files, apps and settings and keeps the device registered in Entra ID and Intune – made for handing a device to the next user. **Wipe** resets the device completely. Before retire or delete, back up the BitLocker recovery key and the LAPS password: both actions remove the BitLocker key protectors. (Day 3 notes)

</details>
