Get-OwaMailboxPolicy | Where-Object { $_.IsDefault } |
    Format-List PersonalAccountsEnabled, PersonalAccountCalendarsEnabled
