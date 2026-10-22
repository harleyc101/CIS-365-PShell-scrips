# Ensure Direct Send submissions are rejected (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.5.5  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure Direct Send submissions are rejected (Automated).ps1`](./Ensure%20Direct%20Send%20submissions%20are%20rejected%20(Automated).ps1)

## Why this is required

**Direct Send** lets devices and applications, such as printers, scanners and line-of-business apps, send mail straight to your Exchange Online mailboxes using **your own domain** as the sender, **with no authentication**. To Exchange it looks like anonymous internet mail that happens to use your domain.

Attackers abuse this. Threat research, for example from Varonis, has shown active campaigns using Direct Send to **impersonate internal users** and deliver phishing without compromising any credentials. Because the messages appear internal, they often get past filters and user suspicion. Setting `RejectDirectSend` blocks this. Legitimate devices should instead use an authenticated method or a partner connector.

## What the script does

1. Reads the Exchange Online organisation configuration and shows `RejectDirectSend`.

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
& ".\Ensure Direct Send submissions are rejected (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `RejectDirectSend` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

First move any printers, scanners or apps that use Direct Send to SMTP AUTH client submission, an SMTP relay connector, or a partner connector. Then:
```powershell
Set-OrganizationConfig -RejectDirectSend $true
```

## Default value

`RejectDirectSend`: `False`

## Notes and limitations

- A forwarding case can be affected. If a third party forwards one of your users' messages back into your organisation and their provider doesn't support Sender Rewriting Scheme (SRS), the message is rejected unless a partner connector is set up.

## References

- https://techcommunity.microsoft.com/blog/exchange/introducing-more-control-over-direct-send-in-exchange-online/4408790
- https://techcommunity.microsoft.com/blog/exchange/direct-send-vs-sending-directly-to-an-exchange-online-tenant/4439865
- https://www.varonis.com/blog/direct-send-exploit
