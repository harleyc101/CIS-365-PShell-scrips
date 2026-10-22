# Ensure password protection is enabled for on-prem Active Directory (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.2.3.3  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure password protection is enabled for on-prem Active Directory (Automated).ps1`](./Ensure%20password%20protection%20is%20enabled%20for%20on-prem%20Active%20Directory%20(Automated).ps1)

## Why this is required

Entra Password Protection (the global and custom banned password lists) applies only to passwords changed **in the cloud** unless it is extended to on-premises Active Directory. In hybrid environments most password changes happen on-premises, through Ctrl+Alt+Del on domain-joined PCs, so without the on-premises agents weak and leaked passwords can still be set and then synced to the cloud.

Installing the Password Protection DC agent and proxy, and setting the mode to **Enforced**, applies the same banned-password checks to every AD password change.

## What the script does

1. Gets the Entra ID **Password Rule Settings** directory setting.
2. Shows its values, including `EnableBannedPasswordCheckOnPremises` and `BannedPasswordCheckOnPremisesMode`.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Directory.Read.All"
  ```

## Usage

```powershell
& ".\Ensure password protection is enabled for on-prem Active Directory (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableBannedPasswordCheckOnPremises` is `True` **and** `BannedPasswordCheckOnPremisesMode` is `Enforce` | **Pass.** |
| Mode is `Audit`, or the check is `False` | **Fail.** |

## Remediation

1. Download and install the **Microsoft Entra Password Protection proxy** and **DC agent** from https://www.microsoft.com/download/details.aspx?id=57071 on your domain controllers and proxy servers.
2. In the Entra admin center, go to **Entra ID > Authentication methods > Password protection**. Set **Enable password protection on Windows Server Active Directory** to **Yes** and **Mode** to **Enforced**.

Running in **Audit** mode for a while first lets you see how many passwords would be rejected.

## Default value

Enabled: **Yes**. Mode: **Audit**.

## Notes and limitations

- Applies to hybrid deployments only. It has no effect without on-premises Active Directory.

## References

- https://learn.microsoft.com/en-us/entra/identity/authentication/howto-password-ban-bad-on-premises-operations
