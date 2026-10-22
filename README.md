# Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)' (Automated).ps1`](./Ensure%20the%20%27Password%20expiration%20policy%27%20is%20set%20to%20%27Set%20passwords%20to%20never%20expire%20(recommended)%27%20(Automated).ps1)

## Why this is required

NIST (SP 800-63B) and Microsoft both advise against making users change passwords on a fixed schedule. Forced periodic changes lead people to choose weaker, predictable passwords (for example `Summer2025!` becomes `Autumn2025!`), write them down, or reuse them. Passwords should be changed only when there is evidence of compromise or the user has forgotten it.

Once MFA is enforced for everyone, as elsewhere in this benchmark, password expiry adds very little security, so it should be turned off. Pair this with banned-password lists and MFA.

## What the script does

1. Gets every domain in the tenant with `Get-MgDomain`.
2. Shows each domain's `PasswordValidityPeriodInDays`.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Domain.Read.All"
  ```

## Usage

```powershell
& ".\Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `PasswordValidityPeriodInDays` is `2147483647` for every valid domain | **Pass.** Passwords never expire. |
| Any domain shows another value (for example `90`) or is blank | **Fail.** Passwords expire after that many days. Blank means the 90-day default applies. |

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Settings > Org settings > Security & privacy > Password expiration policy**, tick **Set passwords to never expire (recommended)** and save.

**PowerShell** (needs `Connect-MgGraph -Scopes "Domain.ReadWrite.All"`):
```powershell
Update-MgDomain -DomainId <Domain> -PasswordValidityPeriodInDays 2147483647
```

## Default value

If the property is not set, a default of 90 days is used.

## Notes and limitations

- Unverified domains may also be listed. Only verified domains that users sign in with matter.

## References

- https://pages.nist.gov/800-63-3/sp800-63b.html
- https://www.cisecurity.org/white-papers/cis-password-policy-guide/
- https://learn.microsoft.com/en-us/microsoft-365/admin/misc/password-policy-recommendations
