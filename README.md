# Ensure that password hash sync is enabled for hybrid deployments (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.8.1  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure that password hash sync is enabled for hybrid deployments (Automated).ps1`](./Ensure%20that%20password%20hash%20sync%20is%20enabled%20for%20hybrid%20deployments%20(Automated).ps1)

## Why this is required

Password hash synchronisation (PHS) sends Entra ID a **hash of the hash** of each user's on-premises password. Entra Connect takes the NT (MD4) hash, puts it through a salted SHA-256 key derivation, and only that result goes to the cloud, so it **can't be used for on-premises pass-the-hash** even if stolen. Benefits:

- **Leaked credential detection:** Entra ID Protection can compare your users' passwords against credentials found on the dark web and in public breach dumps, which needs PHS.
- **Resilience:** users can still sign in to Microsoft 365 if the on-premises network, AD FS or pass-through authentication agents are down. That matters a great deal during incidents such as ransomware.
- One password for users to manage across on-premises and cloud.

## What the script does

1. Runs `Get-ADSyncAADCompanyFeature` on the Entra Connect server, which shows the sync features enabled for the tenant, including `PasswordHashSync`.

## Prerequisites

- Run the script **on the on-premises server that hosts Microsoft Entra Connect**. It uses the `ADSync` module that is installed with Entra Connect.
- Applies only to **hybrid** tenants that use Entra Connect. Not applicable to cloud-only or federated deployments.

## Usage

```powershell
& ".\Ensure that password hash sync is enabled for hybrid deployments (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `PasswordHashSync` is `True` | **Pass.** |
| `False` | **Fail.** |

## Remediation

On the Entra Connect server:
1. Open **Azure AD Connect / Microsoft Entra Connect** and choose **Configure**.
2. Choose **Customize synchronization options** and sign in as a Global Administrator.
3. Go through *Connect your directories* and *Domain and OU filtering*.
4. On **Optional features**, tick **Password hash synchronization**.
5. Choose **Configure**, then **Exit**.

## Default value

Entra Connect sync is off by default. PHS is Microsoft's recommended setting for new deployments.

## Notes and limitations

- You can also check from the cloud: in the Entra admin center, go to **Entra ID > Entra Connect > Connect Sync** (this needs Global Admin or Hybrid Identity Admin), or call Graph `GET v1.0/directory/onPremisesSynchronization` and check `features.passwordSyncEnabled`.
- Some sectors have regulations that prevent password hashes leaving the premises.

## References

- https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/whatis-phs
- https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-password-hash-synchronization
