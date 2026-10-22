# Ensure external Teams users cannot initiate conversations (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.2.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure external Teams users cannot initiate conversations (Automated).ps1`](./Ensure%20external%20Teams%20users%20cannot%20initiate%20conversations%20(Automated).ps1)

## Why this is required

This is a backstop for 8.2.2. Even where an organisation allows some users to communicate with unmanaged Teams accounts, it can stop those **outsiders starting the conversation**. That blocks the unsolicited, attacker-initiated first contact that phishing and social-engineering campaigns depend on, while still letting your users reach out when they need to.

Real-world attacks delivered through Teams external access include **DarkGate** malware, **Midnight Blizzard** (APT29) social engineering and credential phishing, **GIFShell** (covert command-and-control and exfiltration through GIFs), and **username enumeration**.

## What the script does

1. Reads the **Global** external access policy and shows `EnableTeamsConsumerInbound`.
2. Reads the organisation-wide federation configuration and shows `AllowTeamsConsumerInbound`. If this is `False`, the control also passes.

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
& ".\Ensure external Teams users cannot initiate conversations (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableTeamsConsumerInbound` (Global policy) is `False` | **Pass.** |
| `AllowTeamsConsumerInbound` (organisation settings) is `False` | **Pass.** More restrictive. |
| Both are `True` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **External collaboration > External access** **> Policies > Global (Org-wide default)**. Under the unmanaged accounts setting, untick **People in my org can join external meetings and receive new chats from users who have unmanaged Microsoft accounts**. (If the parent setting is already Off, this option is hidden and the control already passes.)

**PowerShell:**
```powershell
Set-CsExternalAccessPolicy -Identity Global -EnableTeamsConsumerInbound $false
```

## Default value

`EnableTeamsConsumerInbound` (Global policy): `True`. `AllowTeamsConsumerInbound` (organisation): `True`.

## Notes and limitations

- Only the **Global (Org-wide default)** policy is assessed. Custom policies assigned to specific users or groups are allowed for justified exceptions.
- Turning off unmanaged communication entirely (8.2.2) also prevents inbound contact.
- Not available in GCC, GCC High, DoD or private cloud environments.

## References

- https://learn.microsoft.com/en-us/microsoftteams/trusted-organizations-external-meetings-chat?tabs=organization-settings
