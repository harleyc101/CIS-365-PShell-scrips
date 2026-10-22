# Ensure weak authentication methods are disabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.2.3.5  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure weak authentication methods are disabled (Automated).ps1`](./Ensure%20weak%20authentication%20methods%20are%20disabled%20(Automated).ps1)

## Why this is required

**SMS** and **voice call** send the second factor over the phone network, which attackers can intercept or redirect:

- **SIM swapping:** an attacker persuades the mobile carrier to move the victim's number to their own SIM and then receives every code.
- **SS7 and telephony interception**, plus social engineering of carrier staff.
- Codes are easily phished or relayed by adversary-in-the-middle phishing kits.

Turning these methods off moves users to stronger options such as Microsoft Authenticator with number matching, passkeys/FIDO2 or certificate-based authentication.

## What the script does

1. Gets the tenant authentication methods policy.
2. Shows the state (`enabled` or `disabled`) of each authentication method.

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
& ".\Ensure weak authentication methods are disabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `Sms` **and** `Voice` both show `disabled` | **Pass.** |
| Either shows `enabled` | **Fail.** |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > Authentication methods > Policies**. Open **SMS** and **Voice call** in turn, turn **Enable** off, and save.

If **Save** stays greyed out after turning a method off (a known UI bug), turn it back on, change the target (all users or select groups), turn it off again and then save.

**PowerShell** (needs `Connect-MgGraph -Scopes "Policy.ReadWrite.AuthenticationMethod"`):
```powershell
$params = @(
    @{ Id = "Sms"; State = "disabled" },
    @{ Id = "Voice"; State = "disabled" }
)
Update-MgPolicyAuthenticationMethodPolicy -AuthenticationMethodConfigurations $params
```

## Default value

SMS: disabled. Voice call: disabled.

## Notes and limitations

- Before turning these off, make sure users who rely on them have registered a stronger method, or they could be locked out.

## References

- https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage
- https://learn.microsoft.com/en-us/security/zero-trust/sfi/phishing-resistant-mfa#context-and-problem
