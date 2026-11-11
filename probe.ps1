$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"

Start-Sleep -Seconds 10

Write-Host "=== compose ps ==="
docker compose ps

Write-Host "=== logs ==="
docker compose logs --tail 60

Write-Host "=== HTTP probes ==="
foreach ($url in @("http://127.0.0.1:3000/", "http://127.0.0.1:3000/api/nodes", "http://127.0.0.1:3000/api/stats")) {
    try {
        $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30
        $snippet = if ($r.Content.Length -gt 180) { $r.Content.Substring(0, 180) } else { $r.Content }
        Write-Host ("OK {0} -> {1} {2}" -f $url, $r.StatusCode, $snippet)
    } catch {
        Write-Host ("ERR {0} -> {1}" -f $url, $_.Exception.Message)
    }
}
