# Ensure sign-in to shared mailboxes is blocked (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.2.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure sign-in to shared mailboxes is blocked (Automated).ps1`](./Ensure%20sign-in%20to%20shared%20mailboxes%20is%20blocked%20(Automated).ps1)

## Why this is required

Every shared mailbox (info@, support@, reception@ and so on) has a user account behind it. It is created with a random password, but the account is **enabled** by default. People are meant to reach the mailbox through their own accounts with delegated permissions, never by signing in to it directly.

If sign-in isn't blocked, anyone who resets that account's password, whether an admin or an attacker with enough access, can sign in as the shared mailbox. They can then send mail that comes from no individual identity, which makes the activity hard to trace. Shared mailboxes also usually lack MFA registration, making them an easy target. Blocking sign-in closes this route without affecting delegated access.

## What the script does

1. Gets every shared mailbox in Exchange Online with `Get-EXOMailbox -RecipientTypeDetails SharedMailbox`.
2. Looks up each mailbox's Entra user object through its `ExternalDirectoryObjectId`.
3. Shows a table of display name, UPN and `AccountEnabled`.

## Prerequisites

- The [Exchange Online PowerShell module](https://learn.microsoft.com/powershell/exchange/exchange-online-powershell-v2):
  ```powershell
  Install-Module ExchangeOnlineManagement -Scope CurrentUser
  ```
- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-ExchangeOnline
  Connect-MgGraph -Scopes "User.Read.All"
  ```

## Usage

```powershell
& ".\Ensure sign-in to shared mailboxes is blocked (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AccountEnabled` is `False` for every shared mailbox | **Pass.** |
| Any shared mailbox shows `AccountEnabled` = `True` | **Fail.** Sign-in is allowed for that mailbox. |

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Users > Active users**, select the shared mailbox's account, choose **Block sign-in** and tick **Block this user from signing in**.

**PowerShell** (needs `Connect-MgGraph -Scopes "User.ReadWrite.All"` and `Connect-ExchangeOnline`):
```powershell
# A single mailbox
$MBX = Get-EXOMailbox -Identity TestUser@example.com
Update-MgUser -UserId $MBX.ExternalDirectoryObjectId -AccountEnabled:$false

# All shared mailboxes
$MBX = Get-EXOMailbox -RecipientTypeDetails SharedMailbox
$MBX | ForEach-Object { Update-MgUser -UserId $_.ExternalDirectoryObjectId -AccountEnabled:$false }
```
Users with Full Access / Send As permissions can still use the mailbox as before.

## Default value

`AccountEnabled`: `True`

## References

- https://learn.microsoft.com/en-us/microsoft-365/admin/email/about-shared-mailboxes
- https://learn.microsoft.com/en-us/microsoft-365/admin/email/create-a-shared-mailbox#block-sign-in-for-the-shared-mailbox-account
