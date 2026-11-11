$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path

$desktop = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
if (-not (Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue)) {
    Start-Process $desktop
}

Write-Host "Waiting for Docker engine..."
$deadline = (Get-Date).AddMinutes(8)
while ((Get-Date) -lt $deadline) {
    & docker info 1>$null 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "READY"
        exit 0
    }
    Write-Host "waiting..."
    Start-Sleep -Seconds 5
}
Write-Host "TIMEOUT"
exit 1
