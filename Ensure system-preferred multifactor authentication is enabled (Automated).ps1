$Uri = 'https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy'
(Invoke-MgGraphRequest -Method GET -Uri $Uri).systemCredentialPreferences
