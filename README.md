# Ensure MailTips are enabled for end users (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.5.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure MailTips are enabled for end users (Automated).ps1`](./Ensure%20MailTips%20are%20enabled%20for%20end%20users%20(Automated).ps1)

## Why this is required

MailTips are prompts Outlook shows **while a user is writing an email**, before they send it. For example: *"This message will go to recipients outside your organization"*, *"You're about to email 500 people"*, or *"This recipient is out of office"*.

They are a simple, low-friction way to prevent accidental data leaks, such as replying to an external address or mailing a large distribution list, and to make users notice when a conversation involves outsiders.

## What the script does

1. Reads the Exchange Online organisation configuration and shows all `MailTips*` settings.

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
& ".\Ensure MailTips are enabled for end users (Automated).ps1"
```

## Interpreting the results

| Property | Required value |
| --- | --- |
| `MailTipsAllTipsEnabled` | `True` |
| `MailTipsExternalRecipientsTipsEnabled` | `True` |
| `MailTipsGroupMetricsEnabled` | `True` |
| `MailTipsLargeAudienceThreshold` | An acceptable value (default `25`) |

If any of the first three is `False`, the control **fails**.

## Remediation

```powershell
$TipsParams = @{
    MailTipsAllTipsEnabled                = $true
    MailTipsExternalRecipientsTipsEnabled = $true
    MailTipsGroupMetricsEnabled           = $true
    MailTipsLargeAudienceThreshold        = '25'
}
Set-OrganizationConfig @TipsParams
```

## Default value

`MailTipsAllTipsEnabled`: `True`, `MailTipsExternalRecipientsTipsEnabled`: **`False`**, `MailTipsGroupMetricsEnabled`: `True`, `MailTipsLargeAudienceThreshold`: `25`

## References

- https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/mailtips/mailtips
- https://learn.microsoft.com/en-us/powershell/module/exchange/set-organizationconfig
