# Ensure that only organizationally managed/approved public groups exist (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.2.1  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure that only organizationally managed-approved public groups exist (Automated).ps1`](./Ensure%20that%20only%20organizationally%20managed-approved%20public%20groups%20exist%20(Automated).ps1)

## Why this is required

A **public** Microsoft 365 group can be joined by anyone in the organisation without the owner's approval. Group membership gives access to the group's SharePoint site, files, mailbox and Teams team, so a public group can expose sensitive data to every user. Users can get in by:

- adding themselves to the group in the Azure/Entra portal,
- requesting to join through the My Groups / Access Panel, which gives immediate access, or
- browsing directly to the group's SharePoint URL, which is usually easy to guess.

Groups created in the admin center are **public by default**, so public groups tend to appear without anyone deciding they should be. Every public group should be a deliberate, approved decision. Everything else should be private.

## What the script does

1. Gets every **Microsoft 365 (Unified)** group in the tenant with `Get-MgGroup -All`.
2. Shows each group's ID, display name and visibility (`Public` or `Private`).

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Group.Read.All"
  ```

## Usage

```powershell
& ".\Ensure that only organizationally managed-approved public groups exist (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Every group shows `Private` | **Pass.** |
| A group shows `Public` that the organisation has approved | **Pass.** Keep a record of the approval. |
| A group shows `Public` that has not been approved | **Fail.** |

## Remediation

In the [Microsoft 365 admin center](https://admin.microsoft.com), go to **Teams & groups > Active teams & groups**, select the public group, open **Settings**, and set **Privacy** to **Private**.

With PowerShell (Exchange Online): `Set-UnifiedGroup -Identity "<group>" -AccessType Private`

## Default value

Public when created from the admin center; private otherwise.

## Notes and limitations

- This control covers Microsoft 365 groups only, not security or distribution groups.

## References

- https://learn.microsoft.com/en-us/entra/identity/users/groups-self-service-management
- https://learn.microsoft.com/en-us/microsoft-365/admin/create-groups/compare-groups
