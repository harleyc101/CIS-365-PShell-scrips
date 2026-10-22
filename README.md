# Ensure 'External sharing' of calendars is not available (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.3  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure 'External sharing' of calendars is not available (Automated).ps1`](./Ensure%20%27External%20sharing%27%20of%20calendars%20is%20not%20available%20(Automated).ps1)

## Why this is required

Attackers research a target before they strike. A calendar shared outside the organisation shows who meets whom, reporting lines, partner relationships, and when people are travelling, on leave or out of the office. That's exactly what's needed for well-timed phishing and business email compromise ("I'm boarding a flight, please pay this invoice urgently").

Few organisations rely on external calendar sharing, so turning it off rarely affects anyone and removes this source of information.

## What the script does

1. Reads the **Default Sharing Policy** with `Get-SharingPolicy` and shows whether it is `Enabled`.
2. **Optional second part:** goes through every mailbox, finds its default calendar folder (whatever language it's named in), and prints a yellow warning for any calendar that is currently **published** externally, with its public URL.

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
& ".\Ensure 'External sharing' of calendars is not available (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `Enabled` is `False` for the Default Sharing Policy | **Pass.** |
| `Enabled` is `True` | **Fail.** Users can share calendars externally. |

The yellow "Calendar publishing is enabled for ..." lines don't affect pass/fail. They list mailboxes whose calendars are already published, which you should follow up before or after disabling the feature.

The second part checks every mailbox one by one, so it can take a long time in large tenants. Comment it out if you only need pass/fail.

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Settings > Org settings > Services > Calendar**, untick **Let your users share their calendars with people outside of your organization who have Office 365 or Exchange**, and save.

**PowerShell:**
```powershell
Set-SharingPolicy -Identity "Default Sharing Policy" -Enabled $False
```

## Default value

Enabled (`True`)

## References

- https://learn.microsoft.com/en-us/microsoft-365/admin/manage/share-calendars-with-external-users
