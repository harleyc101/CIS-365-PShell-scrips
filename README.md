# Ensure 'User owned apps and services' is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.4  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure 'User owned apps and services' is restricted (Automated).ps1`](./Ensure%20%27User%20owned%20apps%20and%20services%27%20is%20restricted%20(Automated).ps1)

## Why this is required

By default, users can install add-ins from the Office Store into Word, Excel and PowerPoint, and start trials of apps on behalf of the organisation. Add-ins can read and change the content of the documents they run in, so a malicious or vulnerable add-in is a direct path to company data. Attackers do build and promote add-ins for this.

Blocking the Office Store and self-service trials means add-ins and apps go through IT, which shrinks the attack surface and keeps data access under the organisation's control.

## What the script does

1. Calls the Microsoft Graph **beta** endpoint `admin/appsAndServices/settings` with `Invoke-MgGraphRequest`.
2. Returns the tenant's `isOfficeStoreEnabled` and `isAppAndServicesTrialEnabled` values.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "OrgSettings-AppsAndServices.Read.All"
  ```

## Usage

```powershell
& ".\Ensure 'User owned apps and services' is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Both `isOfficeStoreEnabled` and `isAppAndServicesTrialEnabled` are `False` | **Pass.** |
| Either value is `True` | **Fail.** |

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Settings > Org settings > Services > User owned apps and services**. Untick **Let users access the Office Store** and **Let users start trials on behalf of your organization**, then save.

**PowerShell** (needs `Connect-MgGraph -Scopes "OrgSettings-AppsAndServices.ReadWrite.All"`):
```powershell
$uri = "https://graph.microsoft.com/beta/admin/appsAndServices"
$body = @{
    "Settings" = @{
        "isAppAndServicesTrialEnabled" = $false
        "isOfficeStoreEnabled"         = $false
    }
} | ConvertTo-Json
Invoke-MgGraphRequest -Method PATCH -Uri $uri -Body $body
```

## Default value

Both **Let users access the Office Store** and **Let users start trials on behalf of your organization** are ticked.

## Notes and limitations

- This uses a Graph **beta** endpoint, which Microsoft may change.

## References

- https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-addins-in-the-admin-center#manage-add-in-downloads-by-turning-onoff-the-office-store-across-all-apps-except-outlook
