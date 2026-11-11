#Requires -Version 5.1
<#
.SYNOPSIS
  After reboot (Virtual Machine Platform enabled): install/start Docker Desktop,
  then bring up Warner Robins CoreScope.
#>
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

Write-Host "== CoreScope Warner Robins — continue after reboot =="

# Refresh PATH for this session
$dockerBin = "C:\Program Files\Docker\Docker\resources\bin"
if (Test-Path $dockerBin) { $env:Path = "$dockerBin;" + $env:Path }
$userDocker = Join-Path $env:LOCALAPPDATA "Docker\cli"
# Also common per-user CLI location after recent Desktop installs
Get-ChildItem "$env:LOCALAPPDATA\Docker" -Recurse -Filter "docker.exe" -ErrorAction SilentlyContinue |
  Select-Object -First 1 |
  ForEach-Object { $env:Path = "$(Split-Path $_.FullName);" + $env:Path }

function Test-DockerReady {
  try {
    & docker info 1>$null 2>$null
    return ($LASTEXITCODE -eq 0)
  } catch { return $false }
}

# 1) Ensure Docker Desktop is installed
$desktopExe = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
$userDesktop = Join-Path $env:LOCALAPPDATA "Docker\Docker Desktop.exe"
if (-not (Test-Path $desktopExe) -and -not (Test-Path $userDesktop) -and -not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Host "Docker Desktop not found. Installing via winget..."
  winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
  Write-Host "Start Docker Desktop from the Start menu, wait until it is Running, then re-run this script."
  exit 2
}

# 2) Start Docker Desktop if engine not ready
if (-not (Test-DockerReady)) {
  $launch = if (Test-Path $desktopExe) { $desktopExe } elseif (Test-Path $userDesktop) { $userDesktop } else { $null }
  if ($launch) {
    Write-Host "Starting Docker Desktop: $launch"
    Start-Process $launch
  }
  Write-Host "Waiting for Docker engine..."
  $deadline = (Get-Date).AddMinutes(5)
  while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 5
    if (Test-Path $dockerBin) { $env:Path = "$dockerBin;" + $env:Path }
    if (Test-DockerReady) { break }
    Write-Host "  still waiting..."
  }
}

if (-not (Test-DockerReady)) {
  Write-Host "Docker engine did not become ready. Open Docker Desktop manually, then re-run."
  exit 3
}

Write-Host "Docker is ready."

# 3) Deploy CoreScope
New-Item -ItemType Directory -Force -Path (Join-Path $Root "data") | Out-Null
Copy-Item (Join-Path $Root "config.json") (Join-Path $Root "data\config.json") -Force

Write-Host "Pulling and starting corescope-warner-robins..."
docker compose pull
docker compose up -d

Write-Host ""
Write-Host "UI:            http://localhost"
Write-Host "MQTT:          localhost:1883"
Write-Host "Regions:       WRB (Warner Robins), MCN (Macon)"
Write-Host "Map center:    32.613, -83.624"
Write-Host "Observer cfg:  .\observer\99-user.toml"
Write-Host "MeshScope URL: http://<this-pc-lan-ip>  (emulator: http://10.0.2.2)"
Write-Host ""
docker compose ps
