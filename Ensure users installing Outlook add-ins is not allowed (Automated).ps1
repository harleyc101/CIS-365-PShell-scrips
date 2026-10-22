$RoleList = @(
    "My Custom Apps", "My Marketplace Apps", "My ReadWriteMailbox Apps"
)

$DefaultPolicy = Get-RoleAssignmentPolicy |
    Where-Object { $_.IsDefault -eq $true }

$NonCompliantRoles = $DefaultPolicy.AssignedRoles |
    Where-Object { $_ -in $RoleList }

Write-Host "Checking Default Role Assignment Policy: $($DefaultPolicy.Name)"
if ($NonCompliantRoles) {
    "Non-compliant - the following roles are assigned: " + ($NonCompliantRoles -join ", ")
} else {
    "Compliant - no add-in roles are assigned to the default policy."
}
