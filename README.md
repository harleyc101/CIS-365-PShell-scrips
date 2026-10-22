# Ensure modern authentication for Exchange Online is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.5.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure modern authentication for Exchange Online is enabled (Automated).ps1`](./Ensure%20modern%20authentication%20for%20Exchange%20Online%20is%20enabled%20(Automated).ps1)

## Why this is required

Modern authentication (OAuth 2.0) is what makes **MFA, Conditional Access, certificate-based authentication and third-party SAML identity providers** work for Outlook. If it's off, Outlook 2013 and 2016 fall back to **basic authentication**, which sends a username and password with no MFA and so bypasses the strong authentication controls in the rest of this benchmark.

Turning on modern authentication for Exchange Online makes Outlook clients use OAuth, so MFA and Conditional Access apply to email access.

## What the script does

1. Reads the Exchange Online organisation configuration and shows the `OAuth*` settings, including `OAuth2ClientProfileEnabled`.

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
& ".\Ensure modern authentication for Exchange Online is enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `OAuth2ClientProfileEnabled` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

**UI:** In the Microsoft 365 admin center, go to **Settings > Org settings > Modern authentication** and tick **Turn on modern authentication for Outlook 2013 for Windows and later (recommended)**.

**PowerShell:**
```powershell
Set-OrganizationConfig -OAuth2ClientProfileEnabled $True
```

## Default value

`True`

## References

- https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/enable-or-disable-modern-authentication-in-exchange-online
