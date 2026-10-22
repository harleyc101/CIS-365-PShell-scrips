# Check whether external calendar sharing is enabled in the default sharing policy
Get-SharingPolicy -Identity "Default Sharing Policy" | Format-Table Name, Enabled

# Optional: list mailboxes that are currently publishing their calendar externally.
# Useful to run before disabling the feature, to see who will be affected.
$mailboxes = Get-Mailbox -ResultSize Unlimited
foreach ($mailbox in $mailboxes) {
    # Get the name of the default calendar folder (depends on the mailbox's language)
    $calendarFolder = [string](Get-EXOMailboxFolderStatistics $mailbox.PrimarySmtpAddress -FolderScope Calendar |
        Where-Object { $_.FolderType -eq 'Calendar' }).Name

    # Get users calendar folder settings for their default Calendar folder
    # calendar has the format identity:\<calendar folder name>
    $calendar = Get-MailboxCalendarFolder -Identity "$($mailbox.PrimarySmtpAddress):\$calendarFolder"

    if ($calendar.PublishEnabled) {
        Write-Host -ForegroundColor Yellow "Calendar publishing is enabled for $($mailbox.PrimarySmtpAddress) on $($calendar.PublishedCalendarUrl)"
    }
}
