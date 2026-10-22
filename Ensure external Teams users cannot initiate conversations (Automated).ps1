# Global (Org-wide default) external access policy
Get-CsExternalAccessPolicy -Identity Global | Format-List Identity, EnableTeamsConsumerInbound

# Optional passing state: organisation-wide setting
Get-CsTenantFederationConfiguration | Format-List AllowTeamsConsumerInbound
