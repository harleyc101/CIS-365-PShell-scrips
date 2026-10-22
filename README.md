# Ensure that collaboration invitations are sent to allowed domains only (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.6.1  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure that collaboration invitations are sent to allowed domains only (Automated).ps1`](./Ensure%20that%20collaboration%20invitations%20are%20sent%20to%20allowed%20domains%20only%20(Automated).ps1)

## Why this is required

By default, users can invite guests from **any** domain into the tenant, including personal accounts like Gmail and Outlook.com. Each guest can then reach Teams, SharePoint and other resources.

An **allow list** of approved partner domains means:
- every external organisation you collaborate with is explicitly identified and approved,
- users can't invite unknown or personal accounts and give them access to company resources, and
- data is harder to exfiltrate by inviting a personal account.

## What the script does

1. Calls the Graph **beta** endpoint `legacy/policies` and finds the `B2BManagementPolicy`.
2. Decodes its JSON definition and shows the `InvitationsAllowedAndBlockedDomainsPolicy`.
3. Prints *No policy found.* if no B2B management policy exists.

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
& ".\Ensure that collaboration invitations are sent to allowed domains only (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Output has an `AllowedDomains` property listing only approved domains | **Pass.** |
| Output has `AllowedDomains` with no domains (`{}`) | **Pass.** No domains can be invited. |
| Output has a `BlockedDomains` property | **Fail.** A block list is less restrictive than an allow list. |
| "No policy found." | **Fail.** Invitations can go to any domain (the default). |

## Remediation

In the Entra admin center, go to **Entra ID > External Identities > External collaboration settings**. Under **Collaboration restrictions**, choose **Allow invitations only to the specified domains (most restrictive)** and add the approved domains under **Target domains**.

## Default value

Allow invitations to be sent to any domain (most inclusive).

## Notes and limitations

- This list doesn't control SharePoint or OneDrive sharing. Users can still share with blocked domains through *Anyone* links unless those are also restricted (see section 7).
- This uses a Graph **beta** endpoint, which Microsoft may change.

## References

- https://learn.microsoft.com/en-us/entra/external-id/allow-deny-list
- https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b
