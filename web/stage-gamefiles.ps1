# Stage Redneck Rampage data for Emscripten preload.
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Src = Join-Path $Root 'gamefiles'
$Dst = Join-Path $PSScriptRoot 'gamedata'

$grp = @(Get-ChildItem -Path $Src -Filter '*.grp' -ErrorAction SilentlyContinue)
if ($grp.Count -eq 0) {
    Write-Error "Missing gamefiles\REDNECK.GRP - see gamefiles\README.md"
}
if (Test-Path $Dst) { Remove-Item -Recurse -Force $Dst }
New-Item -ItemType Directory -Path $Dst | Out-Null
Copy-Item -Path (Join-Path $Src '*') -Destination $Dst -Recurse -Force
$cfg = Get-ChildItem -Path $Dst -Filter 'REDNECK.CFG' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($cfg) {
    Copy-Item $cfg.FullName (Join-Path $Dst 'rednukem.cfg') -Force
}
$n = @(Get-ChildItem $Dst -Recurse -File).Count
Write-Host "Staged $n files from gamefiles to gamedata"
