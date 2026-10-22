# Ensure external user invitations are restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure external user invitations are restricted (Automated).ps1`](./Ensure%20external%20user%20invitations%20are%20restricted%20(Automated).ps1)

## Why this is required

This setting decides whether users can **invite new external users** into the organisation through Power BI's sharing, permissions and subscription features. Without restriction, any Power BI user can bring new guests into the tenant just by sharing a report, which goes around the organisation's normal guest-approval process.

Disabling it, or limiting it to a specific security group, means only approved people can create new guest access through Fabric.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `ExternalSharingV2` setting and shows whether it is enabled and which security groups it is limited to.

## Prerequisites

- The [Az.Accounts module](https://learn.microsoft.com/powershell/azure/install-azure-powershell):
  ```powershell
  Install-Module Az.Accounts -Scope CurrentUser
  ```
- **PowerShell 7.5** or later.
- The **Fabric Administrator** (or Global Administrator) role for interactive sign-in. **Global Reader can't** read Fabric tenant settings.
- To run unattended with a service principal instead, replace `-Interactive` with `-TenantParams @{ CertificateThumbprint = '...'; ApplicationId = '...'; TenantId = '...' }`. The service principal must be in a group allowed by the Fabric tenant settings *Service principals can call Fabric public APIs* and *Service principals can access read-only admin APIs*. Don't give the app registration any Power BI API permissions, because they cause errors.

## Usage

```powershell
& ".\Ensure external user invitations are restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `False` | **Pass.** |
| `enabled` is `True` **and** `enabledSecurityGroups` lists at least one security group | **Pass.** |
| `enabled` is `True` with no `enabledSecurityGroups` (applies to the whole organisation) | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Export and sharing settings**, and set **Users can invite guest users to collaborate through item sharing and permissions** to either:
- **Disabled**, or
- **Enabled** with **Specific security groups** selected and defined.

If the organisation doesn't actively use this feature, keep it **Disabled**.

## Default value

Enabled for the entire organisation.

## Notes and limitations

- `enabledSecurityGroups` only appears in the output when *Specific security groups* is selected.
- Users also need the Entra **Guest Inviter** role, or equivalent tenant settings, to invite external users (see 5.1.6.3).

## References

- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-export-sharing
- https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-azure-ad-b2b#invite-guest-users
