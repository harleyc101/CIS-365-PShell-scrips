$Policies = Get-LabelPolicy -WarningAction Ignore |
    Where-Object { $_.Type -eq "PublishedSensitivityLabel" }

if ($Policies) {
    $Policies | Format-List -Property Name, *Location*
    Write-Host "$($Policies.Count) Sensitivity Label policies found."
} else {
    Write-Host "No Sensitivity Label policies found"
}
