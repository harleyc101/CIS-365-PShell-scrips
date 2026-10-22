# Ensure the email OTP authentication method is disabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.2.3.7  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure the email OTP authentication method is disabled (Automated).ps1`](./Ensure%20the%20email%20OTP%20authentication%20method%20is%20disabled%20(Automated).ps1)

## Why this is required

**Email one-time passcode** lets B2B guests who don't have an Entra ID, Microsoft account or social identity sign in by having a code emailed to them. It means anyone who controls an inbox, including a free webmail account, can get into shared resources. The guest account's security then depends entirely on that unmanaged mailbox.

Email codes are also easily phished and relayed. Turning email OTP off makes guests use a managed Entra ID account, a Microsoft account or federation, which gives stronger and more accountable identities.

## What the script does

1. Gets the tenant authentication methods policy.
2. Shows the state of each authentication method. The relevant row is `Email`.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Policy.Read.All"
  ```

## Usage

```powershell
& ".\Ensure the email OTP authentication method is disabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `Email` shows `disabled` | **Pass.** |
| `Email` shows `enabled` | **Fail.** |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > Authentication methods > Policies > Email OTP**, turn **Enable** off, and save. (If **Save** stays greyed out, see the UI workaround described in 5.2.3.5.)

**PowerShell** (needs `Connect-MgGraph -Scopes "Policy.ReadWrite.AuthenticationMethod"`):
```powershell
$params = @(
    @{ Id = "Email"; State = "disabled" }
)
Update-MgPolicyAuthenticationMethodPolicy -AuthenticationMethodConfigurations $params
```

## Default value

Email OTP: enabled.

## Notes and limitations

- Guests who currently sign in with email OTP (for example @yahoo.com addresses) will need a Microsoft account, an Entra ID account, or federation afterwards.

## References

- https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage
- https://learn.microsoft.com/en-us/entra/external-id/one-time-passcode
