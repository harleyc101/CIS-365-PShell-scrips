# Ensure the customer lockbox feature is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.6  
**Profile:** E5 Level 2  
**Script:** [`Ensure the customer lockbox feature is enabled (Automated).ps1`](./Ensure%20the%20customer%20lockbox%20feature%20is%20enabled%20(Automated).ps1)

## Why this is required

Occasionally a Microsoft support engineer needs to access customer content, such as mailboxes or files, to resolve a support case. Without Customer Lockbox, that access is approved inside Microsoft. With Customer Lockbox, **your organisation** has to explicitly approve or reject every such request, and every request and decision is logged.

This gives you control over, and an audit trail of, who outside the organisation touches your data. That helps prevent data spillage and meets many compliance requirements.

## What the script does

1. Reads the Exchange Online organisation configuration with `Get-OrganizationConfig`.
2. Shows the `CustomerLockBoxEnabled` value.

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
& ".\Ensure the customer lockbox feature is enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `CustomerLockBoxEnabled` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Settings > Org settings > Security & privacy > Customer lockbox**, tick **Require approval for all data access requests**, and save.

**PowerShell:**
```powershell
Set-OrganizationConfig -CustomerLockBoxEnabled $true
```
Administrators then have to approve Microsoft access requests before support engineers can work on tickets that need data access.

## Default value

`CustomerLockboxEnabled`: `False`

## Notes and limitations

- Customer Lockbox needs an E5 licence or the relevant add-on.

## References

- https://learn.microsoft.com/en-us/purview/customer-lockbox-requests#turn-customer-lockbox-requests-on-or-off
