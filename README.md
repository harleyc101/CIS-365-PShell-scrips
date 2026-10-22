# Ensure user consent to apps accessing company data on their behalf is not allowed (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.5.1  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure user consent to apps accessing company data on their behalf is not allowed (Automated).ps1`](./Ensure%20user%20consent%20to%20apps%20accessing%20company%20data%20on%20their%20behalf%20is%20not%20allowed%20(Automated).ps1)

## Why this is required

**Consent phishing** (also called illicit consent grant) is a common attack. The user is sent a link to a legitimate-looking Microsoft sign-in page for an attacker's app, which asks for permissions such as *Read your mail* or *Access your files*. If the user clicks **Accept**, the attacker's app gets an OAuth token with ongoing access to their data. That access doesn't need the user's password and survives password resets and MFA.

Turning off user consent means only administrators can grant apps access to company data. Combined with the admin consent workflow (5.1.5.2), users can still request the apps they need.

## What the script does

1. Reads the permission grant policies assigned to the default user role.

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
& ".\Ensure user consent to apps accessing company data on their behalf is not allowed (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Output does **not** contain `ManagePermissionGrantsForSelf.microsoft-user-default-low` or `ManagePermissionGrantsForSelf.microsoft-user-default-legacy` | **Pass.** User consent is off. |
| Output contains either of those values | **Fail.** Users can consent to apps. |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > Enterprise apps > Consent and permissions > User consent settings**, select **Do not allow user consent**, and save.

Existing consents stay in place. Review them under **Enterprise apps > All applications > Permissions**.

## Default value

Allow user consent for apps.

## References

- https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-user-consent
- https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.identity.signins/get-mgpolicyauthorizationpolicy
