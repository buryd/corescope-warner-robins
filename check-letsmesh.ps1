$ErrorActionPreference = "Continue"
$urls = @(
  "https://analyzer.letsmesh.net/api/observers",
  "https://analyzer.letsmesh.net/api/v1/observers",
  "https://analyzer.letsmesh.net/status/observers?format=json",
  "https://corescope.chicagolandmesh.org/api/observers"
)
foreach ($u in $urls) {
  try {
    $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 25
    $t = $r.Content
    $hit = $t -match 'WRB|MCN|Georgia|Warner|Macon|ATL|SAV|CSG'
    Write-Host ("OK {0} len={1} ga_hit={2}" -f $u, $t.Length, $hit)
    if ($hit) {
      # extract nearby snippets
      [regex]::Matches($t, '.{0,40}(WRB|MCN|Georgia|Warner|Macon|ATL).{0,40}', 'IgnoreCase') |
        Select-Object -First 15 |
        ForEach-Object { Write-Host ("  " + $_.Value) }
    } else {
      Write-Host ($t.Substring(0, [Math]::Min(200, $t.Length)))
    }
  } catch {
    Write-Host ("ERR {0} -> {1}" -f $u, $_.Exception.Message)
  }
}
