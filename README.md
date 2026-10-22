# Ensure users are restricted from recovering BitLocker keys (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.1.4.6  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure users are restricted from recovering BitLocker keys (Automated).ps1`](./Ensure%20users%20are%20restricted%20from%20recovering%20BitLocker%20keys%20(Automated).ps1)

## Why this is required

By default, users can look up the BitLocker recovery key for their own devices through self-service portals. If an attacker gets both a user's **credentials** and their **physical laptop**, for example through theft combined with phishing, they can retrieve the recovery key and decrypt the disk, which defeats BitLocker.

The recovery key is sensitive in its own right. Restricting self-service retrieval means a helpdesk or admin has to be involved and can verify the person's identity first.

## What the script does

1. Reads the tenant authorisation policy's default user role permissions.
2. Shows `AllowedToReadBitlockerKeysForOwnedDevice`.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Policy.Read.All"
  ```

## Usage

```powershell
& ".\Ensure users are restricted from recovering BitLocker keys (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `AllowedToReadBitlockerKeysForOwnedDevice` is `False` | **Pass.** |
| `True` | **Fail.** |

## Remediation

**UI:** In the Entra admin center, go to **Entra ID > Devices > Device settings**, set **Restrict users from recovering the BitLocker key(s) for their owned devices** to **Yes**, and save.

**PowerShell** (Needs `Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"`.):
```powershell
$params = @{
    defaultUserRolePermissions = @{
        AllowedToReadBitlockerKeysForOwnedDevice = $false
    }
}
Update-MgPolicyAuthorizationPolicy -BodyParameter $params
```

## Default value

No: users can recover their own BitLocker keys.

## Notes and limitations

- This adds helpdesk workload. During large incidents, such as the July 2024 CrowdStrike outage that put many devices into BitLocker recovery, it can slow recovery down. Have a documented process for bulk key retrieval ready.

## References

- https://learn.microsoft.com/en-us/entra/identity/devices/manage-device-identities#configure-device-settings
- https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/recovery-process#self-recovery
