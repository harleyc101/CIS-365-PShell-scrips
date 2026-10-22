$uri = 'https://graph.microsoft.com/beta/admin/forms/settings'
Invoke-MgGraphRequest -Uri $uri | Select-Object isInOrgFormsPhishingScanEnabled
