# Ensure that SharePoint guest users cannot share items they don't own (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.5  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure that SharePoint guest users cannot share items they don't own (Automated).ps1`](./Ensure%20that%20SharePoint%20guest%20users%20cannot%20share%20items%20they%20don%27t%20own%20(Automated).ps1)

## Why this is required

When content is shared with a guest, the internal owner has decided that **this person** should see it. If guests can re-share items they don't own, they can pass your content on to more outsiders, people the owner never approved and may not know about.

Stopping guests from re-sharing keeps owners in control of who outside the organisation sees their content, and prevents disclosure spreading further.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `PreventExternalUsersFromResharing`.

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
& ".\Ensure that SharePoint guest users cannot share items they don't own (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `PreventExternalUsersFromResharing` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing > More external sharing settings**, untick **Allow guests to share items they don't own**, and save.

**PowerShell:**
```powershell
Set-SPOTenant -PreventExternalUsersFromResharing $True
```

## Default value

Allowed (`PreventExternalUsersFromResharing` is `False`).

## References

- https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off
- https://learn.microsoft.com/en-us/sharepoint/external-sharing-overview
