# Ensure users cannot create security groups (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.3.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure users cannot create security groups (Automated).ps1`](./Ensure%20users%20cannot%20create%20security%20groups%20(Automated).ps1)

## Why this is required

If users can create security groups themselves, group sprawl follows quickly, and the creator automatically becomes the owner. That gets risky when those groups are later used to grant access.

There's a more deliberate attack too. A compromised ordinary account creates groups with **convincing names** such as "Accounting", "IT Admins" or "Break-glass", or uses look-alike characters. An administrator, especially at a third-party IT provider who doesn't know the environment, may then mistakenly:
- assign the group elevated privileges,
- give it access to sensitive data, or
- **exclude it from Conditional Access policies**.

Any of these quietly gives the attacker a serious security gap.

## What the script does

1. Reads the tenant authorisation policy's default user role permissions and shows all of them.

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
& ".\Ensure users cannot create security groups (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowedToCreateSecurityGroups` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > Groups > General**, set **Users can create security groups in Azure portals, API or PowerShell** to **No**, and save.

**PowerShell** (Needs `Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"`.):
```powershell
$params = @{
    defaultUserRolePermissions = @{
        AllowedToCreateSecurityGroups = $false
    }
}
Update-MgPolicyAuthorizationPolicy -BodyParameter $params
```

## Default value

`AllowedToCreateSecurityGroups`: `True`

## References

- https://learn.microsoft.com/en-us/entra/identity/users/groups-self-service-management#group-settings
- https://learn.microsoft.com/en-us/graph/api/authorizationpolicy-get
