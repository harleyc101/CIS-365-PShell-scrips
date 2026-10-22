$params = @(
    'RecipientLimitExternalPerHour'
    'RecipientLimitInternalPerHour'
    'RecipientLimitPerDay'
    'ActionWhenThresholdReached'
    'NotifyOutboundSpamRecipients'
)
Get-HostedOutboundSpamFilterPolicy -Identity Default | Format-List $params
