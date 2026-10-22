# STEP 1: Determine the list of domains to audit
# (includes the initial *.onmicrosoft.com (MOERA) domain, excludes the hybrid coexistence domain)
$Domains = Get-AcceptedDomain | Where-Object { $_.IsCoExistenceDomain -eq $false }

# STEP 2: Look up the DMARC record for each domain
foreach ($Domain in $Domains) {
    $Dmarc = Resolve-DnsName "_dmarc.$($Domain.DomainName)" -Type TXT -ErrorAction SilentlyContinue |
        Where-Object { $_.Strings -match '^v=DMARC1' }
    [PSCustomObject]@{
        Domain      = $Domain.DomainName
        DMARCRecord = if ($Dmarc) { $Dmarc.Strings -join '' } else { '** NO DMARC RECORD **' }
    }
}
