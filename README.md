# Ensure the ability to add personal email accounts and calendars is disabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.3.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the ability to add personal email accounts and calendars is disabled (Automated).ps1`](./Ensure%20the%20ability%20to%20add%20personal%20email%20accounts%20and%20calendars%20is%20disabled%20(Automated).ps1)

## Why this is required

The new Outlook for Windows and Outlook on the web let users add **personal email accounts** (Outlook.com, Gmail, Yahoo) and **personal calendars** next to their work mailbox. Personal accounts aren't covered by any corporate controls: no anti-malware scanning, DLP, Safe Links or audit logging. This creates:

- an easy **exfiltration channel**: drag a sensitive email or attachment into the personal inbox, or forward it there, and
- an **entry point for malware and phishing** that never passes through the tenant's mail filtering.

## What the script does

1. Finds the **default** OWA mailbox policy.
2. Shows `PersonalAccountsEnabled` and `PersonalAccountCalendarsEnabled`.

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
& ".\Ensure the ability to add personal email accounts and calendars is disabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Both are `False` | **Pass.** |
| Either is `True` | **Fail.** |

## Remediation

```powershell
$DefaultPolicy = Get-OwaMailboxPolicy | Where-Object { $_.IsDefault }
Set-OwaMailboxPolicy -Identity $DefaultPolicy.Identity -PersonalAccountsEnabled $false -PersonalAccountCalendarsEnabled $false
```
Changes can take up to 60 minutes to apply. Users who had already added a personal account will see a message asking them to remove it.

## Default value

Both `PersonalAccountsEnabled` and `PersonalAccountCalendarsEnabled` are `True`.

## Notes and limitations

- Applies only to the **new Outlook for Windows** and **Outlook on the web**. It doesn't affect classic Outlook for Windows, Outlook for Mac or Outlook mobile. Use app management policies to cover those.
- Only the **default** OWA policy is required for compliance. Review custom policies separately if needed.

## References

- https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/set-owamailboxpolicy#-personalaccountsenabled
- https://learn.microsoft.com/en-us/microsoft-365-apps/outlook/get-started/supported-account-types#prevent-adding-personal-accounts
