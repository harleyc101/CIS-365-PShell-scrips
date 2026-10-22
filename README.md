# Ensure shared bookings pages are restricted to select users (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 1.3.9  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure shared bookings pages are restricted to select users (Automated).ps1`](./Ensure%20shared%20bookings%20pages%20are%20restricted%20to%20select%20users%20(Automated).ps1)

## Why this is required

Shared Bookings lets users create booking pages, and each page gets its **own mailbox and email address in your domain**. Attackers can abuse this:

- A compromised low-privilege account can create a Bookings page with a convincing internal address, for example one that looks like the CEO's or finance's. This **impersonates high-profile people** and gets around impersonation filters, which treat the address as internal and legitimate.
- Attackers can create official-looking addresses such as `admin@`, `hostmaster@` or `security@` and use them to social-engineer external parties, for example to take over domain registrations or certificates.

Shared Bookings should be available only to users who need it, through a separate OWA policy, with the default policy blocking it for everyone else.

## What the script does

1. Reads `BookingsMailboxCreationEnabled` from the **OwaMailboxPolicy-Default** policy.
2. Reads `BookingsEnabled` from the organisation config. If this is `False`, Bookings is off tenant-wide, which is also compliant.

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
& ".\Ensure shared bookings pages are restricted to select users (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `BookingsMailboxCreationEnabled` is `False` | **Pass.** |
| `BookingsEnabled` is `False` (whatever the OWA policy says) | **Pass.** Bookings is off for the whole tenant, which is more restrictive. |
| `BookingsMailboxCreationEnabled` is `True` **and** `BookingsEnabled` is `True` | **Fail.** |

## Remediation

First assign any users who genuinely need Shared Bookings a **separate OWA mailbox policy** that allows it, so they aren't disrupted. Then:

```powershell
Set-OwaMailboxPolicy "OwaMailboxPolicy-Default" -BookingsMailboxCreationEnabled $false
```

Optionally, for a stricter setting, turn Bookings off for the whole organisation. This has more impact and isn't needed for compliance:
```powershell
Set-OrganizationConfig -BookingsEnabled $false
```

## Default value

`BookingsMailboxCreationEnabled`: `True` (OwaMailboxPolicy-Default)  
`BookingsEnabled`: `True`

## References

- https://learn.microsoft.com/en-us/microsoft-365/bookings/turn-bookings-on-or-off
- https://techcommunity.microsoft.com/blog/office365businessappsblog/enhancing-security-in-microsoft-bookings-best-practices-for-admins/4382447
- https://learn.microsoft.com/en-us/microsoft-365/bookings/best-practices-shared-bookings
- https://www.cyberis.com/article/microsoft-bookings-facilitating-impersonation
