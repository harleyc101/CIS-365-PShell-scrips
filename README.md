# Ensure external meeting chat is off (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.5.8  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure external meeting chat is off (Automated).ps1`](./Ensure%20external%20meeting%20chat%20is%20off%20(Automated).ps1)

## Why this is required

When your users join meetings hosted by **untrusted** external organisations, the meeting chat is a route for malicious content into your environment. Attacks such as **GIFShell** and **DarkGate** malware have been delivered through Teams chat.

Turning off chat in external meetings with organisations you don't trust limits that exposure. Chat in meetings with trusted, allow-listed organisations isn't affected.

## What the script does

1. Reads the **Global** Teams meeting policy and shows `AllowExternalNonTrustedMeetingChat`.

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
& ".\Ensure external meeting chat is off (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowExternalNonTrustedMeetingChat` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **Settings & policies > Global (Org-wide default) settings > Meetings**. Under *Meeting engagement*, set **External meeting chat** to **Off**.

**PowerShell:**
```powershell
Set-CsTeamsMeetingPolicy -Identity Global -AllowExternalNonTrustedMeetingChat $false
```

## Default value

On (`True`)

## Notes and limitations

- Keeping the trusted organisations list up to date takes ongoing admin effort.

## References

- https://learn.microsoft.com/en-us/microsoftteams/settings-policies-reference#meeting-engagement
