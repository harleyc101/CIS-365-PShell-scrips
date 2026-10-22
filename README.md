# Ensure DLP policies are enabled for Microsoft Teams (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 3.2.2  
**Profile:** E5 Level 1  
**Script:** [`Ensure DLP policies are enabled for Microsoft Teams (Automated).ps1`](./Ensure%20DLP%20policies%20are%20enabled%20for%20Microsoft%20Teams%20(Automated).ps1)

## Why this is required

Teams chats and channel messages are a common place for sensitive data to be shared casually, such as a card number pasted into a chat or customer details posted in a channel that includes guests. Email DLP doesn't cover them.

A DLP policy covering Teams detects and blocks sensitive information in Teams messages. Microsoft creates a *Default policy for Teams* in many tenants, which detects credit card numbers. At a minimum, something should be in place, and ideally it should be tuned to the data the organisation cares about.

## What the script does

1. Gets every DLP policy and keeps those whose workload includes **Teams**.
2. Shows each policy's name, mode and Teams locations and exceptions.

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
& ".\Ensure DLP policies are enabled for Microsoft Teams (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| No output | **Fail.** No DLP policy covers Teams. |
| A policy shows `Mode` = `Enable`, `TeamsLocation` includes `All`, and `TeamsLocationException` contains only permitted exceptions | **Pass.** |
| Policies are listed but are in test mode, disabled, or not applied to all accounts | **Fail.** |

## Remediation

In Microsoft Purview, go to **Solutions > Data loss prevention > Policies**, select **Default policy for Teams** and choose **Edit policy**:

1. Turn on the **Teams chat and channel messages** location.
2. Make sure the **Default Teams DLP policy rule** (or your own rule) is **On**.
3. Under *Policy mode*, choose **Turn it on right away** and submit.

If the tenant has no default Teams policy (older tenants may not), create a new policy covering Teams with rules for credit cards, PII and other data that matters to the organisation.

## Default value

Enabled (On), where the default policy exists.

## Notes and limitations

- Requires E5 or the E5 Compliance add-on for Teams DLP.

## References

- https://learn.microsoft.com/en-us/purview/dlp-teams-default-policy
- https://learn.microsoft.com/en-us/powershell/module/exchange/connect-ippssession
