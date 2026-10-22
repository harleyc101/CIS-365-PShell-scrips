# Ensure shareable links are restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.7  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure shareable links are restricted (Automated).ps1`](./Ensure%20shareable%20links%20are%20restricted%20(Automated).ps1)

## Why this is required

A Power BI shareable link set to **People in your organisation** gives access to **everyone** in the company who has the link, whether or not they should see the data. Picture an HR analyst who means to share a salary report with one colleague but creates an org-wide link, which then gets forwarded around.

Restricting org-wide links pushes users towards **Specific people** or **People with existing access**, so viewers have to pass an access check. Together with proper workspace permissions, that helps prevent unintended access and internal data leaks.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `ShareLinkToEntireOrg` setting and shows whether it is enabled and which security groups it is limited to.

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
& ".\Ensure shareable links are restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `False` | **Pass.** |
| `enabled` is `True` **and** `enabledSecurityGroups` lists at least one security group | **Pass.** |
| `enabled` is `True` with no `enabledSecurityGroups` (applies to the whole organisation) | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Export and sharing settings**, and set **Allow shareable links to grant access to everyone in your organization** to either:
- **Disabled**, or
- **Enabled** with **Specific security groups** selected and defined.

If the organisation doesn't actively use this feature, keep it **Disabled**.

## Default value

Enabled for the entire organisation.

## Notes and limitations

- `enabledSecurityGroups` only appears in the output when *Specific security groups* is selected.
- External users can't use these links whatever this setting is. It only affects org-wide sharing.

## References

- https://learn.microsoft.com/en-us/power-bi/collaborate-share/service-share-dashboards#link-settings
- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-export-sharing
