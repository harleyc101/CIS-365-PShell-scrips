# Ensure anonymous users can't join a meeting (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.1  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure anonymous users can't join a meeting (Automated).ps1`](./Ensure%20anonymous%20users%20can%27t%20join%20a%20meeting%20(Automated).ps1)

## Why this is required

**Anonymous** meeting participants are people whose identity can't be verified, for example someone who isn't signed in or comes from an untrusted organisation. They appear as *(Unverified)*. Anyone who gets hold of a meeting link, whether forwarded, leaked or guessed, could join a sensitive meeting this way, or use the link to hold their own meetings at other times.

Turning off anonymous join means everyone in the meeting has an identity that can be checked and held accountable.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `AllowAnonymousUsersToJoinMeeting`.

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
& ".\Ensure anonymous users can't join a meeting (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowAnonymousUsersToJoinMeeting` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Meeting join & lobby*, set **Anonymous users can join a meeting unverified** to **Off**.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -AllowAnonymousUsersToJoinMeeting $false
```

## Default value

On (`True`)

## Notes and limitations

- Organisations that don't normally work at Level 2 but handle sensitive information should consider this setting.

## References

- https://learn.microsoft.com/en-us/microsoftteams/anonymous-users-in-meetings
- https://learn.microsoft.com/en-us/MicrosoftTeams/configure-meetings-sensitive-protection
- https://learn.microsoft.com/en-us/microsoftteams/plan-meetings-external-participants
