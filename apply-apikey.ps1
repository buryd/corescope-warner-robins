$ErrorActionPreference = "Stop"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"
Copy-Item .\config.json .\data\config.json -Force
docker compose up -d --force-recreate
Start-Sleep -Seconds 8
docker compose ps
try {
    $r = Invoke-WebRequest -Uri "http://127.0.0.1:3000/api/nodes" -UseBasicParsing -TimeoutSec 20
    Write-Host ("API OK HTTP {0}" -f $r.StatusCode)
} catch {
    Write-Host ("API: {0}" -f $_.Exception.Message)
}
Write-Host "API key applied from config.json (see API-KEY.txt)"
