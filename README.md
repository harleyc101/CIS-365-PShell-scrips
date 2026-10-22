# Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.2  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices (Automated).ps1`](./Ensure%20%27Idle%20session%20timeout%27%20is%20set%20to%20%273%20hours%20(or%20less)%27%20for%20unmanaged%20devices%20(Automated).ps1)

## Why this is required

A browser session left signed in on an unattended device can be used by anyone who walks up to it. That's a particular risk on **unmanaged** devices such as home PCs, shared or kiosk machines and hotel business centres. Idle session timeout signs users out of Microsoft 365 web apps (Outlook on the web, SharePoint, OneDrive, Office for the web, admin portals and so on) after a period of inactivity, which limits that window.

The control has two parts:

1. **Idle session timeout** of 3 hours or less, set at org level.
2. **A Conditional Access policy** using *app enforced restrictions*. This makes the timeout apply only to unmanaged devices, so users on managed, compliant devices aren't repeatedly prompted to sign in.

## What the script does

1. **Step 1:** reads the tenant's activity-based timeout policy with `Get-MgPolicyActivityBasedTimeoutPolicy`, converts `WebSessionIdleTimeout` to a time span, and prints **PASS** if it is 3 hours or less, otherwise **FAIL**.
2. **Step 2:** gets every Conditional Access policy that has **Use app enforced restrictions** enabled.
3. For each of those policies it checks that it targets only `Office365`, applies only to the `browser` client app type, and is `enabled`. It reports each policy as **PASS** or **FAIL**.
4. If no such policy exists, it prints **FAIL**.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Policy.Read.All"
  ```

## Usage

```powershell
& ".\Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices (Automated).ps1"
```

## Interpreting the results

**Both** steps must pass.

| Output | Result |
| --- | --- |
| Step 1 prints `** PASS ** Timeout is set to ...` | Step 1 passes. |
| Step 1 prints `** FAIL **` | Step 1 fails: the timeout isn't set or is longer than 3 hours. |
| At least one policy in Step 2 shows `AuditState : PASS` | Step 2 passes. |
| No policy in Step 2 shows PASS, or "no qualifying conditional access policies" is printed | Step 2 fails. |

`IncludeUsers` is shown for information only. It should normally be `All` but isn't scored.

## Remediation

**Step 1 – Idle session timeout:** In the Microsoft 365 admin center, go to **Settings > Org settings > Security & privacy > Idle session timeout**. Turn it on and set a value of **3 hours or less**.

**Step 2 – Conditional Access:** In the [Entra admin center](https://entra.microsoft.com), go to **Protection > Conditional Access**, create a new policy, and set:
- **Users:** All users
- **Target resources:** Select apps > **Office 365**
- **Conditions > Client apps:** **Browser** only
- **Session:** **Use app enforced restrictions**
- **Enable policy:** On

Without step 2, the timeout also applies to managed devices.

## Default value

Not configured: idle sessions do not time out.

## Notes and limitations

- Idle session timeout does not affect the Microsoft 365 desktop and mobile apps.
- Users are not signed out if they get SSO from a joined device, if they chose **Stay signed in**, or if they are on a managed device with a supported browser.
- The timeout does not work if the browser blocks third-party cookies.
- It also sets the Azure portal idle timeout, unless that has been set separately.

## References

- https://learn.microsoft.com/en-us/microsoft-365/admin/manage/idle-session-timeout-web-apps
