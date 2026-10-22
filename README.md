# Ensure users cannot register applications (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.2.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure users cannot register applications (Automated).ps1`](./Ensure%20users%20cannot%20register%20applications%20(Automated).ps1)

## Why this is required

By default, any user can create an **app registration** in Entra ID, which is an identity object for an application that can then request access to organisational data.

A compromised account or a malicious insider can use this to create a rogue app that:
- acts as a **persistent OAuth client** that keeps working after the user's password is reset,
- is used for token theft or consent phishing, or
- impersonates a legitimate application.

Restricting app registration to privileged roles (Application Administrator or Cloud Application Administrator) means every new application identity is reviewed and approved before it can be given access to anything.

## What the script does

1. Reads the tenant authorisation policy's default user role permissions.
2. Shows `AllowedToCreateApps`.

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
& ".\Ensure users cannot register applications (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowedToCreateApps` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [Entra admin center](https://entra.microsoft.com), go to **Entra ID > Users > User settings**, set **Users can register applications** to **No**, and save.

**PowerShell** (Needs `Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"`.):
```powershell
$param = @{ AllowedToCreateApps = $false }
Update-MgPolicyAuthorizationPolicy -DefaultUserRolePermissions $param
```
Set up a request process for developers and IT staff who need app registrations before you make this change.

## Default value

Yes: users can register applications.

## References

- https://learn.microsoft.com/en-us/entra/identity-platform/how-applications-are-added
- https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/delegate-app-roles#restrict-who-can-create-applications
