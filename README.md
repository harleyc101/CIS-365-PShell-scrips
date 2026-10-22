# Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.5  
**Profile:** E5 Level 2  
**Script:** [`Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled (Automated).ps1`](./Ensure%20Safe%20Attachments%20for%20SharePoint,%20OneDrive,%20and%20Microsoft%20Teams%20is%20Enabled%20(Automated).ps1)

## Why this is required

Malware doesn't only arrive by email. Files uploaded to SharePoint, OneDrive or Teams can be shared with many people at once. This setting extends Defender scanning to those files:

- **Defender for SharePoint, OneDrive and Teams** scans shared files. If one is malicious, it's locked so that nobody can open, copy, move or share it.
- **Safe Documents** scans files opened in Protected View in the Office desktop apps.
- Turning off **click-through** stops users opening a file that Safe Documents has flagged as malicious.

## What the script does

1. Reads the tenant-wide Defender for Office 365 global settings with `Get-AtpPolicyForO365`.
2. Shows `EnableATPForSPOTeamsODB`, `EnableSafeDocs` and `AllowSafeDocsOpen`.

## Prerequisites

- The [Exchange Online PowerShell module](https://learn.microsoft.com/powershell/exchange/exchange-online-powershell-v2):
  ```powershell
  Install-Module ExchangeOnlineManagement -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-ExchangeOnline
  ```

## Usage

```powershell
& ".\Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableATPForSPOTeamsODB` = `True`, `EnableSafeDocs` = `True`, `AllowSafeDocsOpen` = `False` | **Pass.** |
| Any value differs | **Fail.** |

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Safe Attachments > Global settings**. Turn on Defender for SharePoint, OneDrive and Teams, turn on Safe Documents, and turn **off** *Allow people to click through Protected View*.

**PowerShell:**
```powershell
Set-AtpPolicyForO365 -EnableATPForSPOTeamsODB $true -EnableSafeDocs $true -AllowSafeDocsOpen $false
```

## Notes and limitations

- Requires Microsoft Defender for Office 365 Plan 1 or 2. Safe Documents needs E5 / Microsoft 365 E5 Security.

## References

- https://learn.microsoft.com/en-us/defender-office-365/safe-attachments-for-spo-odfb-teams-about
