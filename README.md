# Ensure mail transport rules do not whitelist specific domains (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.2.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure mail transport rules do not whitelist specific domains (Automated).ps1`](./Ensure%20mail%20transport%20rules%20do%20not%20whitelist%20specific%20domains%20(Automated).ps1)

## Why this is required

A mail flow rule that sets the **spam confidence level (SCL) to -1** for a sender domain marks all mail from that domain as trusted. It then **skips spam and phishing filtering** regardless of content.

Sender domains are trivial to spoof, so an attacker only needs to put a whitelisted domain in the From address to deliver phishing or malware straight to inboxes. A partner's domain, if they are compromised, becomes a "safe haven" for attacking you.

## What the script does

1. Lists every transport rule that sets `SCL` to `-1` **and** has a `SenderDomainIs` condition, with its name and the domains it whitelists.

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
& ".\Ensure mail transport rules do not whitelist specific domains (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| No output | **Pass.** |
| Any rule listed | **Fail.** |

## Remediation

In the Exchange admin center, go to **Mail flow > Rules** and delete each rule that sets SCL to -1 for a sender domain, or run:
```powershell
Remove-TransportRule -Identity "RuleName"
```
If the rule does other legitimate things, edit it to remove the `SenderDomainIs` condition or the `SetSCL -1` action instead of deleting it.

If there's a genuine business need, whitelist the partner only when their mail **comes from specific IP addresses**, document the exception and review it regularly. Talk to the business owners first, because previously whitelisted mail may start going to quarantine.

## Default value

No mail flow rules that set SCL to -1 based on sender domain exist by default.

## References

- https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/configuration-best-practices
- https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/mail-flow-rules
