# Ensure meeting chat does not allow anonymous users (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.5  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure meeting chat does not allow anonymous users (Automated).ps1`](./Ensure%20meeting%20chat%20does%20not%20allow%20anonymous%20users%20(Automated).ps1)

## Why this is required

Meeting chat often contains links, files and sensitive discussion. If **anonymous**, unverified participants can read and write in it, they can see that content and also post inappropriate content, malicious links or files to everyone in the meeting.

Restricting chat to verified participants reduces both risks.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `MeetingChatEnabledType`.

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
& ".\Ensure meeting chat does not allow anonymous users (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnabledExceptAnonymous` | **Pass.** |
| `EnabledInMeetingOnlyForAllExceptAnonymous` | **Pass.** More restrictive. |
| `Disabled` | **Pass.** Most restrictive. |
| `Enabled` (on for everyone) | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Meeting engagement*, set **Meeting chat** to **On for everyone but anonymous users** or stricter.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -MeetingChatEnabledType "EnabledExceptAnonymous"
```

## Default value

On for everyone (`Enabled`)

## References

- https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy#-meetingchatenabledtype
