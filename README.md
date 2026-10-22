# Ensure anonymous users and dial-in callers can't start a meeting (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure anonymous users and dial-in callers can't start a meeting (Automated).ps1`](./Ensure%20anonymous%20users%20and%20dial-in%20callers%20can%27t%20start%20a%20meeting%20(Automated).ps1)

## Why this is required

If anonymous participants and dial-in callers can **start** a meeting before anyone from the organisation arrives, a meeting link can be used without supervision. Outsiders can use your bridge for their own purposes, or **spam and disrupt** meetings ("Zoom-bombing"-style) before the organiser has joined.

Making them wait in the lobby until an internal or trusted user starts the meeting keeps the organiser in control.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `AllowAnonymousUsersToStartMeeting`.

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
& ".\Ensure anonymous users and dial-in callers can't start a meeting (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowAnonymousUsersToStartMeeting` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Meeting join & lobby*, set **Anonymous users and dial-in callers can start a meeting** to **Off**.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -AllowAnonymousUsersToStartMeeting $false
```

## Default value

Off (`False`)

## Notes and limitations

- This only has an effect when *Who can bypass the lobby* is *Everyone*. If anonymous join is off (8.5.1), it applies only to dial-in callers.

## References

- https://learn.microsoft.com/en-us/microsoftteams/anonymous-users-in-meetings
- https://learn.microsoft.com/en-us/microsoftteams/who-can-bypass-meeting-lobby#overview-of-lobby-settings-and-policies
