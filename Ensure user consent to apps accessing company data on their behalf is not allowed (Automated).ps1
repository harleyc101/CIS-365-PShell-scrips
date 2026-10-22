(Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions |
    Select-Object -ExpandProperty PermissionGrantPoliciesAssigned
