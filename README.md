# Ensure 'AuditBypassEnabled' is not enabled on mailboxes (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.1.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure 'AuditBypassEnabled' is not enabled on mailboxes (Automated).ps1`](./Ensure%20%27AuditBypassEnabled%27%20is%20not%20enabled%20on%20mailboxes%20(Automated).ps1)

## Why this is required

A **mailbox audit bypass association** exempts a user or computer account from mailbox audit logging. Anything it does in **any** mailbox it can access (reading, sending, deleting messages) isn't logged at all. The feature was meant to reduce log noise from trusted service accounts.

Whether set deliberately or by mistake, it's an ideal way for a malicious insider or an attacker who has compromised a privileged or service account to **hide their activity**. Audit bypass should be off for every account unless there's a written, approved exception.

## What the script does

1. Gets the audit bypass association for every mailbox and account.
2. Keeps only those with `AuditBypassEnabled` = `True` and shows their name. Commented-out lines export to grid view or CSV.

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
& ".\Ensure 'AuditBypassEnabled' is not enabled on mailboxes (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| No output | **Pass.** No accounts bypass auditing. |
| Any accounts listed | **Fail**, unless each has a documented, approved exception. |

## Remediation

This turns off audit bypass for every account that currently has it:
```powershell
# Get mailboxes with AuditBypassEnabled set to $true
$MBXAudit = Get-MailboxAuditBypassAssociation -ResultSize unlimited | Where-Object { $_.AuditBypassEnabled -eq $true }
foreach ($mailbox in $MBXAudit) {
    $mailboxName = $mailbox.Name
    Set-MailboxAuditBypassAssociation -Identity $mailboxName -AuditBypassEnabled $false
    Write-Host "Audit Bypass disabled for mailbox Identity: $mailboxName" -ForegroundColor Green
}
```

## Default value

`AuditBypassEnabled`: `False`

## Notes and limitations

- The cmdlet may show **warnings** for system objects whose names start with `Asc-2X1`. You can ignore them.

## References

- https://learn.microsoft.com/en-us/powershell/module/exchange/get-mailboxauditbypassassociation
