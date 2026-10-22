# Ensure 'Allow users to apply sensitivity labels for content' is 'Enabled' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.6  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure 'Allow users to apply sensitivity labels for content' is 'Enabled' (Automated).ps1`](./Ensure%20%27Allow%20users%20to%20apply%20sensitivity%20labels%20for%20content%27%20is%20%27Enabled%27%20(Automated).ps1)

## Why this is required

Power BI reports and datasets often hold some of the organisation's most sensitive data, aggregated in one place. Letting users apply **Microsoft Purview sensitivity labels** to Fabric content means:

- the data's classification is clear to everyone who uses it,
- labels and their protection, such as encryption, **carry over** when data is exported to Excel, PowerPoint or PDF, and
- DLP and access controls can act on the label to prevent accidental exposure.

Unlike most Fabric settings in this benchmark, this one should be **Enabled**.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `EimInformationProtectionEdit` setting and shows whether it is enabled and which security groups it is limited to.

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
& ".\Ensure 'Allow users to apply sensitivity labels for content' is 'Enabled' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `True` (whole organisation) | **Pass.** |
| `enabled` is `True` with `enabledSecurityGroups` listing at least one group | **Pass.** |
| `enabled` is `False` | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Information protection**, and set **Allow users to apply sensitivity labels for content** to **Enabled**, either for the whole organisation or for specific security groups.

Sensitivity labels must already be set up and published in Microsoft Purview (see 3.3.1).

## Default value

Disabled.

## Notes and limitations

- Labels and protection apply only to exports to Excel, PowerPoint and PDF. Other export paths don't carry labels.
- Users need extra licences, such as Power BI Pro, to apply labels.

## References

- https://learn.microsoft.com/en-us/power-bi/enterprise/service-security-enable-data-sensitivity-labels
- https://learn.microsoft.com/en-us/fabric/governance/data-loss-prevention-overview
