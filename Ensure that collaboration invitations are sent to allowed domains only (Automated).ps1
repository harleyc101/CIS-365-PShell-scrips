$Uri = "https://graph.microsoft.com/beta/legacy/policies"
$Response = (Invoke-MgGraphRequest -Uri $Uri).value |
    Where-Object { $_.type -eq 'B2BManagementPolicy' }

if ($Response) {
    $Definition = $Response.definition | ConvertFrom-Json
    $DomainsPolicy = $Definition.B2BManagementPolicy.InvitationsAllowedAndBlockedDomainsPolicy
} else {
    Write-Output "No policy found."
    return
}

$DomainsPolicy
