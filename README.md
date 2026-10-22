# Ensure only people in my org can bypass the lobby (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure only people in my org can bypass the lobby (Automated).ps1`](./Ensure%20only%20people%20in%20my%20org%20can%20bypass%20the%20lobby%20(Automated).ps1)

## Why this is required

The lobby is where the organiser checks who is joining before letting them in. If everyone, including guests and external users, can **bypass the lobby**, anyone with the link goes straight into the meeting and can hear or see sensitive content before the organiser even notices them. They could also use the link to meet at unscheduled times.

Limiting automatic admission to invited people, people in your organisation, or organisers only means outsiders have to be vetted.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `AutoAdmittedUsers`.

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
& ".\Ensure only people in my org can bypass the lobby (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `InvitedUsers` (people who were invited) | **Pass.** |
| `EveryoneInCompanyExcludingGuests` (people in my org) | **Pass.** |
| `OrganizerOnly` (only organisers and co-organisers) | **Pass.** |
| `EveryoneInCompany` (org **and guests**), `EveryoneInSameAndFederatedCompany` or `Everyone` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Meeting join & lobby*, set **Who can bypass the lobby** to *People who were invited*, *People in my org* or *Only organizers and co-organizers*.

**PowerShell** (choose one):
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -AutoAdmittedUsers "InvitedUsers"
Set-CsTeamsMeetingPolicy -Identity Global -AutoAdmittedUsers "EveryoneInCompanyExcludingGuests"
Set-CsTeamsMeetingPolicy -Identity Global -AutoAdmittedUsers "OrganizerOnly"
```

## Default value

People in my org and guests (`EveryoneInCompany`). This is **not** compliant.

## Notes and limitations

- Dial-in users, including internal users dialling in by phone, are unauthenticated and will always wait in the lobby.

## References

- https://learn.microsoft.com/en-us/microsoftteams/who-can-bypass-meeting-lobby#overview-of-lobby-settings-and-policies
- https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy
