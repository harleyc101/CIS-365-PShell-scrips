# Ensure guest user invitations are limited (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.6.3  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure guest user invitations are limited (Automated).ps1`](./Ensure%20guest%20user%20invitations%20are%20limited%20(Automated).ps1)

## Why this is required

By default, **everyone** in the organisation, including existing guests, can invite new external users into the tenant. Every guest is a new identity with access to your resources, and the organisation can't vouch for its security.

Limiting invitations to specific admin roles, such as the **Guest Inviter** role, or turning them off entirely, means every new guest goes through an approval step. It also stops a compromised account or guest from inviting further outsiders.

## What the script does

1. Reads the tenant authorisation policy and shows `AllowInvitesFrom`.

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
& ".\Ensure guest user invitations are limited (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `adminsAndGuestInviters` | **Pass.** Only users in specific admin roles can invite guests. |
| `none` | **Pass.** Nobody can invite guests (most restrictive). |
| `everyone` or `adminsGuestInvitersAndAllMembers` | **Fail.** |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > External Identities > External collaboration settings**. Under **Guest invite settings**, choose *Only users assigned to specific admin roles can invite guest users* or *No one in the organization can invite guest users including admins (most restrictive)*.

**PowerShell** (Needs `Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"`.):
```powershell
# Only users assigned to specific admin roles can invite guest users
Update-MgPolicyAuthorizationPolicy -AllowInvitesFrom 'adminsAndGuestInviters'

# Or: No one in the organization can invite guest users including admins (most restrictive)
Update-MgPolicyAuthorizationPolicy -AllowInvitesFrom 'none'
```
Assign the **Guest Inviter** role to the people who should handle requests, and tell users about the approval process.

## Default value

Anyone in the organisation, including guests and non-admins, can invite guest users (`everyone`).

## References

- https://learn.microsoft.com/en-us/entra/external-id/external-collaboration-settings-configure
- https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#guest-inviter
