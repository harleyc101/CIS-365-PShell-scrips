$MBXData = Get-MailboxAuditBypassAssociation -ResultSize unlimited
$Report = $MBXData | Where-Object { $_.AuditBypassEnabled -eq $true } |
    Select-Object Name, AuditBypassEnabled
$Report

<# Optional: Export methods
$Report | Out-GridView -Title "Mailbox Audit Bypass Association"
$Report | Export-Csv -Path "6.1.3.csv" -NoTypeInformation
#>
