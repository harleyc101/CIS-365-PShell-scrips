# Shared Bookings should be turned off in the default OWA mailbox policy
Get-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default | Format-List BookingsMailboxCreationEnabled

# Optional: if Bookings is disabled for the whole organisation, that is also compliant
Get-OrganizationConfig | Format-List BookingsEnabled
