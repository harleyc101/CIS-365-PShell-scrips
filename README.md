# Ensure link sharing is restricted in SharePoint and OneDrive (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.7  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure link sharing is restricted in SharePoint and OneDrive (Automated).ps1`](./Ensure%20link%20sharing%20is%20restricted%20in%20SharePoint%20and%20OneDrive%20(Automated).ps1)

## Why this is required

Whichever link type is pre-selected in the Share dialog is the one most users will use. If the default is a broad link, such as *Anyone* or *People in your organisation*, files end up far more widely accessible than intended.

Setting the default to **Specific people** (or at most **Only people in your organisation**) makes users think about who actually needs access, which reinforces least privilege. Users can still pick other link types if policy allows.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `DefaultSharingLinkType`.

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
& ".\Ensure link sharing is restricted in SharePoint and OneDrive (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `Direct` (specific people) | **Pass.** |
| `Internal` (only people in your organisation) | **Pass.** |
| `AnonymousAccess` (anyone) or `None` | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing > File and folder links** and set the default link type to **Specific people** or **Only people in your organization**.

**PowerShell:**
```powershell
# Specific people
Set-SPOTenant -DefaultSharingLinkType Direct

# Or people in the organisation
Set-SPOTenant -DefaultSharingLinkType Internal
```

## Default value

Only people in your organisation (`Internal`)

## References

- https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant
