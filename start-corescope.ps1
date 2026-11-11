$ErrorActionPreference = "Stop"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"

New-Item -ItemType Directory -Force -Path ".\data" | Out-Null
Copy-Item ".\config.json" ".\data\config.json" -Force

Write-Host "Pulling CoreScope image..."
docker compose pull
Write-Host "Starting corescope-warner-robins..."
docker compose up -d --force-recreate
docker compose ps
Write-Host "---"
docker compose logs --tail 40
try {
    $r = Invoke-WebRequest -Uri "http://127.0.0.1:3000/api/nodes" -UseBasicParsing -TimeoutSec 20
    Write-Host "API /api/nodes HTTP $($r.StatusCode) len=$($r.RawContentLength)"
} catch {
    Write-Host "API probe: $($_.Exception.Message)"
}
