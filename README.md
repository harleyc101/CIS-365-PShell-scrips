# Ensure users dialing in can't bypass the lobby (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.4  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure users dialing in can't bypass the lobby (Automated).ps1`](./Ensure%20users%20dialing%20in%20can%27t%20bypass%20the%20lobby%20(Automated).ps1)

## Why this is required

People who **dial in by phone** can't be authenticated. Teams only knows their phone number, which can be spoofed. If dial-in callers can bypass the lobby, anyone who has the dial-in number and conference ID can listen in to a meeting unnoticed.

Making phone participants wait in the lobby lets the organiser confirm who they are before admitting them.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `AllowPSTNUsersToBypassLobby`.

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
& ".\Ensure users dialing in can't bypass the lobby (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowPSTNUsersToBypassLobby` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Meeting join & lobby*, set **People dialing in can bypass the lobby** to **Off**.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -AllowPSTNUsersToBypassLobby $false
```

## Default value

Off (`False`)

## References

- https://learn.microsoft.com/en-us/microsoftteams/who-can-bypass-meeting-lobby#overview-of-lobby-settings-and-policies
