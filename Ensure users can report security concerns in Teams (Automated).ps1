# Teams: users can report messages as a security concern
Get-CsTeamsMessagingPolicy -Identity Global | Format-List AllowSecurityEndUserReporting

# Defender: where reported messages are sent
Get-ReportSubmissionPolicy | Format-List Report*
