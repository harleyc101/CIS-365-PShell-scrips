# Ensure 'Block ResourceKey Authentication' is 'Enabled' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.9  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure 'Block ResourceKey Authentication' is 'Enabled' (Automated).ps1`](./Ensure%20%27Block%20ResourceKey%20Authentication%27%20is%20%27Enabled%27%20(Automated).ps1)

## Why this is required

**Resource keys** let applications push data into Power BI streaming and push datasets using a static key in the API URL, **without any user or app identity**. Anyone who has the key can write data, and that access bypasses the organisation's identity controls: no Entra ID sign-in, no MFA, no Conditional Access, and limited auditing.

Blocking resource key authentication means all data sent to Power BI is tied to a proper Entra ID identity.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `BlockResourceKeyAuthentication` setting and shows whether it is enabled and which security groups it is limited to.

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
& ".\Ensure 'Block ResourceKey Authentication' is 'Enabled' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `True` (resource key auth is **blocked**) | **Pass.** |
| `enabled` is `False` | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Developer settings**, and set **Block ResourceKey Authentication** to **Enabled**.

Developers who need streaming datasets should authenticate through Entra ID, or ask for a documented exception.

## Default value

Disabled for the entire organisation (resource keys are allowed).

## References

- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-developer
- https://learn.microsoft.com/en-us/power-bi/connect-data/service-real-time-streaming
