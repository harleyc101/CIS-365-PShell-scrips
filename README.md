# Ensure all forms of mail forwarding are blocked and/or disabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.2.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure all forms of mail forwarding are blocked and-or disabled (Automated).ps1`](./Ensure%20all%20forms%20of%20mail%20forwarding%20are%20blocked%20and-or%20disabled%20(Automated).ps1)

## Why this is required

One of the first things attackers do after compromising a mailbox is set up **automatic forwarding** to an external address, through an inbox rule, OWA forwarding, an out-of-office rule or Power Automate. They then get a silent copy of everything the user receives, often long after the password has been changed. Malicious insiders use the same technique to send sensitive data out.

Blocking automatic external forwarding centrally, with the outbound anti-spam policy and by making sure no transport rules redirect mail externally, closes all of these routes at once, whatever method the user or attacker tries.

## What the script does

1. **Step 1:** lists every transport (mail flow) rule that redirects messages, with the redirect address.
2. **Step 2:** lists every outbound anti-spam policy with its `AutoForwardingMode`.

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
& ".\Ensure all forms of mail forwarding are blocked and-or disabled (Automated).ps1"
```

## Interpreting the results

Both steps must pass.

| Output | Result |
| --- | --- |
| Step 1 returns nothing, or only internal addresses | Step 1 passes. |
| Step 1 lists a rule redirecting to an **external** domain | Step 1 **fails**. |
| Step 2 shows `AutoForwardingMode` = `Off` for every policy | Step 2 passes. |
| Any policy shows `Automatic` or `On` | Step 2 **fails**, unless it is a documented exception scoped to specific users. |

Only the highest-priority policy applies to each user, but check the **Default** policy too, in case a custom policy is removed later.

## Remediation

**Step 1 – Transport rules:** In the Exchange admin center, go to **Mail flow > Rules** and delete any rule that redirects to external domains, or run:
```powershell
Remove-TransportRule "<RuleName>"
```

**Step 2 – Outbound anti-spam:** In Microsoft Defender, go to **Policies & rules > Threat policies > Anti-spam > Anti-spam outbound policy (Default) > Edit protection settings** and set **Automatic forwarding rules** to **Off - Forwarding is disabled**. Repeat for any custom outbound policies.
```powershell
Set-HostedOutboundSpamFilterPolicy -Identity <policyName> -AutoForwardingMode Off

# Or for all outbound policies
Get-HostedOutboundSpamFilterPolicy | Set-HostedOutboundSpamFilterPolicy -AutoForwardingMode Off
```
If some users have a business need to forward, create a separate outbound policy for just them, as an approved exception.

## Notes and limitations

- Turning off forwarding to external domains affects every user. Check for legitimate business needs first.

## References

- https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/mail-flow-rules
- https://learn.microsoft.com/en-us/defender-office-365/outbound-spam-policies-external-email-forwarding
