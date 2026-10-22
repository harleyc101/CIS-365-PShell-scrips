# Ensure the connection filter safe list is off (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.13  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the connection filter safe list is off (Automated).ps1`](./Ensure%20the%20connection%20filter%20safe%20list%20is%20off%20(Automated).ps1)

## Why this is required

The connection filter **safe list** is an IP allow list that Microsoft maintains and updates itself. Mail from servers on it skips spam filtering. Administrators **can't see** which senders are on the list, so turning it on means trusting an unknown, changing set of mail servers to bypass your filtering.

Leaving it off means every message is filtered regardless of where it comes from.

## What the script does

1. Reads the **Default** connection filter policy and shows `EnableSafeList`.

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
& ".\Ensure the connection filter safe list is off (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableSafeList` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-spam > Connection filter policy (Default) > Edit connection filter policy**, untick **Turn on safe list**, and save.

**PowerShell:**
```powershell
Set-HostedConnectionFilterPolicy -Identity Default -EnableSafeList $false
```

## Default value

`EnableSafeList`: `False`

## References

- https://learn.microsoft.com/en-us/defender-office-365/connection-filter-policies-configure
