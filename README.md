# Ensure users installing Outlook add-ins is not allowed (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.3.1  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure users installing Outlook add-ins is not allowed (Automated).ps1`](./Ensure%20users%20installing%20Outlook%20add-ins%20is%20not%20allowed%20(Automated).ps1)

## Why this is required

Outlook add-ins can be given access to read, send and change a user's email, calendar and contacts. If users can install add-ins themselves, from the marketplace or by sideloading a custom manifest, an attacker can trick them into installing a malicious add-in, or abuse a vulnerable legitimate one, to read or exfiltrate mailbox data.

Removing the self-install roles from the **default role assignment policy** means add-ins are approved and deployed centrally by administrators, which shrinks the attack surface.

## What the script does

1. Finds the **default** role assignment policy, which is applied to new mailboxes.
2. Checks whether it includes any of the add-in roles `My Custom Apps`, `My Marketplace Apps` or `My ReadWriteMailbox Apps`.
3. Prints **Compliant** or **Non-compliant**, listing any add-in roles found.

## Prerequisites

- The [Exchange Online PowerShell module](https://learn.microsoft.com/powershell/exchange/exchange-online-powershell-v2):
  ```powershell
  Install-Module ExchangeOnlineManagement -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-ExchangeOnline
  ```

## Usage

```powershell
& ".\Ensure users installing Outlook add-ins is not allowed (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| "Compliant - no add-in roles are assigned to the default policy." | **Pass.** |
| "Non-compliant - the following roles are assigned: ..." | **Fail.** |

## Remediation

**UI:** In the Exchange admin center, go to **Roles > User roles > Default Role Assignment Policy > Manage permissions**. Under *Other roles*, untick **My Custom Apps**, **My Marketplace Apps** and **My ReadWriteMailbox Apps**, and save.

**PowerShell:**
```powershell
$TargetRoles = @(
    "My Custom Apps", "My Marketplace Apps", "My ReadWriteMailbox Apps"
)
$DefaultPolicy = Get-RoleAssignmentPolicy | Where-Object { $_.IsDefault -eq $true }
$Assignments = Get-ManagementRoleAssignment -RoleAssignee $DefaultPolicy.Identity |
    Where-Object { $_.Role -in $TargetRoles }
foreach ($Assignment in $Assignments) {
    Remove-ManagementRoleAssignment -Identity $Assignment.Identity -Confirm:$false
}
```
Before doing this, list the add-ins users rely on and deploy them through **Centralized Deployment**.

## Default value

All three add-in roles are assigned in the default policy.

## Notes and limitations

- Only the **default** role assignment policy is checked. Mailboxes assigned a custom policy need checking separately.
- Global Readers can't see the *Manage permissions* view in the EAC, so use this script instead.

## References

- https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/add-ins-for-outlook/specify-who-can-install-and-manage-add-ins
- https://learn.microsoft.com/en-us/exchange/permissions-exo/role-assignment-policies
