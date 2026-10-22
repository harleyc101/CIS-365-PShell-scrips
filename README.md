# Ensure Administrative accounts are cloud-only (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark
**Script:** [`Ensure Administrative accounts are cloud-only (Automated).ps1`](./Ensure%20Administrative%20accounts%20are%20cloud-only%20(Automated).ps1)

## Why this is required

In a hybrid environment, user accounts can be synchronised from on-premises Active Directory into Microsoft Entra ID (Azure AD) using Entra Connect. If a privileged Microsoft 365 account is one of these synced accounts, its security depends on the on-premises directory:

- **A compromised on-premises AD means a compromised cloud tenant.** An attacker with control of on-premises AD can reset the password of a synced account, or change its group memberships, and that change flows up to the cloud. A domain-level breach then becomes a tenant-wide breach.
- **It widens the attack surface.** Synced admin accounts can be reached through on-premises attack paths such as credential theft from workstations, pass-the-hash, and Kerberos attacks, as well as cloud ones.
- **Recovery is harder.** If on-premises AD is unavailable or untrusted (during a ransomware incident, for example), synced admin accounts may not be usable or trustworthy. Cloud-only admin accounts let you keep control of the tenant while you recover.

Keeping administrative accounts **cloud-only** separates the two environments. Cloud admin accounts are then protected only by Entra ID controls (MFA, Conditional Access, PIM), and an on-premises compromise cannot be used to take over the tenant.

## What the script does

1. **Gets the activated directory roles** in the tenant with `Get-MgDirectoryRole`.
2. **Filters to privileged roles.** It keeps any role whose name contains `Administrator` (Global Administrator, Exchange Administrator, and so on), plus `Global Reader`.
3. **Collects role members.** It lists the members of each privileged role with `Get-MgDirectoryRoleMember` and removes duplicate IDs, so a user who holds several roles appears once.
4. **Looks up each member** with `Get-MgUser` and retrieves `DisplayName`, `UserPrincipalName`, `Id` and `OnPremisesSyncEnabled`.
5. **Reports any synced admins.** It shows a table of the privileged users whose `OnPremisesSyncEnabled` is `True`.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A Graph session with read permissions for roles and users:
  ```powershell
  Connect-MgGraph -Scopes "RoleManagement.Read.Directory","User.Read.All"
  ```

## Usage

```powershell
.\"Ensure Administrative accounts are cloud-only (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| No rows returned | **Pass.** No privileged account is synced from on-premises. |
| One or more rows returned | **Fail.** Each listed account holds a privileged role and is synced from on-premises AD. |

## Remediation

For each account the script lists:

1. Create a new **cloud-only** account (with an `onmicrosoft.com` UPN or a cloud-managed domain) for the administrator.
2. Assign the required roles to the new account, using PIM for just-in-time access where possible.
3. Remove the privileged roles from the synced account.

## Notes and limitations

- `Get-MgDirectoryRole` returns only roles that have been **activated** in the tenant (a role is activated once it has had a member). Roles that have never been assigned aren't listed, which is fine here because they have no members.
- The script checks **active** role assignments only. **PIM-eligible** assignments aren't included.
- If a role contains a group or service principal, `Get-MgUser` will return an error for that member. The error can be ignored, because only user accounts are relevant to this check.
