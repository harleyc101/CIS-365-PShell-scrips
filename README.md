# Ensure administrative accounts use licenses with a reduced application footprint (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.1.4  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure administrative accounts use licenses with a reduced application footprint (Automated).ps1`](./Ensure%20administrative%20accounts%20use%20licenses%20with%20a%20reduced%20application%20footprint%20(Automated).ps1)

## Why this is required

A licence decides which apps an account can use. If an admin account has a full Microsoft 365 licence, it also gets a mailbox, Teams, SharePoint, OneDrive and so on. That exposes a highly privileged identity to everyday threats:

- **Phishing and malicious content** arrive by email and Teams. An admin who reads mail on their admin account can be compromised by one bad click.
- **Social engineering** is easier against an account that is visible in the address book and receives messages.

Admin accounts should either have **no licence** or only an identity licence with no apps, such as **Microsoft Entra ID P1 or P2**. (P1/P2 is needed for Conditional Access, PIM and Identity Protection.) Email, Teams and documents belong on the user's separate, unprivileged "daily driver" account.

## What the script does

1. Gets the activated directory roles and keeps any role whose name contains `Administrator`, plus `Global Reader`.
2. Collects the members of those roles and removes duplicate IDs.
3. Looks up each member's display name and UPN with `Get-MgUser`.
4. Gets each admin's assigned licences with `Get-MgUserLicenseDetail` and joins the SKU part numbers into one string.
5. Shows a table of admin, UPN and licences.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "RoleManagement.Read.Directory","User.Read.All"
  ```

## Usage

```powershell
& ".\Ensure administrative accounts use licenses with a reduced application footprint (Automated).ps1"
```

## Interpreting the results

The output needs a **manual review**. For each admin account:

| License column | Result |
| --- | --- |
| Empty | **Pass.** The account is unlicensed. |
| Only `AAD_PREMIUM` / `AAD_PREMIUM_P2` (Entra ID P1/P2) or similar identity-only SKUs | **Pass.** |
| Contains an app licence such as `SPE_E3`, `SPE_E5`, `ENTERPRISEPACK`, `O365_BUSINESS_PREMIUM` | **Fail.** The admin account has apps such as a mailbox. |

If the organisation uses **PIM** to elevate users' normal accounts only when needed (with approval for Global Admin), the control is considered satisfied.

## Remediation

1. Create a separate cloud-only admin account for each administrator.
2. Assign it **Microsoft Entra ID P1 or P2** only, or no licence.
3. Move the admin roles from the user's licensed daily account to the new admin account (ideally as PIM-eligible assignments).
4. Configure alert notifications to go to a monitored mailbox or SOC, because unlicensed Global Admins won't receive tenant alerts by email.

## Default value

N/A

## Notes and limitations

- If a role contains a group or service principal, `Get-MgUser` returns an error for that member. You can ignore it.
- PIM-eligible assignments are not included, only active role members.

## References

- https://learn.microsoft.com/en-us/microsoft-365/enterprise/protect-your-global-administrator-accounts
- https://learn.microsoft.com/en-us/entra/fundamentals/whatis#what-are-the-microsoft-entra-id-licenses
- https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-deployment-plan#principle-of-least-privilege
