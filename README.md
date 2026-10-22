# Ensure external file sharing in Teams is enabled for only approved cloud storage services (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.1.1  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure external file sharing in Teams is enabled for only approved cloud storage services (Automated).ps1`](./Ensure%20external%20file%20sharing%20in%20Teams%20is%20enabled%20for%20only%20approved%20cloud%20storage%20services%20(Automated).ps1)

## Why this is required

By default, Teams lets users add **Dropbox, Box, Google Drive, Citrix ShareFile and Egnyte** as file storage in channels, next to SharePoint. Files stored there sit outside the organisation's control: no DLP, retention, sensitivity labels, eDiscovery or Defender scanning. The provider's security may not meet your standards either.

Allowing only the storage providers the organisation has approved keeps Teams files in managed, monitored storage and discourages shadow IT.

## What the script does

1. Reads the Global Teams client configuration and shows whether each third-party storage provider is allowed.

## Prerequisites

- The [Microsoft Teams PowerShell module](https://learn.microsoft.com/microsoftteams/teams-powershell-install):
  ```powershell
  Install-Module MicrosoftTeams -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MicrosoftTeams
  ```

## Usage

```powershell
& ".\Ensure external file sharing in Teams is enabled for only approved cloud storage services (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Only providers the organisation has authorised are `True` (normally all are `False`) | **Pass.** |
| Any unapproved provider is `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Teams**. Under *Files*, turn off every storage provider the organisation hasn't authorised.

**PowerShell** (this example turns all of them off):
```powershell
$Params = @{
    Identity         = 'Global'
    AllowGoogleDrive = $false
    AllowShareFile   = $false
    AllowBox         = $false
    AllowDropBox     = $false
    AllowEgnyte      = $false
}
Set-CsTeamsClientConfiguration @Params
```

## Default value

All providers allowed (`True`).

## References

- https://learn.microsoft.com/en-us/microsoftteams/teams-powershell-managing-teams
