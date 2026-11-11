$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"
Write-Host "=== host data dir ==="
Get-ChildItem .\data -Force | Format-Table Name,Mode,Length
Write-Host "=== container /app/data ==="
docker exec corescope-warner-robins ls -la /app/data
Write-Host "=== container /app ==="
docker exec corescope-warner-robins ls -la /app | Select-Object -First 40
Write-Host "=== find config ==="
docker exec corescope-warner-robins sh -c "ls -la /app/config.json /app/data/config.json 2>&1; id; df -h /app/data"
