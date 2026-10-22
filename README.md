# Ensure SMTP AUTH is disabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.5.4  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure SMTP AUTH is disabled (Automated).ps1`](./Ensure%20SMTP%20AUTH%20is%20disabled%20(Automated).ps1)

## Why this is required

**SMTP AUTH** (authenticated client SMTP submission on port 587) is a legacy protocol, typically used by old devices, scripts and applications to send mail. It's commonly used for basic authentication, which bypasses MFA, and attackers target it in password-spraying and credential-stuffing campaigns.

Almost all modern email clients connect to Exchange Online without it. Turning it off for the whole organisation follows least functionality and backs up any Conditional Access policies that block legacy authentication. Mailboxes that genuinely need it, such as a specific application, can be re-enabled individually.

## What the script does

1. Reads the Exchange Online transport configuration and shows `SmtpClientAuthenticationDisabled`.

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
& ".\Ensure SMTP AUTH is disabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `SmtpClientAuthenticationDisabled` is `True` | **Pass.** SMTP AUTH is off org-wide. |
| `False` | **Fail.** |

## Remediation

**UI:** In the Exchange admin center, go to **Settings > Mail flow** and tick **Turn off SMTP AUTH protocol for your organization**.

**PowerShell:**
```powershell
Set-TransportConfig -SmtpClientAuthenticationDisabled $true
```
For a mailbox that genuinely needs SMTP AUTH: `Set-CASMailbox -Identity <mailbox> -SmtpClientAuthenticationDisabled $false`

## Default value

`SmtpClientAuthenticationDisabled`: `True`

## Notes and limitations

- The per-mailbox setting overrides the organisation setting. Review mailboxes with it enabled using `Get-CASMailbox -ResultSize Unlimited | Where-Object { $_.SmtpClientAuthenticationDisabled -eq $false }`.

## References

- https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/authenticated-client-smtp-submission
