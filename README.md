# Ensure service principals cannot create and use profiles (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.11  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure service principals cannot create and use profiles (Automated).ps1`](./Ensure%20service%20principals%20cannot%20create%20and%20use%20profiles%20(Automated).ps1)

## Why this is required

**Service principal profiles** are used by multi-tenant Power BI Embedded apps to keep each customer's data separate. They're a niche feature. If any service principal can create and use profiles, it adds attack surface without any business need.

Keeping it disabled, or limited to the specific service principals of an approved embedded app through a security group, follows least privilege.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `AllowServicePrincipalsCreateAndUseProfiles` setting and shows whether it is enabled and which security groups it is limited to.

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
& ".\Ensure service principals cannot create and use profiles (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `False` | **Pass.** |
| `enabled` is `True` **and** `enabledSecurityGroups` lists at least one security group | **Pass.** |
| `enabled` is `True` with no `enabledSecurityGroups` (applies to the whole organisation) | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Developer settings**, and set **Allow service principals to create and use profiles** to either:
- **Disabled**, or
- **Enabled** with **Specific security groups** selected and defined.

If the organisation doesn't actively use this feature, keep it **Disabled**.

## Default value

Disabled for the entire organisation.

## Notes and limitations

- `enabledSecurityGroups` only appears in the output when *Specific security groups* is selected.

## References

- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-developer
- https://learn.microsoft.com/en-us/power-bi/developer/embedded/embed-multi-tenancy
