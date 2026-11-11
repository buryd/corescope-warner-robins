$ErrorActionPreference = "Stop"
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"
$keyLine = Get-Content .\API-KEY.txt | Where-Object { $_ -match '^[A-Za-z0-9+/=_-]{20,}$' } | Select-Object -First 1
if (-not $keyLine) { throw "No key in API-KEY.txt" }
New-Item -ItemType Directory -Force -Path .\data | Out-Null
Copy-Item .\config.json .\data\config.json -Force
$raw = Get-Content .\data\config.json -Raw
$raw = $raw -replace '"apiKey"\s*:\s*"[^"]*"', ('"apiKey": "' + $keyLine + '"')
Set-Content .\data\config.json -Value $raw -Encoding UTF8
Write-Host "Restored local data/config.json apiKey from API-KEY.txt"
