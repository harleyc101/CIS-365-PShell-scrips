$params = @(
    'Identity',
    'EnableSafeLinksForEmail',
    'EnableSafeLinksForTeams',
    'EnableSafeLinksForOffice',
    'TrackClicks',
    'AllowClickThrough',
    'ScanUrls',
    'EnableForInternalSenders',
    'DeliverMessageAfterScan',
    'DisableUrlRewrite'
)
Get-SafeLinksPolicy | Select-Object -Property $params
