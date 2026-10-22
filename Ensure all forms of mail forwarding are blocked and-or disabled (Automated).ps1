# STEP 1: Transport rules that redirect email
Get-TransportRule | Where-Object { $_.RedirectMessageTo -ne $null } |
    Format-Table Name, RedirectMessageTo

# STEP 2: Automatic forwarding in outbound anti-spam policies
Get-HostedOutboundSpamFilterPolicy | Format-Table Name, AutoForwardingMode
