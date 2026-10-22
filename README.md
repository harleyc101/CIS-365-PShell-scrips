# Ensure meeting recording is off by default (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.9  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure meeting recording is off by default (Automated).ps1`](./Ensure%20meeting%20recording%20is%20off%20by%20default%20(Automated).ps1)

## Why this is required

A meeting recording is a complete, easily shareable copy of everything said and shown, including sensitive discussions, screen shares and personal data. If **anyone** can record by default, recordings of confidential meetings can be made and passed around without the organisation deciding they should exist.

Turning recording off in the **Global** policy, and giving recording rights only to users or groups who need them through a separate policy, puts the organisation in control of what gets recorded.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `AllowCloudRecording`.

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
& ".\Ensure meeting recording is off by default (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowCloudRecording` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Recording & transcription*, set **Meeting recording** to **Off**.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -AllowCloudRecording $false
```
Create a separate meeting policy that allows recording and assign it to the users or groups that need it. That is expected and compliant.

## Default value

On (`True`)

## Notes and limitations

- Only the **Global (Org-wide default)** policy is assessed. Custom policies assigned to specific users or groups are allowed for justified exceptions.

## References

- https://learn.microsoft.com/en-us/microsoftteams/settings-policies-reference#recording--transcription
