# Build Rednukem (Redneck Rampage) for web
param(
    [string]$EmsdkRoot = '',
    [switch]$SkipStage
)

$Root = Split-Path $PSScriptRoot -Parent
if (-not $EmsdkRoot) {
    $local = Join-Path $Root 'emsdk'
    $blood = Join-Path (Split-Path $Root -Parent) 'bloodweb\emsdk'
    if (Test-Path (Join-Path $local 'emsdk_env.ps1')) { $EmsdkRoot = $local }
    elseif (Test-Path (Join-Path $blood 'emsdk_env.ps1')) { $EmsdkRoot = $blood }
    else { $EmsdkRoot = $local }
}

$ErrorActionPreference = 'Stop'
$Web = Join-Path $Root 'web'
$Gamefiles = Join-Path $Root 'gamefiles'
$Engine = Join-Path $Root 'NBlood-master'
$EnvPs1 = Join-Path $EmsdkRoot 'emsdk_env.ps1'

$grp = Get-ChildItem $Gamefiles -Filter '*.grp' -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $grp) {
    Write-Error "Missing gamefiles\REDNECK.GRP — see gamefiles\README.md"
}
if (-not (Test-Path $EnvPs1)) {
    Write-Error "Emscripten not found at $EmsdkRoot — clone emsdk and run: emsdk install latest; emsdk activate latest"
}

if (-not $SkipStage) {
    Write-Host "==> Staging gamefiles -> web/gamedata"
    & (Join-Path $Web 'stage-gamefiles.ps1')
}

Write-Host "==> Building Rednukem (Emscripten)"
$preload = '../web/gamedata@/'
Push-Location $Engine
try {
    & $EnvPs1 | Out-Null
    if (-not (Get-Command emcc -ErrorAction SilentlyContinue)) {
        throw "emcc not in PATH after emsdk_env.ps1"
    }
    & make EMSCRIPTEN=1 HTML=0 web "EMPRELOAD=$preload"
    if ($LASTEXITCODE -ne 0) { throw "make failed with exit $LASTEXITCODE" }
} finally {
    Pop-Location
}

foreach ($f in @('rednukem.js', 'rednukem.wasm', 'rednukem.data')) {
    $src = Join-Path $Engine $f
    if (-not (Test-Path $src)) { Write-Error "Missing build output: $src" }
    Copy-Item $src (Join-Path $Web $f) -Force
    Write-Host "==> Copied $f -> web\"
}

Write-Host ""
Write-Host "Done. Run:  cd web; python serve.py"
Write-Host "Open:     http://127.0.0.1:8767/run.html"
