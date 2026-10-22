# Ensure that DKIM is enabled for all Exchange Online Domains (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.9  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure that DKIM is enabled for all Exchange Online Domains (Automated).ps1`](./Ensure%20that%20DKIM%20is%20enabled%20for%20all%20Exchange%20Online%20Domains%20(Automated).ps1)

## Why this is required

DomainKeys Identified Mail (DKIM) adds a cryptographic signature to every outgoing email. Receiving systems use a public key published in your DNS to check that the message really came from your organisation and wasn't altered in transit.

DKIM works with SPF and DMARC. Together they make it much harder for attackers to send convincing mail that appears to come from your domain. DMARC in particular depends on SPF or DKIM passing **and aligning**, and DKIM survives forwarding, which SPF doesn't.

## What the script does

1. Gets the accepted domains, excluding the `*.onmicrosoft.com` initial and coexistence domains, which Microsoft signs automatically.
2. Gets the DKIM signing configuration with `Get-DkimSigningConfig`. Domains that have never been set up don't appear there, so the script matches each accepted domain against it.
3. Builds a report of each domain with `Enabled`, `Status` (or *Not Configured*) and `IsCISCompliant`.
4. Shows the report as a table. A commented-out line exports it to CSV.

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
& ".\Ensure that DKIM is enabled for all Exchange Online Domains (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| Every sending domain has `Enabled` = `True` and `Status` = `Valid` (`IsCISCompliant` = `True`) | **Pass.** |
| Any sending domain shows `IsCISCompliant` = `False` or `Status` = `Not Configured` | **Fail.** |

## Remediation

1. In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Email authentication settings > DKIM**.
2. Select the domain and choose **Create DKIM keys**.
3. Publish the two CNAME records (`selector1._domainkey` and `selector2._domainkey`) that Microsoft gives you at your DNS registrar.
4. Go back and switch **Sign messages for this domain with DKIM signatures** to **Enabled**. The status should show *Signing DKIM signatures for this domain*.

With PowerShell, once the CNAMEs are published: `Set-DkimSigningConfig -Identity yourdomain.com -Enabled $true`

## Default value

Custom domains: not configured. The `*.onmicrosoft.com` domain is signed automatically.

## Notes and limitations

- Don't publish DKIM for **parked** domains that never send mail. Having no key means forged mail from them can't pass DKIM.

## References

- https://learn.microsoft.com/en-us/defender-office-365/email-authentication-dkim-configure
