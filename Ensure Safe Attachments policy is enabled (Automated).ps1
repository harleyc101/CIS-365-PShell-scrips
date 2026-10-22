Get-SafeAttachmentPolicy | Format-Table Identity, Enable, Action, QuarantineTag

# Policy priority is held on the rules, not the policies
Get-SafeAttachmentRule | Format-Table Name, SafeAttachmentPolicy, Priority, State
