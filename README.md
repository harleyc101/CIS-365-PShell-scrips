# Ensure email from external senders is identified (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.2.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure email from external senders is identified (Automated).ps1`](./Ensure%20email%20from%20external%20senders%20is%20identified%20(Automated).ps1)

## Why this is required

Many phishing and business email compromise attacks rely on the recipient assuming a message comes from a colleague. Outlook's native **External** tag clearly marks mail from outside the organisation and shows the sender's real address at the top of the message. That prompts users to be more careful with unexpected requests, links and attachments.

The native tag works across Outlook clients and is better than the old approach of adding "[EXTERNAL]" to subject lines with mail flow rules, which clutters subjects, breaks threading and is easily ignored.

## What the script does

1. Shows the tenant's **External in Outlook** settings, including `Enabled` and `AllowList`.

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
& ".\Ensure email from external senders is identified (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `Enabled` is `True` and `AllowList` contains only addresses the organisation has approved to skip tagging | **Pass.** |
| `Enabled` is `False` | **Fail.** |

## Remediation

```powershell
Set-ExternalInOutlook -Enabled $true
```
It can take 24–48 hours for the tag to appear. Turn off any mail flow rules or third-party tools that add their own [External] tags, to avoid duplicates.

## Default value

Disabled (`False`)

## Notes and limitations

- Messages already in mailboxes aren't tagged retrospectively.
- Third-party tools that do the same job also meet the requirement, but Microsoft recommends the native experience.

## References

- https://techcommunity.microsoft.com/t5/exchange-team-blog/native-external-sender-callouts-on-email-in-outlook/ba-p/2250098
- https://learn.microsoft.com/en-us/powershell/module/exchange/set-externalinoutlook
