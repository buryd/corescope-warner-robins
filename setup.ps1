#Requires -Version 5.1
<#
.SYNOPSIS
  Install Docker (if needed) and start Middle Georgia CoreScope for Warner Robins.
#>
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

New-Item -ItemType Directory -Force -Path (Join-Path $Root "data") | Out-Null
Copy-Item (Join-Path $Root "config.json") (Join-Path $Root "data\config.json") -Force

function Test-DockerReady {
    try {
        docker info 1>$null 2>$null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker not found. Installing Docker Desktop via winget..."
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
    Write-Host ""
    Write-Host "Docker Desktop was installed. Start Docker Desktop from the Start menu,"
    Write-Host "wait until it says Running, then re-run this script:"
    Write-Host "  powershell -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit 2
}

if (-not (Test-DockerReady)) {
    Write-Host "Docker CLI exists but the engine is not ready."
    Write-Host "Open Docker Desktop, wait until it is Running, then re-run this script."
    exit 3
}

Write-Host "Starting CoreScope (Warner Robins / Middle Georgia)..."
docker compose pull
docker compose up -d

Write-Host ""
Write-Host "CoreScope UI:   http://localhost"
Write-Host "MQTT broker:    localhost:1883"
Write-Host "Region codes:   WRB (Warner Robins), MCN (Macon)"
Write-Host "Map center:     32.613, -83.624 (Warner Robins)"
Write-Host ""
Write-Host "Next: flash an observer with MESH_PACKET_LOGGING=1 (USA preset),"
Write-Host "      then point meshcoretomqtt at this broker using observer\99-user.toml"
Write-Host "MeshScope: Settings -> http://<this-pc-lan-ip>  (emulator: http://10.0.2.2)"
