# Ensure external sharing is restricted by security group (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 7.2.8  
**Profile:** E3 Level 2, E5 Level 2  
**Script:** [`Ensure external sharing is restricted by security group (Automated).ps1`](./Ensure%20external%20sharing%20is%20restricted%20by%20security%20group%20(Automated).ps1)

## Why this is required

By default **every** user can share SharePoint and OneDrive content externally, so a single compromised account or malicious insider can exfiltrate data simply by sharing files out.

Limiting external sharing to members of **specific, approved Entra ID security groups** means only people who have been reviewed and authorised for external collaboration can do it. That shrinks the attack surface for data exfiltration through sharing.

## What the script does

1. Reads the SharePoint Online tenant settings and shows `SharingCapability` and `WhoCanShareAuthenticatedGuestAllowList`.

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
& ".\Ensure external sharing is restricted by security group (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `SharingCapability` is `Disabled` | **Pass.** No external sharing at all. |
| `WhoCanShareAuthenticatedGuestAllowList` contains at least one security group GUID | **Pass.** |
| `WhoCanShareAuthenticatedGuestAllowList` is empty and sharing isn't disabled | **Fail.** |

## Remediation

**UI:** In the SharePoint admin center, go to **Policies > Sharing > More external sharing settings**. Tick **Allow only users in specific security groups to share externally**, then use **Manage security groups** to add at least one group.

**PowerShell:**
```powershell
Set-SPOTenant -WhoCanShareAuthenticatedGuestAllowList "<GroupObjectId>"
# Multiple groups: "<GroupObjectId1>","<GroupObjectId2>"
```
Fill the groups **before** turning this on, or all external sharing will be blocked. Members must also be allowed to invite guests in Entra ID (**External Identities > External collaboration settings**).

## Default value

Not restricted: anyone in the organisation can share externally, within the limit of the sharing slider.

## Notes and limitations

- Existing external sharing links created by users outside the groups keep working.

## References

- https://learn.microsoft.com/en-us/sharepoint/manage-security-groups
- https://learn.microsoft.com/en-us/powershell/module/microsoft.online.sharepoint.powershell/set-spotenant
