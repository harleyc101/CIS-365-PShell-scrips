# Global (Org-wide default) external access policy
Get-CsExternalAccessPolicy -Identity Global | Format-List Identity, EnableFederationAccess

# Optional passing state: organisation-wide federation settings
Get-CsTenantFederationConfiguration | Format-List AllowFederatedUsers, AllowedDomains
