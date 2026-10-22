$DlpPolicy = Get-DlpCompliancePolicy
$DlpPolicy | Where-Object { $_.EnforcementPlanes -match "CopilotExperiences" } |
    Format-Table Name, Mode, LocationInclusions, LocationExclusions
