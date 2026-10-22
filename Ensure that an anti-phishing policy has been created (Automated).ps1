$params = @(
    "Name", "Enabled", "PhishThresholdLevel", "EnableTargetedUserProtection",
    "EnableOrganizationDomainsProtection", "EnableMailboxIntelligence",
    "EnableMailboxIntelligenceProtection", "EnableSpoofIntelligence",
    "TargetedUserProtectionAction", "TargetedDomainProtectionAction",
    "MailboxIntelligenceProtectionAction", "EnableFirstContactSafetyTips",
    "EnableSimilarUsersSafetyTips", "EnableSimilarDomainsSafetyTips",
    "EnableUnusualCharactersSafetyTips", "TargetedUsersToProtect",
    "HonorDmarcPolicy"
)
Get-AntiPhishPolicy | Format-List $params

# Verify the matching rule is enabled and covers most of the organisation
Get-AntiPhishRule | Format-Table AntiPhishPolicy, Priority, State, SentToMemberOf, RecipientDomainIs
