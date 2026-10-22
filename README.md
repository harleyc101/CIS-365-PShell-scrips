# Ensure Priority accounts have 'Strict protection' presets applied (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.4.2  
**Profile:** E5 Level 1  
**Script:** [`Ensure Priority accounts have 'Strict protection' presets applied (Automated).ps1`](./Ensure%20Priority%20accounts%20have%20%27Strict%20protection%27%20presets%20applied%20(Automated).ps1)

## Why this is required

Microsoft's **preset security policies** (Standard and Strict) bundle its recommended settings for anti-spam, anti-malware, anti-phishing, spoof and impersonation protection, Safe Links and Safe Attachments. **Strict** is the most aggressive.

Priority accounts (executives, finance, IT admins) are the people most likely to be targeted by spear phishing and whaling, so they should get the strongest protection. Strict filtering may send more legitimate mail to junk, but for these users that is a better trade-off than a malicious message reaching the inbox.

## What the script does

1. Gets the Defender for Office 365 rule for the **Strict Preset Security Policy** with `Get-ATPProtectionPolicyRule`.
2. Gets the Exchange Online Protection rule for the **Strict Preset Security Policy** with `Get-EOPProtectionPolicyRule`.
3. Shows each rule's state and recipient targets (`SentTo`, `SentToMemberOf`, `RecipientDomainIs`).

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
& ".\Ensure Priority accounts have 'Strict protection' presets applied (Automated).ps1"
```

## Interpreting the results

**Both** the ATP rule and the EOP rule must exist and have:

- `State` = `Enabled`
- at least one recipient target, so that `SentTo`, `SentToMemberOf` or `RecipientDomainIs` is not empty and includes the priority accounts or groups.

If either rule is missing, disabled, or has no targets, the control **fails**.

## Remediation

In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Preset security policies** and choose **Manage protection settings** under **Strict protection**:

1. **Apply Exchange Online Protection:** choose **Specific recipients** and add the priority accounts or groups.
2. **Apply Defender for Office 365 protection:** choose **Specific recipients** and add the same accounts or groups.
3. **Impersonation protection:** add internal and external addresses that may be impersonated.
4. **Protected custom domains:** add the organisation's domains and key partners.
5. Choose **Next** and **Confirm**.

## Default value

Presets are not applied to any users or groups.

## Notes and limitations

- Preset policies can't target user **tags**, so use groups instead.
- Requires Microsoft Defender for Office 365, which is included in E5.

## References

- https://learn.microsoft.com/en-us/defender-office-365/preset-security-policies
- https://learn.microsoft.com/en-us/defender-office-365/priority-accounts-security-recommendations
