# Get-DkimSigningConfig does not display unconfigured domains,
# so we first get all accepted domains and then match them against
# the DKIM signing configurations.
$Domains = Get-AcceptedDomain |
    Where-Object { $_.IsCoExistenceDomain -eq $false -and $_.InitialDomain -eq $false }
$DKIMCfg = Get-DkimSigningConfig

# Generate the report
$Report = foreach ($Domain in $Domains) {
    $DKIM = $DKIMCfg | Where-Object { $_.Name -eq $Domain.Name }
    [PSCustomObject]@{
        DomainName     = $Domain.Name
        Enabled        = [bool]$DKIM.Enabled
        Status         = if ($DKIM) { $DKIM.Status } else { "Not Configured" }
        IsCISCompliant = ($DKIM.Enabled -and $DKIM.Status -eq "Valid")
    }
}

# Output the report
$Report | Format-Table -AutoSize

# Optionally, export the report to a CSV file
# $Report | Export-Csv -Path "2_1_9.csv" -NoTypeInformation
