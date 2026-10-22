# Ensure external content sharing is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure external content sharing is restricted (Automated).ps1`](./Ensure%20external%20content%20sharing%20is%20restricted%20(Automated).ps1)

## Why this is required

The organisation-level SharePoint sharing setting is the ceiling for every site. At the default, **Anyone**, users can create anonymous links that work for whoever holds them. There's no sign-in, no identity, no audit trail of who opened the file, and the link can be forwarded anywhere.

Restricting it to **New and existing guests** or tighter means everyone outside the organisation has to **authenticate** as a known guest identity. That identity can be audited, given Conditional Access and group-based restrictions, and removed when it's no longer needed.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `SharingCapability`.

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
& ".\Ensure external content sharing is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `ExternalUserSharingOnly` (new and existing guests) | **Pass.** |
| `ExistingExternalUserSharingOnly` (existing guests only) | **Pass.** |
| `Disabled` (only people in your organisation) | **Pass.** |
| `ExternalUserAndGuestSharing` (Anyone) | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing** and, under *External sharing*, move the **SharePoint** slider to **New and existing guests** or lower. OneDrive moves down with it automatically.

**PowerShell:**
```powershell
Set-SPOTenant -SharingCapability ExternalUserSharingOnly
```
`ExistingExternalUserSharingOnly` and `Disabled` are stricter and also compliant.

## Default value

Anyone (`ExternalUserAndGuestSharing`)

## References

- https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off
