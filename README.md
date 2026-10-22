# Ensure OneDrive content sharing is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.4  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure OneDrive content sharing is restricted (Automated).ps1`](./Ensure%20OneDrive%20content%20sharing%20is%20restricted%20(Automated).ps1)

## Why this is required

OneDrive is personal storage. Unlike a SharePoint site, nobody else, such as a site owner or content manager, oversees what each user shares from it. That makes it easy for people to share sensitive files externally, deliberately or by accident, without anyone noticing.

Restricting OneDrive to **Only people in your organisation** means anything that needs to go outside has to be moved to a SharePoint site first, where tighter controls and oversight apply.

## What the script does

1. Shows the tenant-level `OneDriveSharingCapability`.
2. As a fallback, finds the OneDrive host site (`*-my.sharepoint.com/`) and shows its `SharingCapability`. This gives the same answer in tenants where the newer `OneDriveSharingCapability` property isn't available yet.

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
& ".\Ensure OneDrive content sharing is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `OneDriveSharingCapability` (or the OneDrive site's `SharingCapability`) is `Disabled` | **Pass.** |
| Any other value | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing** and set the **OneDrive** slider to **Only people in your organization**.

**PowerShell:**
```powershell
Set-SPOTenant -OneDriveSharingCapability Disabled

# Or, if that parameter isn't available in your tenant:
$OneDriveSite = Get-SPOSite -Filter { Url -like "*-my.sharepoint.com/" }
Set-SPOSite -Identity $OneDriveSite -SharingCapability Disabled
```

## Default value

Anyone (`ExternalUserAndGuestSharing`)

## Notes and limitations

- Query the OneDrive site with `-Identity` as the script does. Filtering all sites with `Where-Object` can return a different, misleading value (observed since March 2024).

## References

- https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant#-onedrivesharingcapability
