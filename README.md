# Ensure that SPF records are published for all Exchange Domains (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.8  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure that SPF records are published for all Exchange Domains (Automated).ps1`](./Ensure%20that%20SPF%20records%20are%20published%20for%20all%20Exchange%20Domains%20(Automated).ps1)

## Why this is required

Sender Policy Framework (SPF) is a DNS record that lists which servers may send email for your domain. Receiving mail systems, including Exchange Online Protection, check it to decide whether a message claiming to be from your domain is genuine or **spoofed**.

Without SPF, or with an SPF record that doesn't end in a fail policy, anyone can send email that appears to come from your domain to your staff, customers and suppliers. Ending the record with `-all` (hard fail) or `~all` (soft fail) tells receivers to reject or flag mail from anywhere not listed.

Building the record also makes the organisation find out every system that sends email on its behalf. A sender you didn't know about is a security gap in itself.

## What the script does

1. Gets the organisation's accepted domains in Exchange Online, excluding the `*.onmicrosoft.com` initial domain and hybrid coexistence domain, which Microsoft manages.
2. Looks up the DNS TXT records for each domain with `Resolve-DnsName` and picks out the one starting `v=spf1`.
3. Shows each domain with its SPF record, or **NO SPF RECORD**.

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
& ".\Ensure that SPF records are published for all Exchange Domains (Automated).ps1"
```

## Interpreting the results

For each domain that sends email, the SPF record must:

1. Start with `v=spf1`.
2. End with `-all` (hard fail) or `~all` (soft fail). Other endings such as `?all` or `+all`, or no `all`, are **not** compliant.
3. If it uses `redirect=otherdomain`, the redirected record must end with `-all` or `~all`. Run `Resolve-DnsName otherdomain -Type TXT` to check it.

**Parked domains** (domains that never send mail) must have `v=spf1 -all`.

Compliant examples:
```
v=spf1 include:spf.protection.outlook.com -all
v=spf1 include:spf.protection.outlook.com ~all
v=spf1 -all                                    # parked domain
```
Any domain showing **NO SPF RECORD** **fails**.

## Remediation

In your DNS provider, add or update a TXT record at the root of each failing domain. If all mail goes through Exchange Online:
```
v=spf1 include:spf.protection.outlook.com -all
```
Add an `include:` for each other authorised sending service, for example:
```
v=spf1 include:spf.protection.outlook.com include:thirdparty.example.net -all
```
For parked domains, use `v=spf1 -all`.

## Notes and limitations

- `Resolve-DnsName` is built into Windows 8 / Server 2012 and later. Use `nslookup -type=TXT domain` elsewhere.
- The audit doesn't evaluate which `include:` entries are present, only that the record exists and ends with a fail qualifier.
- For GCC High / DoD use `spf.protection.office365.us`; for 21Vianet use `spf.protection.partner.outlook.cn`.

## References

- https://learn.microsoft.com/en-us/defender-office-365/email-authentication-spf-configure
- https://datatracker.ietf.org/doc/html/rfc7208
- https://learn.microsoft.com/en-us/defender-office-365/email-authentication-spf-configure#scenario-parked-domains
