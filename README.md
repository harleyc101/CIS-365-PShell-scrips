# Ensure internal phishing protection for Forms is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.5  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure internal phishing protection for Forms is enabled (Automated).ps1`](./Ensure%20internal%20phishing%20protection%20for%20Forms%20is%20enabled%20(Automated).ps1)

## Why this is required

Microsoft Forms is a trusted, Microsoft-hosted service, which makes it attractive for phishing. An attacker with access to one internal account can create a form that asks colleagues for passwords, bank details or other personal information. Because it's hosted on `forms.office.com`, it looks legitimate and gets past many filters.

Internal phishing protection scans forms for this kind of content. If it finds suspected phishing, the form is blocked, and it can't be shared or collect responses until an admin reviews it.

## What the script does

1. Calls the Microsoft Graph **beta** endpoint `admin/forms/settings`.
2. Returns the `isInOrgFormsPhishingScanEnabled` value.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "OrgSettings-Forms.Read.All"
  ```

## Usage

```powershell
& ".\Ensure internal phishing protection for Forms is enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `isInOrgFormsPhishingScanEnabled` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Settings > Org settings > Services > Microsoft Forms**, tick **Add internal phishing protection** under *Phishing protection*, and save.

**PowerShell** (needs a Graph session with write permission to Forms settings):
```powershell
$uri = 'https://graph.microsoft.com/beta/admin/forms/settings'
$body = @{ "isInOrgFormsPhishingScanEnabled" = $true } | ConvertTo-Json
Invoke-MgGraphRequest -Method PATCH -Uri $uri -Body $body
```

## Default value

Internal phishing protection is enabled.

## Notes and limitations

- This uses a Graph **beta** endpoint, which Microsoft may change.

## References

- https://learn.microsoft.com/en-US/microsoft-forms/administrator-settings-microsoft-forms
- https://learn.microsoft.com/en-US/microsoft-forms/review-unblock-forms-users-detected-blocked-potential-phishing
