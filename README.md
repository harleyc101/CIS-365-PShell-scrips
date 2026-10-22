# Ensure external domains are restricted in the Teams admin center (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 8.2.1  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure external domains are restricted in the Teams admin center (Automated).ps1`](./Ensure%20external%20domains%20are%20restricted%20in%20the%20Teams%20admin%20center%20(Automated).ps1)

## Why this is required

With unrestricted external access (federation), **any** Teams user in **any** other organisation can find your users and start chats and calls with them. Attackers only need a Microsoft 365 tenant of their own to send convincing phishing, malware or social-engineering messages straight into Teams, where users are less suspicious than with email.

Real-world attacks delivered through Teams external access include **DarkGate** malware, **Midnight Blizzard** (APT29) social engineering and credential phishing, **GIFShell** (covert command-and-control and exfiltration through GIFs), and **username enumeration**.

Turning off external domains on the Global policy, or allowing only an approved list, removes this unsolicited contact route.

## What the script does

1. Reads the **Global** external access policy and shows `EnableFederationAccess`.
2. Reads the organisation-wide federation configuration and shows `AllowFederatedUsers` and `AllowedDomains`. A restrictive setting here also counts as a pass.

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
& ".\Ensure external domains are restricted in the Teams admin center (Automated).ps1"
```

## Interpreting the results

**Pass** if **either** of these is true:

1. The Global policy has `EnableFederationAccess` = `False`, **or**
2. The organisation settings are restrictive:
   - `AllowFederatedUsers` = `False` (external access off), **or**
   - `AllowFederatedUsers` = `True` with `AllowedDomains` **empty** (block all external domains), **or**
   - `AllowFederatedUsers` = `True` with `AllowedDomains` listing only authorised domains (allow only specific domains).

Otherwise the control **fails**.

## Remediation

**UI:** In the [Teams admin center](https://admin.teams.microsoft.com), go to **External collaboration > External access** **> Policies > Global (Org-wide default)** and set **Manage external domains for this policy** to **Off**.

**PowerShell:**
```powershell
Set-CsExternalAccessPolicy -Identity Global -EnableFederationAccess $false
```
Alternatively, on the **Organization settings** tab, set external domains to Off, *Block all external domains*, or *Allow only specific external domains*.

Users who genuinely need external federation can be given a separate custom external access policy.

## Default value

`EnableFederationAccess`: `True`

## Notes and limitations

- Only the **Global (Org-wide default)** policy is assessed. Custom policies assigned to specific users or groups are allowed for justified exceptions.

## References

- https://learn.microsoft.com/en-us/microsoftteams/trusted-organizations-external-meetings-chat?tabs=organization-settings
- https://www.microsoft.com/en-us/security/blog/2023/08/02/midnight-blizzard-conducts-targeted-social-engineering-over-microsoft-teams/
- https://www.bitdefender.com/blog/hotforsecurity/gifshell-attack-lets-hackers-create-reverse-shell-through-microsoft-teams-gifs/
