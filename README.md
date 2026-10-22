# Ensure Priority account protection is enabled and configured (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.4.1  
**Profile:** E5 Level 1  
**Script:** [`Ensure Priority account protection is enabled and configured (Automated).ps1`](./Ensure%20Priority%20account%20protection%20is%20enabled%20and%20configured%20(Automated).ps1)

## Why this is required

Executives, finance staff, IT admins and others with access to sensitive data or money are targeted far more often, through spear phishing, whaling and impersonation. Microsoft 365's **priority account protection** lets you tag these people and then:

- apply stronger, differentiated threat protection to them,
- have alerts and incidents involving them flagged and prioritised in Defender, and
- create specific alert policies so the security team is told immediately when malware or phishing reaches them.

## What the script does

1. Reads `EnablePriorityAccountProtection` from the Exchange Online tenant settings.
2. Gets the Security & Compliance alert policies whose recipient tags include **Priority account**, and shows the properties the benchmark checks.

## Prerequisites

- The [Exchange Online PowerShell module](https://learn.microsoft.com/powershell/exchange/exchange-online-powershell-v2):
  ```powershell
  Install-Module ExchangeOnlineManagement -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-ExchangeOnline
  Connect-IPPSSession
  ```

## Usage

```powershell
& ".\Ensure Priority account protection is enabled and configured (Automated).ps1"
```

## Interpreting the results

All three must be true:

1. `EnablePriorityAccountProtection` is `True`.
2. At least one alert policy with `ThreatType` = **Phish** passes all the checks below.
3. At least one alert policy with `ThreatType` = **Malware** passes all the checks below.

Each alert policy must have:

| Property | Required value |
| --- | --- |
| `Severity` | `High` |
| `Filter` | Contains `Mail.Direction -eq 'Inbound'` |
| `RecipientTags` | Contains `Priority account` |
| `NotificationEnabled` | `True` |
| `NotifyUser` | A valid email recipient |
| `Disabled` | `False` |

Also check that the **Priority account** user tag (Defender, **Settings > Email & collaboration > User tags**) contains the organisation's actual priority users or groups. The script can't check this.

## Remediation

1. **Enable:** In [Microsoft Defender](https://security.microsoft.com), go to **System > Settings > Email & collaboration > Priority account protection** and turn it **On**.
2. **Tag:** Under **User tags**, edit **PRIORITY ACCOUNT** and add the priority users. Groups are recommended. Add other tags such as Finance or HR if needed.
3. **Alert:** Go to **Email & collaboration > Policies & rules > Alert policy > New alert policy**:
   - Severity **High**, category **Threat management**
   - Activity **Detected malware in an email message**, mail direction **Inbound**
   - Condition **User: recipient tags are** *Priority account*
   - **Every time an activity matches the rule**, with valid recipients, turned on immediately
   - Repeat for the activity **Phishing email detected at time of delivery**.

## Default value

No priority accounts are defined.

## Notes and limitations

- Requires E5 / Microsoft Defender for Office 365 Plan 2.
- The script needs both an Exchange Online session and a Security & Compliance (`Connect-IPPSSession`) session.

## References

- https://learn.microsoft.com/en-us/microsoft-365/admin/setup/priority-accounts
- https://learn.microsoft.com/en-us/defender-office-365/priority-accounts-security-recommendations
