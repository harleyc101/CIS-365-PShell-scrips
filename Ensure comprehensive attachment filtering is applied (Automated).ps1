$AttachExts = @(
    '7z', 'a3x', 'ace', 'ade', 'adp', 'ani', 'apk', 'app', 'appinstaller',
    'applescript', 'application', 'appref-ms', 'appx', 'appxbundle', 'arj',
    'asd', 'asx', 'bas', 'bat', 'bgi', 'bz2', 'cab', 'chm', 'cmd', 'com',
    'cpl', 'crt', 'cs', 'csh', 'daa', 'dbf', 'dcr', 'deb',
    'desktopthemepackfile', 'dex', 'diagcab', 'dif', 'dir', 'dll', 'dmg',
    'doc', 'docm', 'dot', 'dotm', 'elf', 'eml', 'exe', 'fxp', 'gadget',
    'gz', 'hlp', 'hta', 'htc', 'htm', 'html', 'hwpx', 'ics', 'img',
    'inf', 'ins', 'iqy', 'iso', 'isp', 'jar', 'jnlp', 'js', 'jse', 'kext',
    'ksh', 'lha', 'lib', 'library', 'library-ms', 'lnk', 'lzh', 'macho',
    'mam', 'mda', 'mdb', 'mde', 'mdt', 'mdw', 'mdz', 'mht', 'mhtml', 'mof',
    'msc', 'msi', 'msix', 'msp', 'msrcincident', 'mst', 'ocx', 'odt', 'ops',
    'oxps', 'pcd', 'pif', 'plg', 'pot', 'potm', 'ppa', 'ppam', 'ppkg', 'pps',
    'ppsm', 'ppt', 'pptm', 'prf', 'prg', 'ps1', 'ps11', 'ps11xml', 'ps1xml',
    'ps2', 'ps2xml', 'psc1', 'psc2', 'pub', 'py', 'pyc', 'pyo', 'pyw', 'pyz',
    'pyzw', 'rar', 'reg', 'rev', 'rtf', 'scf', 'scpt', 'scr', 'sct',
    'searchConnector-ms', 'service', 'settingcontent-ms', 'sh', 'shb', 'shs',
    'shtm', 'shtml', 'sldm', 'slk', 'so', 'spl', 'stm', 'svg', 'swf', 'sys',
    'tar', 'theme', 'themepack', 'timer', 'uif', 'url', 'uue', 'vb', 'vbe',
    'vbs', 'vhd', 'vhdx', 'vxd', 'wbk', 'website', 'wim', 'wiz', 'ws', 'wsc',
    'wsf', 'wsh', 'xla', 'xlam', 'xlc', 'xll', 'xlm', 'xls', 'xlsb', 'xlsm',
    'xlt', 'xltm', 'xlw', 'xnk', 'xps', 'xsl', 'xz', 'z'
)

$MalwareFilterPolicies = Get-MalwareFilterPolicy
$MalwareFilterRules = Get-MalwareFilterRule

# A policy must have at least 90% of the extensions in the reference list to pass.
# This allows for some flexibility with exceptions.
$PassingValue = .90 # 90%
$FailThreshold = [int]($AttachExts.count * (1 - $PassingValue))

# Only evaluate policies that have more than 120 extensions defined
# so we don't output failures on policies that aren't specific to
# extension filtering.
$CompPolicies = $MalwareFilterPolicies | Where-Object { $_.FileTypes.Count -gt 120 }
if (-not $CompPolicies) {
    Write-Output "## FAIL ## No comprehensive policies found to evaluate."
    return
}

$ExtensionReport = foreach ($policy in $CompPolicies) {
    $Missing = Compare-Object -ReferenceObject $AttachExts `
        -DifferenceObject $policy.FileTypes `
        -PassThru | Where-Object { $_.SideIndicator -eq '<=' }
    $FoundRule = $MalwareFilterRules |
        Where-Object { $_.MalwareFilterPolicy -eq $policy.Id }

    # Define passing conditions to determine if this policy passes all checks.
    $Pass = ($Missing.Count -lt $FailThreshold) -and
        ($FoundRule.State -eq 'Enabled') -and
        ($policy.EnableFileFilter -eq $true)

    [PSCustomObject]@{
        PolicyName        = $policy.Identity
        IsCISCompliant    = $Pass
        EnableFileFilter  = $policy.EnableFileFilter
        State             = $FoundRule.State
        MissingCount      = $Missing.count
        MissingExtensions = $Missing -join ", "
        ExtensionCount    = $policy.FileTypes.count
    }
}

# Output results in various formats
$ExtensionReport | Format-Table -AutoSize

<# Optional: Export methods
$ExtensionReport | Out-GridView -Title "Attachment Filter results"
$ExtensionReport | Export-Csv -Path "2.1.11.csv" -NoTypeInformation
$ExtensionReport | ConvertTo-Json | Out-File -FilePath "2.1.11.json"
#>
