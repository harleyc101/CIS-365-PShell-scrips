# Ensure 'AuditDisabled' organizationally is set to 'False' (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.1.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure 'AuditDisabled' organizationally is set to 'False' (Automated).ps1`](./Ensure%20%27AuditDisabled%27%20organizationally%20is%20set%20to%20%27False%27%20(Automated).ps1)

## Why this is required

Since 2019, Exchange Online has **mailbox auditing on by default** for the whole organisation. This records actions such as mailbox logins, messages being read, sent or deleted, and changes to permissions and inbox rules, whatever the per-mailbox settings are.

If `AuditDisabled` is set to `True`, **all** mailbox auditing stops across the organisation. Per-mailbox settings are ignored, new mailboxes aren't audited, and investigators lose the trail needed to see what an attacker read, forwarded or deleted. This control makes sure it hasn't been turned off, deliberately or by accident.

## What the script does

1. Reads the Exchange Online organisation configuration and shows `AuditDisabled`.

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
& ".\Ensure 'AuditDisabled' organizationally is set to 'False' (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AuditDisabled` is `False` | **Pass.** Mailbox auditing is on by default. |
| `True` | **Fail.** Mailbox auditing is off for the whole organisation. |

## Remediation

```powershell
Set-OrganizationConfig -AuditDisabled $false
```

## Default value

`False`

## References

- https://learn.microsoft.com/en-us/purview/audit-mailboxes
- https://learn.microsoft.com/en-us/powershell/module/exchange/set-organizationconfig#-auditdisabled
