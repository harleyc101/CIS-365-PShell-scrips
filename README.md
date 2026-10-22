# Ensure Safe Links for Office Applications is Enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.1  
**Profile:** E5 Level 2  
**Script:** [`Ensure Safe Links for Office Applications is Enabled (Automated).ps1`](./Ensure%20Safe%20Links%20for%20Office%20Applications%20is%20Enabled%20(Automated).ps1)

## Why this is required

Phishing links don't only arrive in email bodies. They are also embedded in Word, Excel and PowerPoint files and Teams messages, and attackers often make a link malicious only **after** the message has been delivered and passed initial scanning.

Safe Links in Microsoft Defender for Office 365 checks every URL **at the moment it is clicked**, in email, Teams and Office apps, and blocks it if it's now known to be malicious. With click tracking on and click-through off, users can't bypass the warning, and the security team can see who clicked what during an investigation.

## What the script does

1. Gets every Safe Links policy with `Get-SafeLinksPolicy`.
2. Shows the settings the benchmark checks for each policy: Safe Links for email, Teams and Office; click tracking; click-through; real-time URL scanning; internal senders; waiting for the scan before delivery; and URL rewriting.

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
& ".\Ensure Safe Links for Office Applications is Enabled (Automated).ps1"
```

## Interpreting the results

At least one policy, and it must be the **highest-priority** policy that applies to users, must match **all** of these values:

| Property | Required value |
| --- | --- |
| `EnableSafeLinksForEmail` | `True` |
| `EnableSafeLinksForTeams` | `True` |
| `EnableSafeLinksForOffice` | `True` |
| `TrackClicks` | `True` |
| `AllowClickThrough` | `False` |
| `ScanUrls` | `True` |
| `EnableForInternalSenders` | `True` |
| `DeliverMessageAfterScan` | `True` |
| `DisableUrlRewrite` | `False` |

If no policy matches every value, the control **fails**. E5 tenants also have built-in protection policies; check which policy you are looking at.

## Remediation

**UI:** In [Microsoft Defender](https://security.microsoft.com), go to **Email & collaboration > Policies & rules > Threat policies > Safe Links**, choose **+ Create**, select all valid domains, and set the protection settings to the values above.

**PowerShell** creates a policy and a rule at the highest priority that covers all accepted domains:
```powershell
# Create the Policy
$params = @{
    Name                     = "CIS SafeLinks Policy"
    EnableSafeLinksForEmail  = $true
    EnableSafeLinksForTeams  = $true
    EnableSafeLinksForOffice = $true
    TrackClicks              = $true
    AllowClickThrough        = $false
    ScanUrls                 = $true
    EnableForInternalSenders = $true
    DeliverMessageAfterScan  = $true
    DisableUrlRewrite        = $false
}
New-SafeLinksPolicy @params

# Create the rule for all users in all valid domains and associate with Policy
New-SafeLinksRule -Name "CIS SafeLinks" -SafeLinksPolicy "CIS SafeLinks Policy" -RecipientDomainIs (Get-AcceptedDomain).Name -Priority 0
```

## Notes and limitations

- Requires Microsoft Defender for Office 365 Plan 1 or 2, which is included in E5.
- To see policy priority, use `Get-SafeLinksRule`. Strict and Standard preset policies always take priority over custom policies.
- Users may notice a short delay when clicking links in Office documents.

## References

- https://learn.microsoft.com/en-us/defender-office-365/safe-links-policies-configure
- https://learn.microsoft.com/en-us/powershell/module/exchange/set-safelinkspolicy
- https://learn.microsoft.com/en-us/defender-office-365/preset-security-policies
