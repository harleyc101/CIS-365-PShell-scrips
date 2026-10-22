# Ensure mailbox audit actions are configured (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.1.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure mailbox audit actions are configured (Automated).ps1`](./Ensure%20mailbox%20audit%20actions%20are%20configured%20(Automated).ps1)

## Why this is required

Mailbox auditing is on by default, but Microsoft's **default list of audited actions** leaves out several that matter in an investigation:

- **Admin:** `Copy`, `FolderBind` (folder access) and `Move`
- **Delegate:** `FolderBind` and `Move`
- **Owner:** `Create`, `MailboxLogin` and `Move`

Without these, you can't fully answer questions such as *when did the attacker sign in to this mailbox?*, *which folders did a delegate open?* or *what did they move or copy?*. Adding them to every user mailbox gives security operations, forensics and compliance teams the full picture.

## What the script does

1. Defines the expected audit actions for Admin, Delegate and Owner sign-ins: Microsoft's defaults plus the benchmark's additions.
2. Gets every **user mailbox** with its audit settings.
3. For each mailbox, lists any expected actions missing from `AuditAdmin`, `AuditDelegate` and `AuditOwner`, and checks `AuditEnabled`.
4. Marks each mailbox **Compliant** or **Non-Compliant** and shows the results as a table. Commented-out lines export to grid view, CSV or JSON.

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
& ".\Ensure mailbox audit actions are configured (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Every mailbox shows `ComplianceState` = `Compliant` | **Pass.** |
| Any mailbox shows `Non-Compliant` | **Fail.** The `*Missing` columns show which actions to add, and `AuditEnabled` must be `True`. |

## Remediation

This applies the full action lists and a 180-day audit log age limit to **every** user mailbox:
```powershell
$AuditAdmin = @(
    "ApplyRecord", "Copy", "Create", "FolderBind", "HardDelete",
    "MailItemsAccessed", "Move", "MoveToDeletedItems", "SendAs",
    "SendOnBehalf", "Send", "SoftDelete", "Update",
    "UpdateCalendarDelegation", "UpdateFolderPermissions",
    "UpdateInboxRules"
)
$AuditDelegate = @(
    "ApplyRecord", "Create", "FolderBind", "HardDelete", "Move",
    "MailItemsAccessed", "MoveToDeletedItems", "SendAs", "SendOnBehalf",
    "SoftDelete", "Update", "UpdateFolderPermissions", "UpdateInboxRules"
)
$AuditOwner = @(
    "ApplyRecord", "Create", "HardDelete", "MailboxLogin", "Move",
    "MailItemsAccessed", "MoveToDeletedItems", "Send", "SoftDelete",
    "Update", "UpdateCalendarDelegation", "UpdateFolderPermissions",
    "UpdateInboxRules"
)
$MBX = Get-EXOMailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "UserMailbox" }
$MBX | Set-Mailbox -AuditEnabled $true -AuditLogAgeLimit 180 `
    -AuditAdmin $AuditAdmin -AuditDelegate $AuditDelegate -AuditOwner $AuditOwner
```

## Default value

`AuditEnabled` is `True` for all mailboxes except resource, public folder and DiscoverySearch mailboxes.

- **AuditAdmin:** ApplyRecord, Create, HardDelete, MailItemsAccessed, MoveToDeletedItems, Send, SendAs, SendOnBehalf, SoftDelete, Update, UpdateCalendarDelegation, UpdateFolderPermissions, UpdateInboxRules
- **AuditDelegate:** ApplyRecord, Create, HardDelete, MailItemsAccessed, MoveToDeletedItems, SendAs, SendOnBehalf, SoftDelete, Update, UpdateFolderPermissions, UpdateInboxRules
- **AuditOwner:** ApplyRecord, HardDelete, MailItemsAccessed, MoveToDeletedItems, Send, SoftDelete, Update, UpdateCalendarDelegation, UpdateFolderPermissions, UpdateInboxRules

## Notes and limitations

- Resource, public folder and DiscoverySearch mailboxes ignore the organisation default and need `AuditEnabled` set on each mailbox.
- Audit records are stored in the mailbox's Recoverable Items > Audits folder and count towards its quota (up to 3 million items). The impact is usually negligible.
- Audit (Standard) keeps logs for 180 days. Audit (Premium), included in E5, can keep them longer.
- The script checks every user mailbox, so it can take a while in large tenants.

## References

- https://learn.microsoft.com/en-us/purview/audit-mailboxes
