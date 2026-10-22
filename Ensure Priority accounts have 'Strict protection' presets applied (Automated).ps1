# Defender for Office 365 (ATP) strict preset rule
Get-ATPProtectionPolicyRule | Where-Object { $_.Identity -eq 'Strict Preset Security Policy' } |
    Format-List Identity, State, SentTo, SentToMemberOf, RecipientDomainIs

# Exchange Online Protection (EOP) strict preset rule
Get-EOPProtectionPolicyRule | Where-Object { $_.Identity -eq 'Strict Preset Security Policy' } |
    Format-List Identity, State, SentTo, SentToMemberOf, RecipientDomainIs
