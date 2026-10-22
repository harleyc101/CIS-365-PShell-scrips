$DlpPolicy = Get-DlpCompliancePolicy
$DlpPolicy | Where-Object { $_.Workload -match "Teams" } |
    Format-Table Name, Mode, TeamsLocation*
