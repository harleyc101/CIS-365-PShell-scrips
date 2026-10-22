Get-MalwareFilterPolicy -Identity Default

# Compare the policy's blocked file types against Microsoft's default list of 53
$DefaultFileTypes = @(
    "ani", "apk", "app", "appx", "arj", "bat", "cab", "cmd", "com",
    "deb", "dex", "dll", "docm", "elf", "exe", "hta", "img", "iso",
    "jar", "jnlp", "kext", "lha", "lib", "library", "lnk", "lzh",
    "macho", "msc", "msi", "msix", "msp", "mst", "pif", "ppa",
    "ppam", "reg", "rev", "scf", "scr", "sct", "sys", "uif", "vb",
    "vbe", "vbs", "vxd", "wsc", "wsf", "wsh", "xll", "xz", "z", "ace"
)
$Policy = Get-MalwareFilterPolicy -Identity Default
$Missing = $DefaultFileTypes | Where-Object { $_ -notin $Policy.FileTypes }

Write-Host "EnableFileFilter : $($Policy.EnableFileFilter)"
Write-Host "Missing default file types ($($Missing.Count)): $($Missing -join ', ')"
