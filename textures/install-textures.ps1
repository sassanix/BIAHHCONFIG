# HD texture pack helper for Windows.
# Prepares the game for a TFC Installer texture pack:
#   1. Verifies the game folder and the extracted mod folder.
#   2. Backs up the game .exe and your SumacEngine.ini.
#   3. Sets the Large Address Aware flag on the game .exe (needs Python 3)
#      or tells you how to do it with a GUI 4 GB patcher instead.
#   4. Applies the HD streaming override (PoolSize=2048) to SumacEngine.ini.
#   5. Launches TFC Installer if you pass -TFCInstaller, otherwise prints
#      the three clicks to finish inside it.
#
# Usage:
#   .\install-textures.ps1 -GamePath "D:\SteamLibrary\steamapps\common\Brothers in Arms Hells Highway" `
#                          -ModFolder "D:\Mods\BIAHH-HD-World" `
#                          -TFCInstaller "D:\Tools\TFCInstaller.exe"

param(
    [Parameter(Mandatory = $true)][string]$GamePath,
    [Parameter(Mandatory = $true)][string]$ModFolder,
    [string]$TFCInstaller
)

$ErrorActionPreference = "Stop"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (-not (Test-Path (Join-Path $GamePath "Binaries"))) { throw "Binaries folder not found under $GamePath" }
if (-not (Test-Path (Join-Path $ModFolder "GameProfile.xml"))) {
    throw "GameProfile.xml not found in $ModFolder. Extract the pack archive first and point -ModFolder at the extracted folder."
}

$exe = Get-ChildItem (Join-Path $GamePath "Binaries") -Filter "*.exe" |
       Sort-Object Length -Descending | Select-Object -First 1
if (-not $exe) { throw "No .exe found in Binaries" }
Write-Host "Game executable: $($exe.FullName)"

# Back up the exe (patch-laa.py also writes a .bak, this is a second copy)
Copy-Item $exe.FullName "$($exe.FullName).backup-$stamp"
Write-Host "Backed up exe to $($exe.FullName).backup-$stamp"

# Large Address Aware
$py = Get-Command python -ErrorAction SilentlyContinue
if ($py) {
    python (Join-Path $PSScriptRoot "patch-laa.py") $exe.FullName
} else {
    Write-Host "Python not found. Set the flag manually with any 4 GB patcher"
    Write-Host "(for example the NTCore 4GB Patch) on: $($exe.FullName)"
}

# HD streaming override in the user config the game actually reads
$userConfig = Join-Path $env:USERPROFILE "Documents\My Games\BIA Hells Highway\SumacGame\Config\SumacEngine.ini"
if (Test-Path $userConfig) {
    Copy-Item $userConfig "$userConfig.backup-$stamp"
    $ini = Get-Content $userConfig -Raw
    if ($ini -match "PoolSize\s*=") {
        $ini = $ini -replace "PoolSize\s*=\s*\d+", "PoolSize=2048"
    } elseif ($ini -match "\[TextureStreaming\]") {
        $ini = $ini -replace "\[TextureStreaming\]", "[TextureStreaming]`r`nPoolSize=2048"
    } else {
        $ini += "`r`n[TextureStreaming]`r`nPoolSize=2048`r`n"
    }
    Set-Content $userConfig $ini
    Write-Host "Set PoolSize=2048 in SumacEngine.ini (backup saved)."
} else {
    Write-Host "SumacEngine.ini not found yet. Run the game once so it generates"
    Write-Host "its config, then merge user-config\SumacEngine.ini from this repo."
}

if ($TFCInstaller -and (Test-Path $TFCInstaller)) {
    Write-Host "Launching TFC Installer. In it: 1) set the game folder to $GamePath"
    Write-Host "2) set the mod folder to $ModFolder  3) click Update All."
    Start-Process $TFCInstaller
} else {
    Write-Host ""
    Write-Host "Now finish in TFC Installer (needs the .NET 6 runtime):"
    Write-Host "  1. Set the game folder to: $GamePath"
    Write-Host "  2. Set the mod folder to:  $ModFolder"
    Write-Host "  3. Click Update All, wait for it to complete, then launch the game."
}
