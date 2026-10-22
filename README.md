# Ensure the admin consent workflow is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.5.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the admin consent workflow is enabled (Automated).ps1`](./Ensure%20the%20admin%20consent%20workflow%20is%20enabled%20(Automated).ps1)

## Why this is required

Once user consent is turned off (5.1.5.1), users who need an app have no way to ask for it unless the **admin consent workflow** is on. Without it they tend to find workarounds, or IT gets ad-hoc requests with no audit trail.

The workflow lets users submit a request from the consent screen. The request is emailed to designated reviewers (Global Admin, Cloud Application Admin or Application Admin), who approve or deny it, and the user is told the outcome. It gives a safe, auditable way to grant app access.

## What the script does

1. Reads the admin consent request policy.
2. Shows `IsEnabled`, `NotifyReviewers` and `RemindersEnabled`.

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
& ".\Ensure the admin consent workflow is enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `IsEnabled` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

In the Entra admin center, go to **Entra ID > Enterprise apps > Consent and permissions > Admin consent settings**:
1. Set **Users can request admin consent to apps they are unable to consent to** to **Yes**.
2. Choose the reviewers (users, groups or roles).
3. Set **Selected users will receive email notifications for requests** to **Yes**.
4. Save.

Reviewers must already hold Global Admin, Cloud Application Admin or Application Admin to approve requests. Being named as a reviewer doesn't grant those roles.

## Default value

Admin consent requests: **No**. Reviewers: none. Email notifications and reminders: **Yes**. Requests expire after 30 days.

## References

- https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-admin-consent-workflow
