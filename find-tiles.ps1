$ErrorActionPreference = "Continue"
$env:Path = "C:\Program Files\Docker\Docker\resources\bin;" + $env:Path
docker exec corescope-warner-robins sh -c "grep -R -n -i 'esri\|carto-dark\|darkDefault\|API KEY REQUIRED' /app/public 2>/dev/null | head -80"
docker exec corescope-warner-robins sh -c "ls /app/public"
