# Ensure additional storage providers are restricted in Outlook on the web (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 6.5.3  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure additional storage providers are restricted in Outlook on the web (Automated).ps1`](./Ensure%20additional%20storage%20providers%20are%20restricted%20in%20Outlook%20on%20the%20web%20(Automated).ps1)

## Why this is required

By default, Outlook on the web lets users connect **third-party storage** such as Box, Dropbox, Google Drive and personal OneDrive, and attach or save files to and from them. Microsoft doesn't control those services' terms or privacy, and the organisation's DLP, retention and audit controls don't apply to them.

That creates two risks: **data leakage**, with company files ending up in personal cloud storage, and **malware**, with files coming in from untrusted storage. Turning this off keeps email attachments in organisation-managed storage.

## What the script does

1. Reads the **OwaMailboxPolicy-Default** policy and shows `AdditionalStorageProvidersAvailable`.

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
& ".\Ensure additional storage providers are restricted in Outlook on the web (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AdditionalStorageProvidersAvailable` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

```powershell
Set-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default -AdditionalStorageProvidersAvailable $false
```

## Default value

`AdditionalStorageProvidersAvailable`: `True`

## References

- https://learn.microsoft.com/en-us/powershell/module/exchange/set-owamailboxpolicy
- https://support.microsoft.com/en-us/topic/3rd-party-cloud-storage-services-supported-by-office-apps-fce12782-eccc-4cf5-8f4b-d1ebec513f72
