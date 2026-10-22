# Ensure comprehensive attachment filtering is applied (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.11  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure comprehensive attachment filtering is applied (Automated).ps1`](./Ensure%20comprehensive%20attachment%20filtering%20is%20applied%20(Automated).ps1)

## Why this is required

Microsoft's default attachment filter blocks 53 file types (control 2.1.2). Attackers regularly use many more formats to deliver malware and phishing: archives (`7z`, `rar`, `gz`), disk images (`vhd`, `dmg`), legacy Office formats with macros (`doc`, `xls`, `ppt`), scripts (`ps1`, `py`, `js`), HTML smuggling (`htm`, `html`, `svg`), shortcut and settings files, and more.

This Level 2 control asks for a **comprehensive** filter of about 186 extensions. Blocking everything your business doesn't need by email, and allow-listing only what it does, greatly reduces the routes for malware and business email compromise.

## What the script does

1. Defines the benchmark's reference list of about 186 high-risk extensions.
2. Gets all anti-malware policies and rules.
3. Considers only policies with **more than 120** file types, so policies that aren't meant for extension filtering are ignored. If there are none, it prints `## FAIL ##` and stops.
4. For each of those policies, works out which reference extensions are missing and finds the matching rule.
5. Marks a policy `IsCISCompliant` if fewer than 10% of the reference extensions are missing, its rule is `Enabled`, and `EnableFileFilter` is `True`.
6. Shows a table with the policy name, compliance, filter state, rule state, number and list of missing extensions, and total extension count. Commented-out lines show how to export to grid view, CSV or JSON.

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
& ".\Ensure comprehensive attachment filtering is applied (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `## FAIL ## No comprehensive policies found to evaluate.` | **Fail.** No policy has more than 120 extensions. |
| A policy with `IsCISCompliant` = `True` | **Pass.** Review `MissingExtensions` and confirm each is a documented business exception. |
| Policies listed but none show `IsCISCompliant` = `True` | **Fail.** Check the rule state, `EnableFileFilter` and missing extensions. |

## Remediation

This script creates a Level 2 policy and a rule covering all accepted domains. The rule is created **disabled** so you can review it before turning it on. Edit `InternalSenderAdminAddress` first.

```powershell
# Create an attachment policy and associated rule. The rule is
# intentionally disabled allowing the org to enable it when ready
$Policy = @{
    Name                                   = "CIS L2 Attachment Policy"
    EnableFileFilter                       = $true
    ZapEnabled                             = $true
    EnableInternalSenderAdminNotifications = $true
    InternalSenderAdminAddress             = 'admin@contoso.com' # Change this.
}
# Use the same extension list as $AttachExts in the audit script
New-MalwareFilterPolicy @Policy -FileTypes $AttachExts

# Create the rule for all accepted domains
$Rule = @{
    Name                = $Policy.Name
    Enabled             = $false
    MalwareFilterPolicy = $Policy.Name
    RecipientDomainIs   = (Get-AcceptedDomain).Name
    Priority            = 0
}
New-MalwareFilterRule @Rule
```
When you're ready, enable the rule in Microsoft Defender (**Policies & rules > Threat policies > Anti-malware**) or with `Enable-MalwareFilterRule`.

## Default value

Only Microsoft's 53 default extensions are blocked (see control 2.1.2).

## Notes and limitations

- The action taken on a match (reject with NDR or quarantine) and the quarantine policy are left to the organisation and aren't scored.
- Each missing extension should be justified by a documented business need.

## References

- https://learn.microsoft.com/en-us/powershell/module/exchange/get-malwarefilterpolicy
- https://learn.microsoft.com/en-us/defender-office-365/anti-malware-policies-configure
- https://learn.microsoft.com/en-us/office/compatibility/office-file-format-reference
