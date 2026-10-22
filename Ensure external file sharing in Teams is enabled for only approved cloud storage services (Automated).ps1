$Params = @(
    'AllowDropbox'
    'AllowBox'
    'AllowGoogleDrive'
    'AllowShareFile'
    'AllowEgnyte'
)
Get-CsTeamsClientConfiguration -Identity Global | Format-List $Params
