#!/usr/bin/env pwsh
# Installs the current debug APK on a connected Android device.
#
# Usage (from the project root):
#   ./scripts/install_apk.ps1            # install the existing build/.../app-debug.apk
#   ./scripts/install_apk.ps1 -Build     # rebuild the APK first, then install
#   ./scripts/install_apk.ps1 -Launch    # install, then launch the app on the phone
#
# Requires: a phone connected over USB with USB debugging enabled (accept the
# "Allow USB debugging?" prompt), and Android platform-tools (adb).

param(
  [switch]$Build,
  [switch]$Launch
)

$ErrorActionPreference = 'Stop'
$root  = Split-Path -Parent $PSScriptRoot
$apk   = Join-Path $root 'build/app/outputs/flutter-apk/app-debug.apk'
$appId = 'com.poseweave.poseweave'

# Locate adb: PATH first, then the default Android SDK location.
$adb = (Get-Command adb -ErrorAction SilentlyContinue).Source
if (-not $adb) { $adb = Join-Path $env:LOCALAPPDATA 'Android\sdk\platform-tools\adb.exe' }
if (-not (Test-Path $adb)) {
  Write-Error 'adb not found. Install Android platform-tools or add adb to PATH.'
  exit 1
}

# Rebuild if requested or if no APK exists yet.
if ($Build -or -not (Test-Path $apk)) {
  Write-Host 'Building debug APK...' -ForegroundColor Cyan
  flutter build apk --debug
}
if (-not (Test-Path $apk)) { Write-Error "APK not found at $apk"; exit 1 }

# Require exactly one authorized device.
$connected = (& $adb devices) | Select-String -Pattern "`tdevice$"
if (-not $connected) {
  Write-Error 'No authorized Android device. Enable USB debugging, reconnect, and accept the prompt (check: adb devices).'
  exit 1
}

Write-Host "Installing $apk ..." -ForegroundColor Cyan
& $adb install -r $apk

if ($Launch) {
  Write-Host 'Launching app...' -ForegroundColor Cyan
  & $adb shell monkey -p $appId -c android.intent.category.LAUNCHER 1 | Out-Null
}

Write-Host 'Done.' -ForegroundColor Green
