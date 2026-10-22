$PwRuleSettings = '5cf42378-d67d-4f36-ba46-e8b86229381d'
Get-MgGroupSetting | Where-Object TemplateId -eq $PwRuleSettings |
    Select-Object -ExpandProperty Values
