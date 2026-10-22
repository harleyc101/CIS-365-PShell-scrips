# Ensure Office 365 SharePoint infected files are disallowed for download (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.3.1  
**Profile:** E5 Level 2  
**Script:** [`Ensure Office 365 SharePoint infected files are disallowed for download (Automated).ps1`](./Ensure%20Office%20365%20SharePoint%20infected%20files%20are%20disallowed%20for%20download%20(Automated).ps1)

## Why this is required

Defender for Office 365 scans files in SharePoint, OneDrive and Teams, and blocks opening, copying, moving and sharing of anything it finds to be malicious. However, **by default users can still download** an infected file. Once it's downloaded to an endpoint, it's outside Defender for Office 365's protection and can be run.

Turning on `DisallowInfectedFileDownload` closes that gap, so detected malware can't be downloaded either.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `DisallowInfectedFileDownload`.

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
& ".\Ensure Office 365 SharePoint infected files are disallowed for download (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `DisallowInfectedFileDownload` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

```powershell
Set-SPOTenant -DisallowInfectedFileDownload $true
```

## Default value

`False`

## Notes and limitations

- Requires Defender for Office 365 (E5) with Safe Attachments for SharePoint, OneDrive and Teams turned on (control 2.1.5).
- The only expected impact is the occasional false positive that blocks a legitimate file.

## References

- https://learn.microsoft.com/en-us/defender-office-365/safe-attachments-for-spo-odfb-teams-configure
- https://learn.microsoft.com/en-us/defender-office-365/anti-malware-protection-for-spo-odfb-teams-about
