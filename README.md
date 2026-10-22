# Ensure system-preferred multifactor authentication is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.2.3.6  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure system-preferred multifactor authentication is enabled (Automated).ps1`](./Ensure%20system-preferred%20multifactor%20authentication%20is%20enabled%20(Automated).ps1)

## Why this is required

Users often register several MFA methods and may set a weak one, such as SMS or a voice call, as their default. **System-preferred MFA** overrides that and always asks for the **most secure method the user has registered**. Microsoft keeps the order up to date, currently: Temporary Access Pass, passkey/FIDO2, Authenticator push, external methods, TOTP, telephony, then certificate-based authentication.

It acts as a safety net. Even if a weaker method has been left enabled by mistake, users are steered to their strongest one. Setting it explicitly to **Enabled**, rather than leaving it Microsoft-managed, makes sure it can't be quietly turned off.

## What the script does

1. Calls the Graph **beta** authentication methods policy endpoint.
2. Shows `systemCredentialPreferences`, including its state and target users.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Policy.Read.AuthenticationMethod"
  ```

## Usage

```powershell
& ".\Ensure system-preferred multifactor authentication is enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `state` is `enabled` **and** `includeTargets` is `all_users` | **Pass.** |
| `state` is `disabled` or `default`, or targets don't include all users | **Fail.** |

## Remediation

In the Entra admin center, go to **Entra ID > Authentication methods > Settings**. Set **System-preferred multifactor authentication** state to **Enabled**, include **All users**, and save.

Document any exclusions and review them every year.

## Default value

Microsoft managed (enabled).

## Notes and limitations

- This uses a Graph **beta** endpoint, which Microsoft may change.

## References

- https://learn.microsoft.com/en-us/entra/identity/authentication/concept-system-preferred-multifactor-authentication
