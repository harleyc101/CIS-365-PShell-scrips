# Ensure access to APIs by service principals is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.10  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure access to APIs by service principals is restricted (Automated).ps1`](./Ensure%20access%20to%20APIs%20by%20service%20principals%20is%20restricted%20(Automated).ps1)

## Why this is required

The Fabric public APIs allow programmatic create, read, update and delete operations across Power BI and Fabric. If **any** service principal in the tenant can call them, a single compromised app secret or certificate, from anywhere in the tenant, gives an attacker broad, scriptable access to Fabric content.

Limiting API access to service principals in a **dedicated, approved security group** shrinks that attack surface to only the apps that need it.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `ServicePrincipalAccessPermissionAPIs` setting and shows whether it is enabled and which security groups it is limited to.

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
& ".\Ensure access to APIs by service principals is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `False` | **Pass.** |
| `enabled` is `True` **and** `enabledSecurityGroups` lists at least one security group | **Pass.** |
| `enabled` is `True` with no `enabledSecurityGroups` (applies to the whole organisation) | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Developer settings**, and set **Service principals can call Fabric public APIs** to either:
- **Disabled**, or
- **Enabled** with **Specific security groups** selected and defined.

If the organisation doesn't actively use this feature, keep it **Disabled**.

## Default value

Enabled for the entire organisation.

## Notes and limitations

- `enabledSecurityGroups` only appears in the output when *Specific security groups* is selected.
- If you run this audit with a service principal, it needs to be in the allowed group for this setting.

## References

- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-developer
