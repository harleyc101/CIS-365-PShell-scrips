# Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled (Automated).ps1`](./Ensure%20SharePoint%20and%20OneDrive%20integration%20with%20Azure%20AD%20B2B%20is%20enabled%20(Automated).ps1)

## Why this is required

Without Entra ID B2B integration, SharePoint and OneDrive use their own separate one-time-passcode guest experience. External people can access shared files **without a guest account in Entra ID**, so they aren't covered by Entra ID policies such as Conditional Access and MFA, and they're harder to audit and manage.

With B2B integration turned on, everyone you share with externally becomes a proper **Entra ID guest account**. That's the same model Teams uses, so you have one place to see, govern, review and remove external access.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `EnableAzureADB2BIntegration`.

## Prerequisites

- The [SharePoint Online Management Shell](https://learn.microsoft.com/powershell/sharepoint/sharepoint-online/connect-sharepoint-online):
  ```powershell
  Install-Module Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-SPOService -Url https://<tenant>-admin.sharepoint.com   # replace <tenant> with your tenant name
  ```
- The SharePoint Online module works best in **Windows PowerShell 5.1**. In PowerShell 7, load it with `Import-Module Microsoft.Online.SharePoint.PowerShell -UseWindowsPowerShell`.
- You need the SharePoint Administrator or Global Administrator role. **Global Reader can't** connect to SharePoint Online PowerShell.

## Usage

```powershell
& ".\Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableAzureADB2BIntegration` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

```powershell
Set-SPOTenant -EnableAzureADB2BIntegration $true
```
External users with existing one-time-passcode shares will get *"This organization has updated its guest access settings"* and need those items **re-shared** with them.

## Default value

`False`

## References

- https://learn.microsoft.com/en-us/sharepoint/sharepoint-azureb2b-integration#enabling-the-integration
- https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b
