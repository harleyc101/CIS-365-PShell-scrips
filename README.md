# Ensure all member users are 'MFA capable' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.2.3.4  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure all member users are 'MFA capable' (Automated).ps1`](./Ensure%20all%20member%20users%20are%20%27MFA%20capable%27%20(Automated).ps1)

## Why this is required

A Conditional Access policy can require MFA, but a user who has **never registered** a strong MFA method isn't protected by it. They may never have signed in, may be excluded from the policy, or the policy may not exist. Those accounts can be taken over with just a password, and an attacker who gets in first can register **their own** MFA method.

Microsoft defines *MFA capable* as registered for, and allowed to use, a strong authentication method. Regularly reviewing member users who are **not** MFA capable shows gaps in policy coverage, stale or unused accounts, and onboarding problems.

## What the script does

1. Queries the authentication methods registration report for **member** users (not guests) where `IsMfaCapable` is `false`.
2. Shows each user's UPN, MFA capability and whether they're an admin.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All","AuditLog.Read.All"
  ```

## Usage

```powershell
& ".\Ensure all member users are 'MFA capable' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| No users returned | **Pass.** |
| Users returned | **Fail**, unless each is a documented exception (for example the on-premises directory sync account). Pay particular attention to rows where `IsAdmin` is `True`. |

## Remediation

Review each user case by case:

- **Never signed in or no longer employed:** review employment status and disable, unlicense or remove roles as appropriate.
- **Should be using MFA:**
  - Make sure a Conditional Access policy requires MFA for all users (section 5.2.2 of the benchmark), is **On**, and doesn't exclude the user.
  - Use **Conditional Access > What If** to see which policies apply to the user.
  - Check the user's **Sign-in logs > Conditional Access** tab to see which policies were applied.

## Notes and limitations

- The on-premises directory synchronisation account normally appears here and is an acceptable exception.
- The report data can be a few hours behind.

## References

- https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-methods-activity
- https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool
- https://learn.microsoft.com/en-us/entra/identity/monitoring-health/how-to-view-applied-conditional-access-policies
