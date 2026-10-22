# Ensure users can't send emails to a channel email address (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.1.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure users can't send emails to a channel email address (Automated).ps1`](./Ensure%20users%20can%27t%20send%20emails%20to%20a%20channel%20email%20address%20(Automated).ps1)

## Why this is required

Every Teams channel can have its own email address so that messages sent to it appear in the channel conversation. These addresses use a Microsoft domain (`*.teams.ms`), **not your tenant's domain**, so your normal mail flow security settings don't apply to them in the same way.

If an attacker finds a channel's address, for example from a forwarded email or a leaked document, they can post content, phishing links or malicious attachments straight into internal channels, where people trust what they see.

## What the script does

1. Reads the Global Teams client configuration and shows `AllowEmailIntoChannel`.

## Prerequisites

- The [Microsoft Teams PowerShell module](https://learn.microsoft.com/microsoftteams/teams-powershell-install):
  ```powershell
  Install-Module MicrosoftTeams -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MicrosoftTeams
  ```

## Usage

```powershell
& ".\Ensure users can't send emails to a channel email address (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowEmailIntoChannel` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the Teams admin center, go to **Settings & policies > Global (Org-wide default) settings > Teams**. Under *Email integration*, turn **Users can send emails to a channel email address** off.

**PowerShell:**
```powershell
Set-CsTeamsClientConfiguration -Identity Global -AllowEmailIntoChannel $false
```
Check first whether any workflows, such as alerts from external systems, rely on email-to-channel.

## Default value

On (`True`)

## References

- https://learn.microsoft.com/en-us/defender-office-365/step-by-step-guides/reducing-attack-surface-in-microsoft-teams#restricting-channel-email-messages-to-approved-domains
- https://learn.microsoft.com/en-us/microsoftteams/settings-policies-reference#email-integration
