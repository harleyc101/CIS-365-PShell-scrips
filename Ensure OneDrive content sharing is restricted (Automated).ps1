Get-SPOTenant | Format-List OneDriveSharingCapability

# Alternative check against the OneDrive site itself, in case
# OneDriveSharingCapability isn't available in your tenant yet.
$OneDriveSite = Get-SPOSite -Filter { Url -like "*-my.sharepoint.com/" }
Get-SPOSite -Identity $OneDriveSite | Format-List Url, SharingCapability
