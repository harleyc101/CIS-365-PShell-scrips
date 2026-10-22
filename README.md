# Ensure that an anti-phishing policy has been created (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.7  
**Profile:** E5 Level 2  
**Script:** [`Ensure that an anti-phishing policy has been created (Automated).ps1`](./Ensure%20that%20an%20anti-phishing%20policy%20has%20been%20created%20(Automated).ps1)

## Why this is required

Phishing and impersonation are the most common starting points for business email compromise. Attackers pretend to be the CEO, finance, a supplier, or your own domain with a look-alike name. The default anti-phishing policy gives basic protection. A tuned Defender for Office 365 policy adds:

- **User impersonation protection** for named high-value people (up to 350), for example executives and finance staff.
- **Domain impersonation protection** for your own domains, catching look-alikes such as `c0ntoso.com`.
- **Mailbox intelligence**, which learns who each user normally emails and flags unusual senders.
- **A more aggressive phishing threshold** and **safety tips** that warn users about first-time senders, similar names and unusual characters.
- **Quarantining** impersonation attempts, and respecting the sender's DMARC policy for spoofed mail.

## What the script does

1. Gets every anti-phishing policy and shows the settings the benchmark checks.
2. Gets every anti-phishing rule and shows which policy it links to, its priority, its state, and the groups or domains it targets.

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
& ".\Ensure that an anti-phishing policy has been created (Automated).ps1"
```

## Interpreting the results

At least one **enabled** policy must match all of the following:

| Property | Required value |
| --- | --- |
| `Enabled` | `True` |
| `PhishThresholdLevel` | `3` or higher |
| `EnableTargetedUserProtection` | `True` |
| `EnableOrganizationDomainsProtection` | `True` |
| `EnableMailboxIntelligence` | `True` |
| `EnableMailboxIntelligenceProtection` | `True` |
| `EnableSpoofIntelligence` | `True` |
| `TargetedUserProtectionAction` | `Quarantine` |
| `TargetedDomainProtectionAction` | `Quarantine` |
| `MailboxIntelligenceProtectionAction` | `Quarantine` |
| `EnableFirstContactSafetyTips` | `True` |
| `EnableSimilarUsersSafetyTips` | `True` |
| `EnableSimilarDomainsSafetyTips` | `True` |
| `EnableUnusualCharactersSafetyTips` | `True` |
| `TargetedUsersToProtect` | Contains a subset of users (up to 350) |
| `HonorDmarcPolicy` | `True` |

The **rule** for that policy must also have `State` = `Enabled` and target groups (`SentToMemberOf`) or domains (`RecipientDomainIs`) that cover most of the organisation.

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-phishing > Create**, and configure the settings above.

**PowerShell:**
```powershell
# Create the Policy
$params = @{
    Name                                = "CIS AntiPhish Policy"
    PhishThresholdLevel                 = 3
    EnableTargetedUserProtection        = $true
    EnableOrganizationDomainsProtection = $true
    EnableMailboxIntelligence           = $true
    EnableMailboxIntelligenceProtection = $true
    EnableSpoofIntelligence             = $true
    TargetedUserProtectionAction        = 'Quarantine'
    TargetedDomainProtectionAction      = 'Quarantine'
    MailboxIntelligenceProtectionAction = 'Quarantine'
    TargetedUserQuarantineTag           = 'DefaultFullAccessWithNotificationPolicy'
    MailboxIntelligenceQuarantineTag    = 'DefaultFullAccessWithNotificationPolicy'
    TargetedDomainQuarantineTag         = 'DefaultFullAccessWithNotificationPolicy'
    EnableFirstContactSafetyTips        = $true
    EnableSimilarUsersSafetyTips        = $true
    EnableSimilarDomainsSafetyTips      = $true
    EnableUnusualCharactersSafetyTips   = $true
    HonorDmarcPolicy                    = $true
}
New-AntiPhishPolicy @params

# Create the rule for all users in all valid domains and associate with Policy
New-AntiPhishRule -Name $params.Name -AntiPhishPolicy $params.Name -RecipientDomainIs (Get-AcceptedDomain).Name -Priority 0
```
Then add the users to protect (`-TargetedUsersToProtect`) in the UI or with `Set-AntiPhishPolicy`.

## Notes and limitations

- Requires Microsoft Defender for Office 365, which is included in E5.
- Exclude system mailboxes such as helpdesk or billing systems that send lots of internal mail from impersonation protection, to avoid false positives.
- The `DefaultFullAccessWithNotificationPolicy` quarantine tag is suggested but not required.

## References

- https://learn.microsoft.com/en-us/defender-office-365/anti-phishing-protection-about
- https://learn.microsoft.com/en-us/defender-office-365/anti-phishing-policies-eop-configure
