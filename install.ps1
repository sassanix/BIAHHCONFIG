# BIAHHCONFIG v2 installer
# Backs up, then installs the Base*.ini templates and refreshes the
# generated Sumac*.ini user configs so the changes actually take effect.
#
# Usage:
#   .\install.ps1 -GamePath "D:\SteamLibrary\steamapps\common\Brothers in Arms Hells Highway"
#   .\install.ps1 -GamePath "..." -HD    (also merge the HD PoolSize override by hand afterwards)
#
# Nothing is deleted permanently: replaced files are copied to a
# timestamped backup folder next to the originals first.

param(
    [Parameter(Mandatory = $true)]
    [string]$GamePath,
    [switch]$HD
)

$ErrorActionPreference = "Stop"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$src = $PSScriptRoot

$engineConfig = Join-Path $GamePath "Engine\Config"
$userConfig = Join-Path $env:USERPROFILE "Documents\My Games\BIA Hells Highway\SumacGame\Config"

if (-not (Test-Path $engineConfig)) { throw "Engine\Config not found under $GamePath" }

function Backup-And-Copy($from, $toDir) {
    $name = Split-Path $from -Leaf
    $dest = Join-Path $toDir $name
    if (Test-Path $dest) {
        $bakDir = Join-Path $toDir "backup-$stamp"
        New-Item -ItemType Directory -Force $bakDir | Out-Null
        Copy-Item $dest (Join-Path $bakDir $name)
        Write-Host "Backed up $name"
    }
    Copy-Item $from $dest -Force
    Write-Host "Installed $name"
}

foreach ($f in "BaseEngine.ini","BaseGame.ini","BaseCompat.ini","BaseInput.ini","BaseUI.ini") {
    Backup-And-Copy (Join-Path $src $f) $engineConfig
}

if (Test-Path $userConfig) {
    # The game reads these, not the Base files. Remove them so it rebuilds
    # from the new templates on next launch. Backups are kept.
    $bakDir = Join-Path $userConfig "backup-$stamp"
    New-Item -ItemType Directory -Force $bakDir | Out-Null
    foreach ($f in "SumacEngine.ini","SumacGame.ini","SumacInput.ini","SumacUI.ini") {
        $p = Join-Path $userConfig $f
        if (Test-Path $p) { Move-Item $p (Join-Path $bakDir $f); Write-Host "Moved aside $f (will be rebuilt)" }
    }
    Write-Host "Note: save-game settings like resolution may reset once. Your saves are untouched."
} else {
    Write-Host "No user config folder yet. The game will generate it from the new Base files on first launch."
}

if ($HD) {
    Write-Host ""
    Write-Host "HD mode: after the game has rebuilt SumacEngine.ini once, merge the"
    Write-Host "[TextureStreaming] PoolSize=2048 block from user-config\SumacEngine.ini"
    Write-Host "into it, and patch the game .exe with a 4 GB / Large Address Aware patch."
}
Write-Host "Done."
