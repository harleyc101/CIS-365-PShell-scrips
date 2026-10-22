# Ensure external participants can't give or request control (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.7  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure external participants can't give or request control (Automated).ps1`](./Ensure%20external%20participants%20can%27t%20give%20or%20request%20control%20(Automated).ps1)

## Why this is required

*Give/request control* lets a meeting participant take **control of another person's shared screen**, including their mouse and keyboard. If external participants (external users, guests and anonymous users) can request control, a moment of inattention, or a social-engineering prompt such as *"let me show you, just accept"*, could let an outsider operate an internal user's machine and reach whatever is on screen.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `AllowExternalParticipantGiveRequestControl`.

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
& ".\Ensure external participants can't give or request control (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowExternalParticipantGiveRequestControl` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Content sharing*, set **External participants can give or request control** to **Off**.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -AllowExternalParticipantGiveRequestControl $false
```

## Default value

Off (`False`)

## Notes and limitations

- This setting also affects webinars.

## References

- https://learn.microsoft.com/en-us/microsoftteams/meeting-who-present-request-control
