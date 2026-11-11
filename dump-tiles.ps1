$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
docker exec corescope-warner-robins sh -c "sed -n '1,120p' /app/public/map-tile-providers.js"
