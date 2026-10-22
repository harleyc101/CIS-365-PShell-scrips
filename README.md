# Ensure the SharePoint default sharing link permission is set (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.11  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the SharePoint default sharing link permission is set (Automated).ps1`](./Ensure%20the%20SharePoint%20default%20sharing%20link%20permission%20is%20set%20(Automated).ps1)

## Why this is required

When users share a link, most accept whatever permission is pre-selected. If the default is **Edit**, people who only needed to read a document can change or delete it, and so can anyone they forward the link to.

Making **View** the default means edit rights are only granted when someone deliberately chooses them, which follows least privilege.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `DefaultLinkPermission`.

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
& ".\Ensure the SharePoint default sharing link permission is set (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `DefaultLinkPermission` is `View` | **Pass.** |
| `Edit` | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing > File and folder links** and set **Choose the permission that's selected by default for sharing links** to **View**.

**PowerShell:**
```powershell
Set-SPOTenant -DefaultLinkPermission View
```

## Default value

`DefaultLinkPermission`: `Edit`

## References

- https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off#file-and-folder-links
