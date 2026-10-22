# Ensure reauthentication with verification code is restricted (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.10  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure reauthentication with verification code is restricted (Automated).ps1`](./Ensure%20reauthentication%20with%20verification%20code%20is%20restricted%20(Automated).ps1)

## Why this is required

Guests who open shared content with an emailed **verification code** stay signed in for a period afterwards. The longer that period, the longer someone using a lost device, a shared computer or a hijacked session can keep accessing your files without proving who they are again.

Requiring reauthentication every **15 days or less** limits how long guest access lasts without a fresh check.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `EmailAttestationRequired` and `EmailAttestationReAuthDays`.

## Prerequisites

- The [SharePoint Online Management Shell](https://learn.microsoft.com/powershell/sharepoint/sharepoint-online/connect-sharepoint-online):
  ```powershell
  Install-Module Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-SPOService -Url https://<tenant>-admin.sharepoint.com   # replace <tenant> with your tenant name
  ```
- The SharePoint Online module works best in **Windows PowerShell 5.1**. In PowerShell 7, load it with `Import-Module Microsoft.Online.SharePoint.PowerShell -UseWindowsPowerShell`.
- You need the SharePoint Administrator or Global Administrator role. **Global Reader can't** connect to SharePoint Online PowerShell.

## Usage

```powershell
& ".\Ensure reauthentication with verification code is restricted (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EmailAttestationRequired` is `True` **and** `EmailAttestationReAuthDays` is `15` or less | **Pass.** |
| Not required, or more than 15 days | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing > More external sharing settings** and set **People who use a verification code must reauthenticate after this many days** to **15** or less.

**PowerShell:**
```powershell
Set-SPOTenant -EmailAttestationRequired $true -EmailAttestationReAuthDays 15
```

## Default value

`EmailAttestationRequired`: `False`, `EmailAttestationReAuthDays`: `30`

## Notes and limitations

- If Entra ID B2B integration is on (control 7.2.2), the SharePoint one-time-passcode experience is replaced by Entra ID guest sign-in.

## References

- https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off#change-the-organization-level-external-sharing-setting
- https://learn.microsoft.com/en-us/entra/external-id/one-time-passcode
