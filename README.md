# Ensure Exchange Online Spam Policies are set to notify administrators (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.6  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure Exchange Online Spam Policies are set to notify administrators (Automated).ps1`](./Ensure%20Exchange%20Online%20Spam%20Policies%20are%20set%20to%20notify%20administrators%20(Automated).ps1)

## Why this is required

When Microsoft 365 **blocks one of your users from sending email** because they've sent spam, it almost always means the account has been compromised and is being used for a spam or phishing campaign.

Without notification settings, the block happens quietly and nobody investigates. With them, a copy of suspicious outbound messages and a notice of the block go to the security team, so they can secure the account, check what was sent, and warn recipients.

## What the script does

1. Gets every outbound spam filter policy with `Get-HostedOutboundSpamFilterPolicy`.
2. Shows the `Bcc*` properties (copy suspicious outbound mail to recipients) and `Notify*` properties (notify when a sender is blocked).

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
& ".\Ensure Exchange Online Spam Policies are set to notify administrators (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `BccSuspiciousOutboundMail` and `NotifyOutboundSpam` are both `True`, and the recipient addresses are correct and monitored | **Pass.** |
| Either is `False`, or the recipient lists are empty or wrong | **Fail.** |

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-spam > Anti-spam outbound policy (Default) > Edit protection settings**. Under *Notifications*, tick both options and enter the addresses.

**PowerShell:**
```powershell
$BccEmailAddress = @("<INSERT-EMAIL>")
$NotifyEmailAddress = @("<INSERT-EMAIL>")
Set-HostedOutboundSpamFilterPolicy -Identity Default `
    -BccSuspiciousOutboundAdditionalRecipients $BccEmailAddress -BccSuspiciousOutboundMail $true `
    -NotifyOutboundSpam $true -NotifyOutboundSpamRecipients $NotifyEmailAddress
```

## Default value

`BccSuspiciousOutboundMail`: `False`, `NotifyOutboundSpam`: `False`, with both recipient lists empty.

## Notes and limitations

- Microsoft's guidance focuses on the Default policy, but if a custom policy exists, the setting must be correct in the **highest-priority** policy that applies to users.

## References

- https://learn.microsoft.com/en-us/defender-office-365/outbound-spam-protection-about
