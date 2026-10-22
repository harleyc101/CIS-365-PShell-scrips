$AdminActions = @(
    "ApplyRecord", "Copy", "Create", "FolderBind", "HardDelete",
    "MailItemsAccessed", "Move", "MoveToDeletedItems", "SendAs",
    "SendOnBehalf", "Send", "SoftDelete", "Update",
    "UpdateCalendarDelegation", "UpdateFolderPermissions",
    "UpdateInboxRules"
)
$DelegateActions = @(
    "ApplyRecord", "Create", "FolderBind", "HardDelete", "Move",
    "MailItemsAccessed", "MoveToDeletedItems", "SendAs", "SendOnBehalf",
    "SoftDelete", "Update", "UpdateFolderPermissions", "UpdateInboxRules"
)
$OwnerActions = @(
    "ApplyRecord", "Create", "HardDelete", "MailboxLogin", "Move",
    "MailItemsAccessed", "MoveToDeletedItems", "Send", "SoftDelete",
    "Update", "UpdateCalendarDelegation", "UpdateFolderPermissions",
    "UpdateInboxRules"
)

function VerifyActions {
    param (
        [array]$ExpectedActions,
        [array]$ActualActions
    )
    $Missing = $ExpectedActions | Where-Object { $_ -notin $ActualActions }
    return $Missing
}

$MBX = Get-EXOMailbox -PropertySets Audit, Minimum -ResultSize Unlimited |
    Where-Object { $_.RecipientTypeDetails -eq "UserMailbox" }

$Results = foreach ($mailbox in $MBX) {
    $AdminMissing = VerifyActions -ExpectedActions $AdminActions `
        -ActualActions $mailbox.AuditAdmin
    $DelegateMissing = VerifyActions -ExpectedActions $DelegateActions `
        -ActualActions $mailbox.AuditDelegate
    $OwnerMissing = VerifyActions -ExpectedActions $OwnerActions `
        -ActualActions $mailbox.AuditOwner

    $IsCompliant = $AdminMissing.Count -eq 0 -and
        $DelegateMissing.Count -eq 0 -and
        $OwnerMissing.Count -eq 0 -and
        $mailbox.AuditEnabled

    [PSCustomObject]@{
        Mailbox         = $mailbox.UserPrincipalName
        AuditEnabled    = $mailbox.AuditEnabled
        AdminMissing    = if ($AdminMissing.Count -gt 0) { $AdminMissing -join ", " } else { "None" }
        DelegateMissing = if ($DelegateMissing.Count -gt 0) { $DelegateMissing -join ", " } else { "None" }
        OwnerMissing    = if ($OwnerMissing.Count -gt 0) { $OwnerMissing -join ", " } else { "None" }
        ComplianceState = if ($IsCompliant) { "Compliant" } else { "Non-Compliant" }
    }
}

# Display results in table format
$Results | Format-Table -AutoSize

<# Optional: Export methods
$Results | Out-GridView -Title "Mailbox Audit Results"
$Results | Export-Csv -Path "6.1.2.csv" -NoTypeInformation
$Results | ConvertTo-Json | Out-File -FilePath "6.1.2.json"
#>
