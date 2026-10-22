# Ensure guest user access is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure guest user access is restricted (Automated).ps1`](./Ensure%20guest%20user%20access%20is%20restricted%20(Automated).ps1)

## Why this is required

This Fabric (Power BI) setting controls whether **B2B guest users** can access Fabric and any content shared with them. If it's enabled for the whole organisation, every guest in Entra ID, including ones invited for unrelated work in Teams or SharePoint, can potentially reach Power BI reports and datasets.

Turning it off, or limiting it to a dedicated security group, applies least privilege: only guests who have been deliberately approved for Fabric can use it. The same group can also be used for Conditional Access and access reviews.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `AllowGuestUserToAccessSharedContent` setting and shows whether it is enabled and which security groups it is limited to.

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
& ".\Ensure guest user access is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `False` | **Pass.** |
| `enabled` is `True` **and** `enabledSecurityGroups` lists at least one security group | **Pass.** |
| `enabled` is `True` with no `enabledSecurityGroups` (applies to the whole organisation) | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Export and sharing settings**, and set **Guest users can access Microsoft Fabric** to either:
- **Disabled**, or
- **Enabled** with **Specific security groups** selected and defined.

If the organisation doesn't actively use this feature, keep it **Disabled**.

## Default value

Enabled for the entire organisation.

## Notes and limitations

- `enabledSecurityGroups` only appears in the output when *Specific security groups* is selected.

## References

- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-export-sharing
