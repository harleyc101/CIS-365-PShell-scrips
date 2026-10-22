# Ensure users can report security concerns in Teams (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.6.1  
**Profile:** E5 Level 1  
**Script:** [`Ensure users can report security concerns in Teams (Automated).ps1`](./Ensure%20users%20can%20report%20security%20concerns%20in%20Teams%20(Automated).ps1)

## Why this is required

Users are often the first to notice a suspicious Teams message, such as an odd link, an unexpected file, or someone impersonating IT. Letting them **report it with one click** gets it to the security team quickly so they can investigate and act, for example by blocking the sender or removing the message for everyone.

Sending reports to the organisation's **own reporting mailbox**, rather than only to Microsoft, keeps potentially sensitive message content inside the organisation and under its control.

## What the script does

1. Reads the **Global** Teams messaging policy and shows `AllowSecurityEndUserReporting`.
2. Reads the Defender report submission policy and shows all `Report*` settings, which control where reported junk, phishing and Teams messages go.

## Prerequisites

- The [Microsoft Teams PowerShell module](https://learn.microsoft.com/microsoftteams/teams-powershell-install):
  ```powershell
  Install-Module MicrosoftTeams -Scope CurrentUser
  ```
- The [Exchange Online PowerShell module](https://learn.microsoft.com/powershell/exchange/exchange-online-powershell-v2):
  ```powershell
  Install-Module ExchangeOnlineManagement -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MicrosoftTeams
  Connect-ExchangeOnline
  ```

## Usage

```powershell
& ".\Ensure users can report security concerns in Teams (Automated).ps1"
```

## Interpreting the results

**All** of these must be true:

| Property | Required value |
| --- | --- |
| `AllowSecurityEndUserReporting` (Teams) | `True` |
| `ReportJunkToCustomizedAddress` | `True` |
| `ReportNotJunkToCustomizedAddress` | `True` |
| `ReportPhishToCustomizedAddress` | `True` |
| `ReportJunkAddresses` | The organisation's reporting mailbox, for example `SOC@yourdomain.com` |
| `ReportNotJunkAddresses` | The organisation's reporting mailbox |
| `ReportPhishAddresses` | The organisation's reporting mailbox |
| `ReportChatMessageEnabled` | `False` |
| `ReportChatMessageToCustomizedAddressEnabled` | `True` |

## Remediation

**UI:**
1. In the Teams admin center, go to **Settings & policies > Global (Org-wide default) settings > Messaging** and turn **Report a security concern** on.
2. In [Microsoft Defender](https://security.microsoft.com), go to **System > Settings > Email & collaboration > User reported settings**. Tick **Monitor reported items in Microsoft Teams**, and set **Send reported messages to** to **My reporting mailbox only** with an authorised mailbox.

**PowerShell:**
```powershell
Set-CsTeamsMessagingPolicy -Identity Global -AllowSecurityEndUserReporting $true

$usersub = "userreportedmessages@yourdomain.com" # Change this.
$params = @{
    Identity                                    = "DefaultReportSubmissionPolicy"
    EnableReportToMicrosoft                     = $false
    ReportChatMessageEnabled                    = $false
    ReportChatMessageToCustomizedAddressEnabled = $true
    ReportJunkToCustomizedAddress               = $true
    ReportNotJunkToCustomizedAddress            = $true
    ReportPhishToCustomizedAddress              = $true
    ReportJunkAddresses                         = $usersub
    ReportNotJunkAddresses                      = $usersub
    ReportPhishAddresses                        = $usersub
}
Set-ReportSubmissionPolicy @params
New-ReportSubmissionRule -Name DefaultReportSubmissionRule -ReportSubmissionPolicy DefaultReportSubmissionPolicy -SentTo $usersub
```

## Default value

Teams reporting is on (`True`). Reported messages go to Microsoft only.

## Notes and limitations

- Reports may include harassment or threats from colleagues, not just security issues. Make sure the staff reviewing them know when to escalate to HR.
- The sender isn't told their message was reported, and the message stays visible to the person who reported it.

## References

- https://learn.microsoft.com/en-us/defender-office-365/submissions-teams
