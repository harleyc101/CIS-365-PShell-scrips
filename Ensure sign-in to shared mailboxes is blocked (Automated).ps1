$MBX = Get-EXOMailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited

$MBX | ForEach-Object {
    Get-MgUser -UserId $_.ExternalDirectoryObjectId -Property DisplayName, UserPrincipalName, AccountEnabled
} | Format-Table DisplayName, UserPrincipalName, AccountEnabled
