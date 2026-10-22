# Ensure modern authentication for SharePoint applications is required (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure modern authentication for SharePoint applications is required (Automated).ps1`](./Ensure%20modern%20authentication%20for%20SharePoint%20applications%20is%20required%20(Automated).ps1)

## Why this is required

Apps that use **legacy (basic) authentication** to connect to SharePoint Online send a username and password directly. That bypasses **MFA and Conditional Access**, so an attacker with a stolen or sprayed password can get into SharePoint and OneDrive data through these protocols even when MFA is enforced everywhere else.

Blocking apps that don't use modern authentication makes every connection to SharePoint go through OAuth, so strong authentication policies apply.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `LegacyAuthProtocolsEnabled`.

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
& ".\Ensure modern authentication for SharePoint applications is required (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `LegacyAuthProtocolsEnabled` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [SharePoint admin center](https://admin.microsoft.com/sharepoint), go to **Policies > Access control > Apps that don't use modern authentication**, select **Block access**, and save.

**PowerShell:**
```powershell
Set-SPOTenant -LegacyAuthProtocolsEnabled $false
```

## Default value

`True`: apps that don't use modern authentication are allowed.

## Notes and limitations

- This may stop some older third-party apps from working, including anything using the `SharePointOnlineCredentials` class.

## References

- https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant
