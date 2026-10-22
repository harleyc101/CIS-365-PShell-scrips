# Ensure 'Publish to web' is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 9.1.4  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure 'Publish to web' is restricted (Automated).ps1`](./Ensure%20%27Publish%20to%20web%27%20is%20restricted%20(Automated).ps1)

## Why this is required

**Publish to web** creates a public link or embed code for a Power BI report that **anyone on the internet can view with no sign-in at all**, including the detailed data behind the visuals. Links can be found by search engines, shared on social media, or simply guessed.

A single careless *Publish to web* can expose confidential financial, customer or personal data publicly. Turning it off, or restricting it to a specific group and allowing only existing embed codes, prevents accidental public exposure.

## What the script does

1. Defines the benchmark's `Get-CISFabricTenantSettings` helper, which signs in with **Az.Accounts**, gets a token for the Fabric API, and reads the tenant settings from `https://api.fabric.microsoft.com/v1/admin/tenantsettings`.
2. Runs it interactively, which opens a sign-in window.
3. Picks out the `PublishToWeb` setting and shows whether it is enabled and which security groups it is limited to.
4. Also shows the setting's nested `properties`, which include `createP2w`. That property controls whether **new** embed codes can be created.

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
& ".\Ensure 'Publish to web' is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `enabled` is `False` | **Pass.** |
| `enabled` is `True` **and** `createP2w` is `false` (only existing codes) **and** `enabledSecurityGroups` lists at least one group | **Pass.** |
| Any other combination | **Fail.** |

## Remediation

In the [Fabric admin portal](https://app.powerbi.com/admin-portal), go to **Tenant settings**, scroll to **Export and sharing settings**, and set **Publish to web** to either:
- **Disabled**, or
- **Enabled** with **Choose how embed codes work** set to **Only allow existing codes**, **and** **Specific security groups** selected and defined.

If the organisation doesn't actively use this feature, keep it **Disabled**.

Also review existing public embed codes under **Admin portal > Embed codes** and delete any that aren't needed.

## Default value

Enabled for the entire organisation, with *Only allow existing codes*.

## Notes and limitations

- `enabledSecurityGroups` only appears in the output when *Specific security groups* is selected.

## References

- https://learn.microsoft.com/en-us/power-bi/collaborate-share/service-publish-to-web
- https://learn.microsoft.com/en-us/fabric/admin/service-admin-portal-export-sharing#publish-to-web
