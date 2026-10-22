# Ensure that between two and four global admins are designated (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.1.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure that between two and four global admins are designated (Automated).ps1`](./Ensure%20that%20between%20two%20and%20four%20global%20admins%20are%20designated%20(Automated).ps1)

## Why this is required

The Global Administrator role has unrestricted access to every part of Microsoft Entra ID and Microsoft 365, so how many people hold it matters:

- **Fewer than two** creates a single point of failure. If that one account is locked out, lost or compromised, nobody else can recover the tenant, and there is no peer oversight of what the single admin does.
- **More than four** makes the tenant easier to attack. Each extra Global Admin is another high-value account that could be phished or compromised, and it goes against least privilege.

Two to four balances redundancy against risk. Global Admin accounts should also use strong authentication, such as a FIDO2 key or certificate, and ideally have no licence assigned.

## What the script does

1. Finds the Global Administrator role by its fixed role template ID (`62e90394-69f5-4237-9190-012177145e10`), so it works whatever the role is called.
2. Lists the role's members with `Get-MgDirectoryRoleMember`.
3. Expands any **role-assignable groups** in the role to their user members, so admins who get the role through a group are counted too.
4. Removes duplicates, so a user who is both a direct member and a group member is counted once.
5. Writes the total number of Global Administrators to the console.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Directory.Read.All"
  ```

## Usage

```powershell
& ".\Ensure that between two and four global admins are designated (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Count is 2, 3 or 4 | **Pass.** |
| Count is 0 or 1 | **Fail.** Add another Global Administrator. |
| Count is 5 or more | **Fail.** Review who needs the role and remove the rest. |

## Remediation

In the [Microsoft 365 admin center](https://admin.microsoft.com), go to **Users > Active users**, select the user, choose **Manage roles**, then tick or untick **Global Administrator** under **Admin center access** and save.

Where possible, give extra administrators a less-privileged role that covers their actual job, or make them eligible through PIM instead of permanently assigned.

## Default value

N/A

## Notes and limitations

- Partner relationships (delegated admin from a Microsoft partner) are not counted. Review them separately under **Settings > Partner relationships**.
- Only active role assignments are counted. PIM-eligible Global Admins are not included.
- If the tenant uses a third-party identity provider, apply equivalent controls in that provider.

## References

- https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#all-roles
- https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/best-practices#5-limit-the-number-of-global-administrators-to-less-than-5
- https://learn.microsoft.com/en-us/microsoft-365/admin/add-users/about-admin-roles#security-guidelines-for-assigning-roles
