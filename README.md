# Ensure outbound anti-spam message limits are in place (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.15  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure outbound anti-spam message limits are in place (Automated).ps1`](./Ensure%20outbound%20anti-spam%20message%20limits%20are%20in%20place%20(Automated).ps1)

## Why this is required

When an account is compromised, attackers often use it straight away to send phishing or spam to large numbers of people, both inside the organisation and outside it. Outbound message limits **automatically restrict an account that suddenly sends unusually large volumes**. That:

- contains the damage from business email compromise,
- stops one compromised account running a large campaign, and
- protects the organisation's sending reputation, so Microsoft and other providers don't block **all** of its email.

Notifying a monitored mailbox when a user is blocked means the security team can investigate promptly.

## What the script does

1. Reads the **Default** outbound spam filter policy.
2. Shows the external, internal and daily recipient limits, the action when a limit is reached, and who is notified.

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
& ".\Ensure outbound anti-spam message limits are in place (Automated).ps1"
```

## Interpreting the results

| Property | Required value |
| --- | --- |
| `RecipientLimitExternalPerHour` | `500` or less, but **not** `0` |
| `RecipientLimitInternalPerHour` | `1000` or less, but **not** `0` |
| `RecipientLimitPerDay` | `1000` or less, but **not** `0` |
| `ActionWhenThresholdReached` | `BlockUser` |
| `NotifyOutboundSpamRecipients` | Contains a monitored mailbox |

A value of `0` means "use the service default", which is much higher, so it **fails**. Microsoft's *Strict* recommended values (400 / 800 / 800) are stricter and also pass.

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-spam > Anti-spam outbound policy (Default) > Edit protection settings**. Set the limits and action as above and add a monitored notification recipient.

**PowerShell** (change the example addresses):
```powershell
$params = @{
    RecipientLimitExternalPerHour = 500
    RecipientLimitInternalPerHour = 1000
    RecipientLimitPerDay          = 1000
    ActionWhenThresholdReached    = 'BlockUser'
    NotifyOutboundSpamRecipients  = @('admin@example.com', 'security@example.com')
}
Set-HostedOutboundSpamFilterPolicy -Identity 'Default' @params
```

## Default value

All three limits `0` (service defaults), with `ActionWhenThresholdReached` = `BlockUserForToday`.

## Notes and limitations

- Legitimate bulk senders may hit the limits. Microsoft recommends sending bulk mail through a custom subdomain or a third-party bulk email provider.

## References

- https://learn.microsoft.com/en-us/defender-office-365/outbound-spam-protection-about
- https://learn.microsoft.com/en-us/defender-office-365/recommended-settings-for-eop-and-office365#outbound-spam-policy-settings
- https://learn.microsoft.com/en-us/office365/servicedescriptions/exchange-online-service-description/exchange-online-limits#sending-limits-1
