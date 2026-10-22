# Ensure Safe Attachments policy is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.4  
**Profile:** E5 Level 2  
**Script:** [`Ensure Safe Attachments policy is enabled (Automated).ps1`](./Ensure%20Safe%20Attachments%20policy%20is%20enabled%20(Automated).ps1)

## Why this is required

Signature-based antivirus only catches malware that is already known. Safe Attachments, part of Microsoft Defender for Office 365, opens each email attachment in an isolated cloud sandbox (**detonation**) and watches what it does before deciding whether it's safe. This catches **new and zero-day** malware that signatures miss.

With the action set to **Block** and quarantine restricted to admins, malicious attachments never reach the inbox, and users can't release them themselves.

## What the script does

1. Lists every Safe Attachments policy with its `Enable`, `Action` and `QuarantineTag` values.
2. Lists the Safe Attachments rules with their priority, so you can tell which policy is the highest priority.

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
& ".\Ensure Safe Attachments policy is enabled (Automated).ps1"
```

## Interpreting the results

The **highest-priority** Safe Attachments policy must have:

| Property | Required value |
| --- | --- |
| `Enable` | `True` |
| `Action` | `Block` |
| `QuarantineTag` | `AdminOnlyAccessPolicy` |

The policy must also be scoped to the organisation's users or domains (check the rule's recipients). Strict and Standard preset policies always take priority over custom ones and can be seen with `Get-ATPProtectionPolicyRule`. The *Built-In Protection Policy* always has the lowest priority.

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Safe Attachments > + Create**. Select all valid domains, set the response to **Block**, set the quarantine policy to **AdminOnlyAccessPolicy**, and leave redirect unticked.

**PowerShell:**
```powershell
# Change an existing policy
Set-SafeAttachmentPolicy -Identity 'Example policy' -Action 'Block' -QuarantineTag 'AdminOnlyAccessPolicy' -Enable $true

# Or create a new one
New-SafeAttachmentPolicy -Name "CIS 2.1.4" -Enable $true -Action 'Block' -QuarantineTag 'AdminOnlyAccessPolicy'
New-SafeAttachmentRule -Name "CIS 2.1.4 Rule" -SafeAttachmentPolicy "CIS 2.1.4" -RecipientDomainIs 'yourdomain.com'
```

## Default value

The *Built-In Protection Policy* is enabled with `Block` and `AdminOnlyAccessPolicy`, at the lowest priority.

## Notes and limitations

- Requires Microsoft Defender for Office 365, which is included in E5.
- Delivery of mail with attachments may be slightly delayed while scanning takes place.

## References

- https://learn.microsoft.com/en-us/defender-office-365/safe-attachments-about
- https://learn.microsoft.com/en-us/defender-office-365/safe-attachments-policies-configure
