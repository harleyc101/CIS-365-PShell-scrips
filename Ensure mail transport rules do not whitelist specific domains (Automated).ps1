Get-TransportRule | Where-Object { $_.SetSCL -eq -1 -and $_.SenderDomainIs -ne $null } |
    Format-Table Name, SenderDomainIs, SetSCL
