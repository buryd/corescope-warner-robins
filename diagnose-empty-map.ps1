$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"

Write-Host "=== container ==="
docker compose ps

Write-Host "`n=== API probes ==="
$urls = @(
  "http://127.0.0.1:3000/api/nodes",
  "http://127.0.0.1:3000/api/observers",
  "http://127.0.0.1:3000/api/packets?limit=5",
  "http://127.0.0.1:3000/api/stats"
)
foreach ($u in $urls) {
  try {
    $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 20
    $c = $r.Content
    if ($c.Length -gt 400) { $c = $c.Substring(0, 400) + "..." }
    Write-Host ("OK {0}`n{1}`n" -f $u, $c)
  } catch {
    Write-Host ("ERR {0} -> {1}" -f $u, $_.Exception.Message)
  }
}

Write-Host "=== recent logs (mqtt/ingest) ==="
docker compose logs --tail 80 | Select-String -Pattern "mqtt|MQTT|observer|ingest|connected|error|WRB|packet" -CaseSensitive:$false

Write-Host "`n=== mosquitto topics hint ==="
docker exec corescope-warner-robins sh -c "ps aux | head -20; ls /app/data | head"
