$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"

docker compose ps
Write-Host ""

$ip = (
    Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.InterfaceAlias -match 'Wi-?Fi|Ethernet' -and
        $_.PrefixOrigin -eq 'Dhcp' -and
        $_.IPAddress -notlike '127.*' -and
        $_.IPAddress -notlike '169.254.*'
    } |
    Select-Object -First 1 -ExpandProperty IPAddress
)
if (-not $ip) {
    $ip = (
        Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object { $_.IPAddress -like '10.*' -or $_.IPAddress -like '192.168.*' } |
        Select-Object -First 1 -ExpandProperty IPAddress
    )
}

Write-Host "UI:            http://localhost:3000"
Write-Host "LAN UI:        http://${ip}:3000"
Write-Host "MQTT:          ${ip}:1883  (and localhost:1883)"
Write-Host "MeshScope:     http://${ip}:3000"
Write-Host "Emulator URL:  http://10.0.2.2:3000"
Write-Host "Regions:       WRB (Warner Robins), MCN (Macon)"
Write-Host ""

try {
    $nodes = Invoke-RestMethod -Uri "http://127.0.0.1:3000/api/nodes" -TimeoutSec 20
    $count = if ($nodes -is [System.Array]) { $nodes.Count } elseif ($nodes.nodes) { $nodes.nodes.Count } else { "ok" }
    Write-Host "API /api/nodes: reachable ($count)"
} catch {
    Write-Host "API /api/nodes: $($_.Exception.Message)"
}
