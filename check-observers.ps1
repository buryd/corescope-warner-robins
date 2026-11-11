$ErrorActionPreference = "Continue"
try {
  $o = Invoke-RestMethod -Uri "http://127.0.0.1:3000/api/observers" -TimeoutSec 15
  "LOCAL observers=$($o.observers.Count)"
  $o.observers | Select-Object -First 10 | ConvertTo-Json -Depth 4
} catch { "LOCAL ERR $($_.Exception.Message)" }
try {
  $s = Invoke-RestMethod -Uri "http://127.0.0.1:3000/api/stats" -TimeoutSec 15
  "LOCAL packets=$($s.totalPackets) nodes=$($s.totalNodes) observers=$($s.totalObservers)"
} catch {}
