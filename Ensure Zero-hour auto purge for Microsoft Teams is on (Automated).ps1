Get-TeamsProtectionPolicy | Format-List ZapEnabled

# Any exclusions from ZAP for Teams (no output = no exclusions)
Get-TeamsProtectionPolicyRule | Format-List ExceptIf*
