Get-MgReportAuthenticationMethodUserRegistrationDetail `
    -Filter "IsMfaCapable eq false and UserType eq 'Member'" |
    Format-Table UserPrincipalName, IsMfaCapable, IsAdmin
