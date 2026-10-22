# Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.2.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes' (Automated).ps1`](./Ensure%20%27Restrict%20non-admin%20users%20from%20creating%20tenants%27%20is%20set%20to%20%27Yes%27%20(Automated).ps1)

## Why this is required

By default, any user can create a brand-new Microsoft Entra tenant, and they automatically become its **Global Administrator**. The new tenant inherits **none** of your organisation's security settings, policies or monitoring.

This is shadow IT. Users may start storing company data or running business processes in a tenant the security team doesn't know about, believing it's protected by the organisation when it isn't. Restricting tenant creation to admins keeps the organisation in control of its cloud estate.

## What the script does

1. Reads the tenant authorisation policy's default user role permissions.
2. Shows `AllowedToCreateTenants`.

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
& ".\Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowedToCreateTenants` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > Users > User settings**, set **Restrict non-admin users from creating tenants** to **Yes**, and save.

**PowerShell** (Needs `Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"`.):
```powershell
# Create hashtable and update the auth policy
$params = @{ AllowedToCreateTenants = $false }
Update-MgPolicyAuthorizationPolicy -DefaultUserRolePermissions $params
```

## Default value

No: non-administrators can create tenants (`AllowedToCreateTenants` is `True`).

## Notes and limitations

- Tenant creation is logged in the audit log under category *DirectoryManagement*, activity *Create Company*.

## References

- https://learn.microsoft.com/en-us/entra/fundamentals/users-default-permissions#restrict-member-users-default-permissions
- https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#tenant-creator
