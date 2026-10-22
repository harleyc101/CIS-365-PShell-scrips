# Ensure Microsoft 365 audit log search is Enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 3.1.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure Microsoft 365 audit log search is Enabled (Automated).ps1`](./Ensure%20Microsoft%20365%20audit%20log%20search%20is%20Enabled%20(Automated).ps1)

## Why this is required

The Microsoft 365 **unified audit log** records user and admin activity across Exchange, SharePoint, OneDrive, Teams, Entra ID and more: who signed in, who accessed or shared which files, who changed mailbox rules or permissions, and so on.

If it's turned off, none of this is recorded. During a security incident you then can't tell what an attacker did, what data they touched or how they got in, and many regulations that require audit trails can't be met. Even if you also send logs to a SIEM, the unified audit log is usually its source.

## What the script does

1. Reads the Exchange Online admin audit log configuration.
2. Shows `UnifiedAuditLogIngestionEnabled`, which controls whether the unified audit log is recording.

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
& ".\Ensure Microsoft 365 audit log search is Enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `UnifiedAuditLogIngestionEnabled` is `True` | **Pass.** |
| `False` | **Fail.** See the note about session order below before relying on this. |

## Remediation

**UI:** In [Microsoft Purview](https://purview.microsoft.com), go to **Solutions > Audit** and choose **Start recording user and admin activity**, then confirm.

**PowerShell:**
```powershell
Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true
```

## Default value

Enabled, with records kept for 180 days.

## Notes and limitations

- If you're connected to **both** Security & Compliance PowerShell and Exchange Online in the same session, this value can wrongly show `False`, depending on which module loaded first. Run the check in a session connected to Exchange Online only, or connect to Security & Compliance **first** and Exchange Online second.

## References

- https://learn.microsoft.com/en-us/purview/audit-log-enable-disable
- https://learn.microsoft.com/en-us/powershell/module/exchange/set-adminauditlogconfig
