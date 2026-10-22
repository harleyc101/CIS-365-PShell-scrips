# Ensure the organization cannot communicate with accounts in trial Teams tenants (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.2.4  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the organization cannot communicate with accounts in trial Teams tenants (Automated).ps1`](./Ensure%20the%20organization%20cannot%20communicate%20with%20accounts%20in%20trial%20Teams%20tenants%20(Automated).ps1)

## Why this is required

**Trial-only** Teams tenants, with no purchased licences, are free and quick to create, and threat actors have used them heavily to send phishing and malware over Teams external access. Microsoft changed the default to **Blocked** on 29 July 2024 in response.

This control makes sure that protection stays in place and hasn't been turned back on.

Real-world attacks delivered through Teams external access include **DarkGate** malware, **Midnight Blizzard** (APT29) social engineering and credential phishing, **GIFShell** (covert command-and-control and exfiltration through GIFs), and **username enumeration**.

## What the script does

1. Reads the organisation-wide federation configuration and shows `ExternalAccessWithTrialTenants`.

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
& ".\Ensure the organization cannot communicate with accounts in trial Teams tenants (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `ExternalAccessWithTrialTenants` is `Blocked` | **Pass.** |
| `Allowed` | **Fail.** |

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **External collaboration > External access** **> Organization settings** and set **People in my organization can communicate with accounts in trial Teams tenants** to **Off**.

**PowerShell:**
```powershell
Set-CsTenantFederationConfiguration -ExternalAccessWithTrialTenants "Blocked"
```
Users currently chatting with trial-tenant accounts will be removed from those chats.

## Default value

Off / `Blocked`

## References

- https://learn.microsoft.com/en-us/microsoftteams/trusted-organizations-external-meetings-chat?tabs=organization-settings#block-federation-with-teams-trial-only-tenants
