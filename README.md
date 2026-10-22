# Ensure inbound anti-spam policies do not contain allowed domains (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.14  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure inbound anti-spam policies do not contain allowed domains (Automated).ps1`](./Ensure%20inbound%20anti-spam%20policies%20do%20not%20contain%20allowed%20domains%20(Automated).ps1)

## Why this is required

Mail from a domain on an anti-spam policy's **allowed domains** list bypasses most email protection **and** SPF, DKIM and DMARC checks. Only malware and high-confidence phishing are still caught. Because sender domains are easy to spoof, an attacker only has to forge an allowed domain in the From address to get mail straight to the inbox. The risk is worst for common domains such as `gmail.com` or a large partner's domain.

Microsoft's own guidance says allowed domains should be used **for testing only**. If you need to allow mail to fix false positives, specific allowed **senders**, or entries in the Tenant Allow/Block List, are far safer.

## What the script does

1. Gets every inbound anti-spam (content filter) policy with `Get-HostedContentFilterPolicy`.
2. Shows each policy's `AllowedSenderDomains`.

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
& ".\Ensure inbound anti-spam policies do not contain allowed domains (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowedSenderDomains` is empty for **every** inbound policy | **Pass.** |
| Any policy lists one or more allowed domains | **Fail.** |

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-spam**. Open each inbound policy, choose **Edit allowed and blocked senders and domains > Allow domains**, delete every domain, and save.

**PowerShell:**
```powershell
# A single policy
Set-HostedContentFilterPolicy -Identity <Policy name> -AllowedSenderDomains @{}

# All inbound policies that have allowed domains
$AllowedDomains = Get-HostedContentFilterPolicy | Where-Object { $_.AllowedSenderDomains }
$AllowedDomains | Set-HostedContentFilterPolicy -AllowedSenderDomains @{}
```

## Default value

`AllowedSenderDomains`: `{}`

## References

- https://learn.microsoft.com/en-us/defender-office-365/anti-spam-protection-about#allow-and-block-lists-in-anti-spam-policies
