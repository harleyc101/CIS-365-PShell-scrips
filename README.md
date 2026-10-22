# Ensure that guest user access is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.6.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure that guest user access is restricted (Automated).ps1`](./Ensure%20that%20guest%20user%20access%20is%20restricted%20(Automated).ps1)

## Why this is required

Guest users can be given the same directory permissions as members. They can then list every user, group and group membership in the tenant through Graph, PowerShell, the Azure portal and so on.

Attackers use that kind of enumeration for **reconnaissance**, the first stage of the cyber kill chain: finding out who the admins, finance staff and executives are before launching targeted attacks. Restricting guests to limited access, or to only their own objects, cuts off that source of information if a guest account is compromised or malicious.

## What the script does

1. Reads the tenant authorisation policy and shows `GuestUserRoleId`.

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
& ".\Ensure that guest user access is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `10dae51f-b6af-4016-8d66-8c2a99b929b3` | **Pass.** Guests have limited access to directory objects (the default). |
| `2af84b1e-32c8-42b7-82bc-daa82404023b` | **Pass.** Guests can see only their own objects (most restrictive). |
| `a0b1b346-4d3e-4e8b-98f8-753987be4970` | **Fail.** Guests have the same access as members. |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > External Identities > External collaboration settings**. Under **Guest user access**, choose either *Guest users have limited access to properties and memberships of directory objects* or *Guest user access is restricted to properties and memberships of their own directory objects (most restrictive)*.

**PowerShell** (Needs `Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"`.):
```powershell
# Guest users have limited access to properties and memberships of directory objects
Update-MgPolicyAuthorizationPolicy -GuestUserRoleId '10dae51f-b6af-4016-8d66-8c2a99b929b3'

# Or: Guest user access is restricted to properties and memberships of their own directory objects (most restrictive)
Update-MgPolicyAuthorizationPolicy -GuestUserRoleId '2af84b1e-32c8-42b7-82bc-daa82404023b'
```

## Default value

Guest users have limited access (`10dae51f-b6af-4016-8d66-8c2a99b929b3`).

## Notes and limitations

- With the most restrictive setting, guests can't see other users, groups or memberships. That can affect some collaboration features (for example, known issues with guests leaving Yammer/Viva Engage groups).

## References

- https://learn.microsoft.com/en-us/entra/identity/users/users-restrict-guest-permissions
- https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html
