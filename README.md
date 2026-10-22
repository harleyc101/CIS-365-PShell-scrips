# Ensure guest access to a site or OneDrive will expire automatically (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.9  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure guest access to a site or OneDrive will expire automatically (Automated).ps1`](./Ensure%20guest%20access%20to%20a%20site%20or%20OneDrive%20will%20expire%20automatically%20(Automated).ps1)

## Why this is required

Guest access tends to build up. A contractor or partner is given access for a project and then keeps it indefinitely after the work ends. Every forgotten guest is a standing route into your data if their account, or their organisation, is compromised.

Making guest access to sites and OneDrive **expire automatically after 30 days** means access has to be actively renewed by a site owner, so it lasts only as long as it's needed.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `ExternalUserExpirationRequired` and `ExternalUserExpireInDays`.

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
& ".\Ensure guest access to a site or OneDrive will expire automatically (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `ExternalUserExpirationRequired` is `True` **and** `ExternalUserExpireInDays` is `30` | **Pass.** |
| Expiration not required, or a different number of days | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing > More external sharing settings** and set **Guest access to a site or OneDrive will expire automatically after this many days** to **30**.

**PowerShell:**
```powershell
Set-SPOTenant -ExternalUserExpireInDays 30 -ExternalUserExpirationRequired $True
```
Site collection admins get a weekly email about guest access that is about to expire and can renew it.

## Default value

`ExternalUserExpirationRequired`: `False`, `ExternalUserExpireInDays`: `60`

## Notes and limitations

- Expiration applies only to guests who are given access **after** the policy is turned on. Existing guest access isn't affected.
- Guest membership works at Microsoft 365 group level, so guests may also have access to the related Teams team.

## References

- https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off#change-the-organization-level-external-sharing-setting
