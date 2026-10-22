# Ensure SharePoint external sharing is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.6  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure SharePoint external sharing is restricted (Automated).ps1`](./Ensure%20SharePoint%20external%20sharing%20is%20restricted%20(Automated).ps1)

## Why this is required

Attackers and malicious insiders often get data out simply by sharing it with an external account they control. If users can share with **any** external domain, nothing technical stops that.

Limiting external sharing to an **allow list of approved partner domains** means content can only be shared with organisations you have a business relationship with, which greatly reduces this route for exfiltration.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `SharingCapability`, `SharingDomainRestrictionMode` and `SharingAllowedDomainList`.

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
& ".\Ensure SharePoint external sharing is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `SharingCapability` is `Disabled` | **Pass.** No external sharing at all. |
| `SharingDomainRestrictionMode` is `AllowList` and `SharingAllowedDomainList` contains only approved domains | **Pass.** |
| `SharingDomainRestrictionMode` is `None` or `BlockList` | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing > More external sharing settings**. Tick **Limit external sharing by domain**, choose **Add domains > Allow only specific domains**, enter the approved domains, and save.

**PowerShell:**
```powershell
Set-SPOTenant -SharingDomainRestrictionMode AllowList -SharingAllowedDomainList "domain1.com domain2.com"
```
Keep the list up to date as partners change. Existing shares to domains not on the list are **not** revoked.

## Default value

*Limit external sharing by domain* unticked (`SharingDomainRestrictionMode` = `None`, empty allow list).

## References

- https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off#more-external-sharing-settings
