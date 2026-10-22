# Ensure 'Interact with and share R and Python' visuals is 'Disabled' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.5  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure 'Interact with and share R and Python' visuals is 'Disabled' (Automated).ps1`](./Ensure%20%27Interact%20with%20and%20share%20R%20and%20Python%27%20visuals%20is%20%27Disabled%27%20(Automated).ps1)

## Why this is required

R and Python visuals let report authors embed **arbitrary R or Python code** in Power BI reports. That's powerful for statistics and machine learning, but it also means code written by any report author runs against the organisation's data. Malicious or careless scripts could exfiltrate data, reach unauthorised resources, or expose sensitive data to people who view the report.

Disabling these visuals removes that code-execution risk. Developers who need them can be given a controlled exception with code review.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `RScriptVisual` setting and shows whether it is enabled and which security groups it is limited to.

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
& ".\Ensure 'Interact with and share R and Python' visuals is 'Disabled' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `False` | **Pass.** |
| `enabled` is `True` | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **R and Python visuals settings**, and set **Interact with and share R and Python visuals** to **Disabled**.

## Default value

Enabled.

## References

- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-r-python-visuals
- https://learn.microsoft.com/en-us/power-bi/visuals/service-r-visuals
