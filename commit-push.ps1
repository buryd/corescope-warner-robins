$ErrorActionPreference = "Stop"
Set-Location "C:\Users\dell\CoreScope-WarnerRobins"

# Ensure live key stays only in ignored data/ + API-KEY.txt
if (Test-Path ".\API-KEY.txt") {
  $key = (Get-Content ".\API-KEY.txt" | Where-Object { $_ -match '^[A-Za-z0-9+/=]{20,}$' } | Select-Object -First 1)
  if ($key -and (Test-Path ".\data\config.json")) {
    (Get-Content ".\data\config.json" -Raw) -replace '"apiKey"\s*:\s*"[^"]*"', ('"apiKey": "' + $key + '"') |
      Set-Content ".\data\config.json" -Encoding UTF8 -NoNewline
  }
}

git init -b main
git add .
git status
git commit -m "Add Warner Robins / Middle Georgia CoreScope deployment."
gh repo create buryd/corescope-warner-robins --public --source=. --remote=origin --push
git status -sb
git remote -v
Write-Host "REMOTE_OK"
