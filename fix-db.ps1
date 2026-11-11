$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"

Write-Host "Testing write into /app/data..."
docker exec corescope-warner-robins sh -c "touch /app/data/meshcore.db && ls -la /app/data && echo WRITE_OK"

# Prefer single data volume mount (config lives inside data/)
Copy-Item .\config.json .\data\config.json -Force

Write-Host "Rewriting compose to drop separate config bind..."
@'
# Middle Georgia / Warner Robins CoreScope
services:
  corescope:
    image: ghcr.io/kpa-clawbot/corescope:latest
    container_name: corescope-warner-robins
    restart: unless-stopped
    ports:
      - "3000:80"
      - "1883:1883"
    volumes:
      - ./data:/app/data
    environment:
      - TZ=America/New_York
'@ | Set-Content -Path .\docker-compose.yml -Encoding UTF8

docker compose up -d --force-recreate
Start-Sleep -Seconds 12
docker compose ps
docker compose logs --tail 40

foreach ($url in @("http://127.0.0.1:3000/", "http://127.0.0.1:3000/api/nodes")) {
    try {
        $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30
        Write-Host ("OK {0} -> {1}" -f $url, $r.StatusCode)
    } catch {
        Write-Host ("ERR {0} -> {1}" -f $url, $_.Exception.Message)
    }
}
Get-ChildItem .\data -Force | Format-Table Name,Length
