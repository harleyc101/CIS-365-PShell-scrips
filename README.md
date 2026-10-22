# Ensure DLP policies are enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 3.2.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure DLP policies are enabled (Automated).ps1`](./Ensure%20DLP%20policies%20are%20enabled%20(Automated).ps1)

## Why this is required

Data Loss Prevention (DLP) policies scan content in Exchange email, SharePoint, OneDrive and Teams for sensitive information, such as credit card numbers, national insurance or social security numbers, bank details, passwords and health data. They then warn the user, block the action, or alert administrators when that data is about to be shared inappropriately.

Most data leaks are accidental: a spreadsheet emailed to the wrong person, or a file shared with "anyone with the link". DLP catches these before the data leaves the organisation and makes users aware of what is sensitive.

## What the script does

1. Gets every DLP policy from Microsoft Purview with `Get-DlpCompliancePolicy`.
2. Shows each policy's name, mode and the locations it covers (Exchange, SharePoint, OneDrive and Teams).

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
& ".\Ensure DLP policies are enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| At least one policy has `Mode` = `Enable` **and** at least one location (`ExchangeLocation`, `SharePointLocation`, `OneDriveLocation` or `TeamsLocation`) defined | **Pass.** |
| No policies, or every policy is in test mode, disabled, or has no locations | **Fail.** |

## Remediation

In [Microsoft Purview](https://purview.microsoft.com), go to **Solutions > Data loss prevention > Policies > Create policy**. Build a policy for the types of data the organisation needs to protect, apply it to the relevant locations, and turn it on.

## Notes and limitations

- Which DLP policies you need depends on your industry. At a minimum, consider payment card data, national ID numbers and locally relevant PII.
- Test new policies in simulation mode before enforcing them.

## References

- https://learn.microsoft.com/en-us/purview/dlp-learn-about-dlp
