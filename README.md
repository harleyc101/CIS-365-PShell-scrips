# Ensure only organizers and co-organizers can present (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.6  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure only organizers and co-organizers can present (Automated).ps1`](./Ensure%20only%20organizers%20and%20co-organizers%20can%20present%20(Automated).ps1)

## Why this is required

If **everyone** in a meeting can present by default, any participant, including external or unexpected attendees, can start sharing their screen or content at any time. That could be inappropriate, offensive or malicious material, or a phishing page dressed up to look official.

Making organisers and co-organisers the default presenters means others can present only when deliberately given the role.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `DesignatedPresenterRoleMode`.

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
& ".\Ensure only organizers and co-organizers can present (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `OrganizerOnlyUserOverride` | **Pass.** |
| `EveryoneUserOverride` or `EveryoneInCompanyUserOverride` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Content sharing*, set **Who can present** to **Only organizers and co-organizers**.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -DesignatedPresenterRoleMode "OrganizerOnlyUserOverride"
```

## Default value

Everyone (`EveryoneUserOverride`)

## Notes and limitations

- Organisers and co-organisers can still change this for an individual meeting.

## References

- https://learn.microsoft.com/en-us/microsoftteams/meeting-who-present-request-control#manage-who-can-present
- https://learn.microsoft.com/en-us/defender-office-365/step-by-step-guides/reducing-attack-surface-in-microsoft-teams#configure-meeting-settings-restrict-presenters
