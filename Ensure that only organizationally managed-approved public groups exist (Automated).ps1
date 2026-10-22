$Groups = Get-MgGroup -All -Filter "groupTypes/any(c:c eq 'Unified')" `
    -Property Id, DisplayName, Visibility, GroupTypes

# Displays the groups to the console for review
$Groups | Format-Table Id, DisplayName, Visibility
