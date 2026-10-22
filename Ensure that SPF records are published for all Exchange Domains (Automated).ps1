# STEP 1: Determine the list of domains to audit
# (excludes the initial *.onmicrosoft.com and hybrid coexistence domains)
$Domains = Get-AcceptedDomain |
    Where-Object { $_.IsCoExistenceDomain -eq $false -and $_.InitialDomain -eq $false }

# STEP 2: Look up the SPF (TXT) record for each domain
foreach ($Domain in $Domains) {
    $Spf = Resolve-DnsName $Domain.DomainName -Type TXT -ErrorAction SilentlyContinue |
        Where-Object { $_.Strings -match '^v=spf1' }
    [PSCustomObject]@{
        Domain    = $Domain.DomainName
        SPFRecord = if ($Spf) { $Spf.Strings -join '' } else { '** NO SPF RECORD **' }
    }
}
