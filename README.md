# Ensure the Common Attachment Types Filter is enabled (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 2.1.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure the Common Attachment Types Filter is enabled (Automated).ps1`](./Ensure%20the%20Common%20Attachment%20Types%20Filter%20is%20enabled%20(Automated).ps1)

## Why this is required

Email is one of the main ways malware gets in. Ransomware loaders, trojans and remote-access tools are routinely sent as executables, scripts and installers: `.exe`, `.vbs`, `.bat`, `.msi`, `.iso`, `.lnk` and so on. These file types have almost no legitimate use in email.

The Common Attachment Types Filter blocks these extensions at the mail gateway, before the message reaches a mailbox. That reduces the attack surface before endpoint antivirus or EDR has to respond.

## What the script does

1. Shows the full settings of the **Default** anti-malware policy with `Get-MalwareFilterPolicy -Identity Default`.
2. Compares the policy's `FileTypes` against Microsoft's default list of 53 high-risk extensions, which comes from the benchmark's Default Value section.
3. Prints the `EnableFileFilter` value and any default extensions that are missing from the policy.

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
& ".\Ensure the Common Attachment Types Filter is enabled (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableFileFilter` is `True` and **Missing default file types (0)** | **Pass.** |
| `EnableFileFilter` is `False` | **Fail.** The filter is off. |
| One or more default file types are listed as missing | **Fail.** Add them back to the policy. |

## Remediation

**UI:** In Microsoft Defender, go to **Email & collaboration > Policies & rules > Threat policies > Anti-malware > Default (Default)**, choose **Edit protection settings**, and tick **Enable the common attachments filter**. If any default file types are missing, add them with **Select file types**.

**PowerShell:**
```powershell
Set-MalwareFilterPolicy -Identity Default -EnableFileFilter $true
```
To add missing file types, get the existing list first and append to it. `-FileTypes` **replaces** the whole list.
```powershell
$Current = (Get-MalwareFilterPolicy -Identity Default).FileTypes
Set-MalwareFilterPolicy -Identity Default -FileTypes ($Current + @("missing1", "missing2"))
```

## Default value

`EnableFileFilter`: `True`, with the 53 extensions listed in the script.

## Notes and limitations

- Only the **Default** policy is audited. Custom anti-malware policies aren't required for compliance.
- If a team needs a blocked file type, create a scoped custom policy with higher priority for them rather than weakening the Default policy.

## References

- https://learn.microsoft.com/en-us/powershell/module/exchange/get-malwarefilterpolicy
- https://learn.microsoft.com/en-us/defender-office-365/anti-malware-policies-configure
