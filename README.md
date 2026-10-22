# Ensure the connection filter IP allow list is not used (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.12  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the connection filter IP allow list is not used (Automated).ps1`](./Ensure%20the%20connection%20filter%20IP%20allow%20list%20is%20not%20used%20(Automated).ps1)

## Why this is required

Mail from an IP address on the connection filter's **IP Allow List** skips spam filtering **and** sender authentication checks (SPF, DKIM and DMARC). Only malware and high-confidence phishing are still caught.

If an allowed IP is ever compromised, shared with other customers (as many cloud mail services are), or reassigned, attackers can send mail straight to users' inboxes that would otherwise be filtered. Following zero-trust principles, every message should be scanned whatever its source.

## What the script does

1. Reads the **Default** connection filter policy and shows its `IPAllowList`.

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
& ".\Ensure the connection filter IP allow list is not used (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `IPAllowList` is empty (`{}`) | **Pass.** |
| `IPAllowList` contains any IP addresses or ranges | **Fail.** |

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-spam > Connection filter policy (Default) > Edit connection filter policy**, remove every entry under *Always allow messages from the following IP addresses or address range*, and save.

**PowerShell:**
```powershell
Set-HostedConnectionFilterPolicy -Identity Default -IPAllowList @{}
```
If you need to stop false positives from a trusted partner, use sender-based allow entries in the Tenant Allow/Block List instead, which still apply authentication checks.

## Default value

`IPAllowList`: `{}`

## References

- https://learn.microsoft.com/en-us/defender-office-365/connection-filter-policies-configure
- https://learn.microsoft.com/en-us/defender-office-365/create-safe-sender-lists-in-office-365#use-the-ip-allow-list
