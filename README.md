# Ensure communication with unmanaged Teams users is disabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.2.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure communication with unmanaged Teams users is disabled (Automated).ps1`](./Ensure%20communication%20with%20unmanaged%20Teams%20users%20is%20disabled%20(Automated).ps1)

## Why this is required

**Unmanaged** Teams users are people on personal Microsoft accounts or Teams (free), not managed by any organisation. Anyone can create one in minutes, anonymously, which makes them ideal for attackers to contact your staff with phishing links, malware or social engineering.

Real-world attacks delivered through Teams external access include **DarkGate** malware, **Midnight Blizzard** (APT29) social engineering and credential phishing, **GIFShell** (covert command-and-control and exfiltration through GIFs), and **username enumeration**.

Turning off chats and meetings with unmanaged accounts removes this low-effort attack route.

## What the script does

1. Reads the **Global** external access policy and shows `EnableTeamsConsumerAccess`.
2. Reads the organisation-wide federation configuration and shows `AllowTeamsConsumer`. If this is `False`, the control also passes.

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
& ".\Ensure communication with unmanaged Teams users is disabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableTeamsConsumerAccess` (Global policy) is `False` | **Pass.** |
| `AllowTeamsConsumer` (organisation settings) is `False` | **Pass.** More restrictive. |
| Both are `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **External collaboration > External access** **> Policies > Global (Org-wide default)** and turn **People in my org can chat and have meetings with external users who have unmanaged Microsoft accounts** off.

**PowerShell:**
```powershell
Set-CsExternalAccessPolicy -Identity Global -EnableTeamsConsumerAccess $false
```
Turning it off on the **Organization settings** tab is also compliant.

## Default value

`EnableTeamsConsumerAccess` (Global policy): `True`. `AllowTeamsConsumer` (organisation): `True`.

## Notes and limitations

- Only the **Global (Org-wide default)** policy is assessed. Custom policies assigned to specific users or groups are allowed for justified exceptions.
- This doesn't control anonymous meeting join through a shared link, which is covered by 8.5.1.
- Not available in GCC, GCC High, DoD or private cloud environments.

## References

- https://learn.microsoft.com/en-us/microsoftteams/trusted-organizations-external-meetings-chat?tabs=organization-settings
- https://www.microsoft.com/en-us/security/blog/2023/08/02/midnight-blizzard-conducts-targeted-social-engineering-over-microsoft-teams/
