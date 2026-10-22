# Ensure DMARC records for all Exchange Online domains are published (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.10  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure DMARC records for all Exchange Online domains are published (Automated).ps1`](./Ensure%20DMARC%20records%20for%20all%20Exchange%20Online%20domains%20are%20published%20(Automated).ps1)

## Why this is required

DMARC (Domain-based Message Authentication, Reporting and Conformance) tells receiving mail systems what to do with a message claiming to be from your domain when it **fails SPF and DKIM**: deliver it, quarantine it, or reject it. It also has them send you reports about who is sending mail as your domain.

- With **no DMARC record**, or `p=none`, spoofed mail is still delivered. US NSA/FBI advisories have noted state-sponsored actors deliberately exploiting weak DMARC policies.
- `p=quarantine` or `p=reject` with `pct=100` puts the policy fully into effect.
- `rua` and `ruf` reporting addresses give you visibility of spoofing attempts and misconfigured legitimate senders.

This includes the tenant's **`*.onmicrosoft.com` (MOERA)** domain, which can also send mail and is often forgotten.

## What the script does

1. Gets every accepted domain except the hybrid coexistence domain. This **includes** the `*.onmicrosoft.com` MOERA domain.
2. Looks up the `_dmarc.<domain>` TXT record for each with `Resolve-DnsName`.
3. Shows each domain with its DMARC record, or **NO DMARC RECORD**.

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
& ".\Ensure DMARC records for all Exchange Online domains are published (Automated).ps1"
```

## Interpreting the results

For each domain, the DMARC record must meet **all** of these:

1. `v=DMARC1`
2. `p=quarantine` or `p=reject`
3. `pct=100`, or no `pct` tag (which means 100)
4. A `rua=mailto:...` aggregate report address
5. A `ruf=mailto:...` failure report address

**Parked domains** (no mail sent) need at least `v=DMARC1; p=reject;`.

Compliant examples:
```
v=DMARC1; p=reject; pct=100; rua=mailto:rua@example.com; ruf=mailto:ruf@example.com; fo=1
v=DMARC1; p=reject; rua=mailto:rua@example.com; ruf=mailto:ruf@example.com; fo=1
v=DMARC1; p=reject;                                     # parked domain
```
**Subdomains:** a subdomain with its own valid DMARC record uses only that record. Otherwise the organisational domain's record applies, using `sp=` if set, or `p=` if not. A record with `sp=none` therefore leaves subdomains non-compliant. If a record is a CNAME pointing elsewhere, the target record must meet the criteria.

Any domain showing **NO DMARC RECORD**, or with `p=none`, **fails**.

## Remediation

Roll DMARC out in stages so legitimate mail isn't blocked:

1. **Monitor.** Publish a TXT record at `_dmarc.yourdomain.com`:
   ```
   v=DMARC1; p=none; rua=mailto:<rua-report@example.com>; ruf=mailto:<ruf-report@example.com>
   ```
2. **Review the reports** for at least a week and fix any legitimate senders that fail SPF or DKIM.
3. **Enforce:**
   ```
   v=DMARC1; p=reject; pct=100; rua=mailto:<rua-report@example.com>; ruf=mailto:<ruf-report@example.com>
   ```

For **parked domains**: `v=DMARC1; p=reject;`

For the **MOERA domain** (`tenant.onmicrosoft.com`): in the Microsoft 365 admin center, go to **Settings > Domains**, select the onmicrosoft.com domain, then **DNS records > + Add record**, and add a TXT record named `_dmarc`.

## Notes and limitations

- `Resolve-DnsName` is built into Windows 8 / Server 2012 and later. Use `nslookup -type=TXT _dmarc.domain` elsewhere.
- The script shows the records. Check the tag values against the criteria above.

## References

- https://learn.microsoft.com/en-us/defender-office-365/email-authentication-dmarc-configure
- https://learn.microsoft.com/en-us/defender-office-365/step-by-step-guides/how-to-enable-dmarc-reporting-for-microsoft-online-email-routing-address-moera-and-parked-domains
- https://media.defense.gov/2024/May/02/2003455483/-1/-1/0/CSA-NORTH-KOREAN-ACTORS-EXPLOIT-WEAK-DMARC.PDF
- https://www.rfc-editor.org/rfc/rfc7489
