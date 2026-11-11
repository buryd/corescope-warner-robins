Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike '127.*' } |
    Sort-Object InterfaceAlias |
    Format-Table InterfaceAlias, IPAddress, PrefixOrigin -AutoSize
