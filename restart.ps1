$ErrorActionPreference = "Stop"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"
Copy-Item .\config.json .\data\config.json -Force
docker compose up -d --force-recreate
Start-Sleep -Seconds 10
docker compose ps
try {
    $r = Invoke-WebRequest -Uri "http://127.0.0.1:3000/" -UseBasicParsing -TimeoutSec 20
    Write-Host ("UI HTTP {0}" -f $r.StatusCode)
} catch {
    Write-Host $_.Exception.Message
}
