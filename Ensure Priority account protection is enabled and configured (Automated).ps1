# Step 1: Priority account protection state (Exchange Online)
Get-EmailTenantSettings | Select-Object EnablePriorityAccountProtection

# Step 2: Alert policies targeting priority accounts (Security & Compliance)
Get-ProtectionAlert | Where-Object { $_.RecipientTags -match 'Priority account' } |
    Format-List Name, ThreatType, Severity, Filter, RecipientTags, NotificationEnabled, NotifyUser, Disabled
