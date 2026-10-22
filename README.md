# Ensure Information Protection sensitivity label policies are published (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 3.3.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure Information Protection sensitivity label policies are published (Automated).ps1`](./Ensure%20Information%20Protection%20sensitivity%20label%20policies%20are%20published%20(Automated).ps1)

## Why this is required

Sensitivity labels let people and automated rules classify content as, for example, *Public*, *Internal*, *Confidential* or *Highly Confidential*. The label then goes with the file or email and can enforce protection automatically, such as encryption, access restrictions, watermarks and headers, and controls on Teams, groups and SharePoint sites.

Labels only work once they have been **published** to users through a label policy. Consistent labelling reduces the risk of data loss, makes DLP and incident response more effective, and helps meet regulatory requirements.

## What the script does

1. Gets all label policies and keeps those of type `PublishedSensitivityLabel`.
2. If any exist, shows each policy's name and locations and prints how many were found. Otherwise prints *No Sensitivity Label policies found*.

## Prerequisites

- The [Exchange Online PowerShell module](https://learn.microsoft.com/powershell/exchange/exchange-online-powershell-v2):
  ```powershell
  Install-Module ExchangeOnlineManagement -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-IPPSSession
  ```

## Usage

```powershell
& ".\Ensure Information Protection sensitivity label policies are published (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| "No Sensitivity Label policies found" | **Fail.** |
| One or more policies found, with locations that match the organisation's needs | **Pass.** |

## Remediation

In [Microsoft Purview](https://purview.microsoft.com), go to **Information protection > Sensitivity labels**, choose **Create a label** for each classification level, then **Publish labels** to the relevant users and groups.

## Default value

The "Global sensitivity label policy" exists by default.

## Notes and limitations

- Whether the published policies are *adequate* is a judgement for the auditor, based on the organisation's information protection needs.
- Labels that apply encryption can affect sharing with guests and external recipients. Test before rolling out widely.

## References

- https://learn.microsoft.com/en-us/purview/sensitivity-labels
- https://learn.microsoft.com/en-us/purview/create-sensitivity-labels
