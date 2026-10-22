# Step 1 - Ensure Idle session timeout is configured
$TimeoutPolicy = Get-MgPolicyActivityBasedTimeoutPolicy
$BenchmarkTimeSpan = [TimeSpan]::Parse('03:00:00') # 3 hours

if ($TimeoutPolicy) {
    $PolicyDefinition = $TimeoutPolicy.Definition | ConvertFrom-Json
    $Timeout = $PolicyDefinition.ActivityBasedTimeoutPolicy.ApplicationPolicies[0].WebSessionIdleTimeout
    $TimeSpan = [TimeSpan]::Parse($Timeout)
    $TimeoutReadable = "{0} days, {1} hours, {2} minutes" `
        -f $TimeSpan.Days, $TimeSpan.Hours, $TimeSpan.Minutes
    if ($TimeSpan -le $BenchmarkTimeSpan) {
        Write-Host "** PASS ** Timeout is set to $TimeoutReadable."
    } else {
        Write-Host "** FAIL ** Timeout is too long. It is set to $TimeoutReadable."
    }
} else {
    Write-Host "** FAIL **: Idle session timeout is not configured."
}

# Step 2 - Ensure the Conditional Access policy is in place
# Filter to policies with "Use app enforced restrictions" enabled
$Caps = Get-MgIdentityConditionalAccessPolicy -All |
    Where-Object { $_.SessionControls.ApplicationEnforcedRestrictions.IsEnabled }

$CapReport = [System.Collections.Generic.List[Object]]::new()

# Loop through policies and generate a per policy report.
foreach ($policy in $Caps) {
    $Name = $policy.DisplayName
    $Users = $policy.Conditions.Users.IncludeUsers
    $Targets = $policy.Conditions.Applications.IncludeApplications
    $ClientApps = $policy.Conditions.ClientAppTypes
    $Restrictions = $policy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled
    $State = $policy.State

    $CountPass = $Targets.count -eq 1 -and $ClientApps.count -eq 1
    $Pass = $Targets -eq 'Office365' -and $ClientApps -eq 'browser' -and
        $Restrictions -and $CountPass -and $State -eq 'enabled'

    $obj = [PSCustomObject]@{
        DisplayName             = $Name
        AuditState              = if ($Pass) { "PASS" } else { "FAIL" }
        IncludeUsers            = $Users
        IncludeApplications     = $Targets
        ClientAppTypes          = $ClientApps
        AppEnforcedRestrictions = $Restrictions
        State                   = $State
    }
    $CapReport.Add($obj)
}

if ($Caps) {
    $CapReport
} else {
    Write-Host "** FAIL **: There are no qualifying conditional access policies."
}
