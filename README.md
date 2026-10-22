# Ensure notifications for internal users sending malware is Enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure notifications for internal users sending malware is Enabled (Automated).ps1`](./Ensure%20notifications%20for%20internal%20users%20sending%20malware%20is%20Enabled%20(Automated).ps1)

## Why this is required

If one of your **own users** sends an email containing malware, that's a strong sign their account or device is compromised. An attacker may be using it to spread malware internally or to partners and customers.

Turning on internal-sender admin notifications means an administrator is emailed straight away when this happens, so the account and machine can be investigated and contained quickly. Without it, the message is silently blocked and nobody finds out.

## What the script does

1. Gets every anti-malware policy with `Get-MalwareFilterPolicy`.
2. Shows each policy's `EnableInternalSenderAdminNotifications` and `InternalSenderAdminAddress`.

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
& ".\Ensure notifications for internal users sending malware is Enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableInternalSenderAdminNotifications` is `True` **and** `InternalSenderAdminAddress` has an address | **Pass.** |
| Notifications are `False`, or no address is set | **Fail.** |

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-malware > Default (Default) > Edit protection settings**. Turn on **Notify an admin about undelivered messages from internal senders** and enter an administrator email address.

**PowerShell:**
```powershell
Set-MalwareFilterPolicy -Identity 'Default' -EnableInternalSenderAdminNotifications $True -InternalSenderAdminAddress 'admin@yourdomain.com'
```

## Default value

`EnableInternalSenderAdminNotifications`: `False`  
`InternalSenderAdminAddress`: `$null`

## Notes and limitations

- Microsoft's guidance focuses on the Default policy, but if a custom policy exists, the setting must be correct in the **highest-priority** policy that applies to users.

## References

- https://learn.microsoft.com/en-us/defender-office-365/anti-malware-protection-about
- https://learn.microsoft.com/en-us/defender-office-365/anti-malware-policies-configure
