# Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.7  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web' (Automated).ps1`](./Ensure%20%27third-party%20storage%20services%27%20are%20restricted%20in%20%27Microsoft%20365%20on%20the%20web%27%20(Automated).ps1)

## Why this is required

Microsoft 365 on the web can let users open and save files in third-party storage such as Dropbox, Box or Google Drive alongside OneDrive and SharePoint. Files stored there sit outside the organisation's control:

- They aren't covered by your DLP, retention, sensitivity labels, eDiscovery or audit logging.
- The provider may not meet the organisation's security and privacy standards.
- It's an easy, unnoticed route for data to leave the organisation.

Turning this off keeps company documents in storage the organisation manages and can monitor.

## What the script does

1. Looks up the service principal for the "Microsoft 365 on the web third-party storage" app (app ID `c1f33bc0-bdb4-4248-ba9b-096807ddb43e`).
2. Prints **FAIL** if the service principal doesn't exist or is enabled, and **PASS** if it exists and is disabled.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Application.Read.All"
  ```

## Usage

```powershell
& ".\Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `Audit Result: ** PASS **` | **Pass.** The service principal exists and `AccountEnabled` is `False`. |
| `Audit Result: ** FAIL **` | **Fail.** It is enabled, or doesn't exist. If it doesn't exist, users can still open third-party storage. |

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Settings > Org settings > Services > Microsoft 365 on the web**, untick **Let users open files stored in third-party storage services in Microsoft 365 on the web**, and save.

**PowerShell** (needs `Connect-MgGraph -Scopes "Application.ReadWrite.All"`):
```powershell
$SP = Get-MgServicePrincipal -Filter "appId eq 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e'"
# If the service principal doesn't exist then create it first.
if (-not $SP) {
    $SP = New-MgServicePrincipal -AppId "c1f33bc0-bdb4-4248-ba9b-096807ddb43e"
}
Update-MgServicePrincipal -ServicePrincipalId $SP.Id -AccountEnabled:$false
```

## Default value

Enabled: users can open files stored in third-party storage services.

## References

- https://learn.microsoft.com/en-us/microsoft-365/admin/setup/set-up-file-storage-and-sharing#enable-or-disable-third-party-storage-services
