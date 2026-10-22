# Ensure DLP policies are published for Copilot users (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 3.2.3  
**Profile:** E5 Level 1  
**Script:** [`Ensure DLP policies are published for Copilot users (Automated).ps1`](./Ensure%20DLP%20policies%20are%20published%20for%20Copilot%20users%20(Automated).ps1)

## Why this is required

Microsoft 365 Copilot can find, summarise and generate content from **everything the signed-in user has access to** across SharePoint, OneDrive, Teams and Exchange. That includes files the user may have been given access to by mistake and would never have found on their own.

Without a DLP policy scoped to Copilot, there's no technical control stopping sensitive data such as PII, financial records or health data from being pulled into Copilot answers and shown to people. A DLP policy for **Microsoft 365 Copilot and Copilot Chat** stops Copilot processing or surfacing content that contains the sensitive information types you define.

## What the script does

1. Gets every DLP policy and keeps those whose enforcement planes include **CopilotExperiences**.
2. Shows each policy's name, mode, location inclusions and exclusions.

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
& ".\Ensure DLP policies are published for Copilot users (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| No output | **Fail.** No DLP policy covers Copilot. |
| A policy shows `Mode` = `Enable`, `LocationInclusions` includes `All`, and `LocationExclusions` contains only permitted exceptions | **Pass.** Also check that its rules cover the organisation's sensitive data. |
| Policies are listed but in test mode, disabled, or not applied to all accounts | **Fail.** |

## Remediation

Some tenants have **Default DLP policy - Protect sensitive M365 Copilot interactions**, or can create it with a guided wizard in **Purview > Data loss prevention > Policies**. That policy counts if it meets the criteria above.

To create a custom policy:
1. In Purview, go to **Data loss prevention > Policies > + Create policy > Enterprise applications & devices > Custom > Custom policy**.
2. Name it and select the **Microsoft 365 Copilot and Copilot Chat** location.
3. Choose **+ Create rule**, add the condition **Content contains > Sensitive info types**, and choose the types to protect.
4. Add the action **Restrict Copilot from processing content**.
5. Choose **Turn it on right away** and submit.

The control isn't met until the policy is in **enforcement** mode, not simulation. Tell users before enforcing, because Copilot will refuse some prompts.

## Default value

Most tenants have no Copilot DLP policy. Some have the automatically created default policy.

## Notes and limitations

- Requires Microsoft 365 Copilot licensing and E5 / Purview DLP.

## References

- https://learn.microsoft.com/en-us/purview/dlp-microsoft365-copilot-location-learn-about
- https://learn.microsoft.com/en-us/purview/dlp-microsoft365-copilot-location-default-policy
