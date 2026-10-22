$SP = Get-MgServicePrincipal -Filter "appId eq 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e'"

if ((-not $SP) -or $SP.AccountEnabled) {
    Write-Host "Audit Result: ** FAIL **"
} else {
    Write-Host "Audit Result: ** PASS **"
}
