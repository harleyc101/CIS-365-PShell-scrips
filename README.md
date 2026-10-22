# Ensure Zero-hour auto purge for Microsoft Teams is on (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.4.4  
**Profile:** E5 Level 1  
**Script:** [`Ensure Zero-hour auto purge for Microsoft Teams is on (Automated).ps1`](./Ensure%20Zero-hour%20auto%20purge%20for%20Microsoft%20Teams%20is%20on%20(Automated).ps1)

## Why this is required

A message can look clean when it's delivered and only be recognised as malicious later, once new signatures or threat intelligence arrive or a link is turned into a weapon after delivery. **Zero-hour auto purge (ZAP)** keeps re-checking delivered content and removes it retrospectively.

ZAP for Teams does this for Teams chats and channels. If a message is later found to contain malware or high-confidence phishing, it is blocked for **everyone** in the chat, up to 48 hours after delivery.

## What the script does

1. Shows `ZapEnabled` from the Teams protection policy.
2. Shows any exclusions (`ExceptIf*` properties) from the Teams protection policy rule.

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
& ".\Ensure Zero-hour auto purge for Microsoft Teams is on (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `ZapEnabled` is `True` and any exclusions are justified | **Pass.** |
| `ZapEnabled` is `False` | **Fail.** |
| Exclusions are listed that aren't justified | **Fail.** Review and remove them. |

## Remediation

**UI:** In Microsoft Defender, go to **System > Settings > Email & collaboration > Microsoft Teams protection** and set **Zero-hour auto purge (ZAP)** to **On (Default)**.

**PowerShell:**
```powershell
Set-TeamsProtectionPolicy -Identity "Teams Protection Policy" -ZapEnabled $true
```

## Default value

On (Default)

## Notes and limitations

- Requires Microsoft Defender for Office 365 Plan 2.

## References

- https://learn.microsoft.com/en-us/defender-office-365/zero-hour-auto-purge#zero-hour-auto-purge-zap-in-microsoft-teams
- https://learn.microsoft.com/en-us/defender-office-365/mdo-support-teams-about#configure-zap-for-teams-protection-in-defender-for-office-365-plan-2
