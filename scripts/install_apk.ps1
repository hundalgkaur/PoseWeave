#!/usr/bin/env pwsh
# Installs the current debug APK on a connected Android device, with retries for
# the flaky USB link, and can capture device logs for inspection.
#
# Companion script: device_logs.ps1 (log capture). This script calls it via
# -Logs; device_logs.ps1 calls back here via -Install — so either entry point
# can drive the full install → run → capture-logs flow.
#
# Usage (from the project root):
#   ./scripts/install_apk.ps1            # install the existing build/.../app-debug.apk
#   ./scripts/install_apk.ps1 -Build     # rebuild the APK first, then install
#   ./scripts/install_apk.ps1 -Launch    # install, then launch the app on the phone
#   ./scripts/install_apk.ps1 -Launch -Logs   # also capture logs to build/device.log
#
# Requires: a phone connected over USB with USB debugging enabled (accept the
# "Allow USB debugging?" prompt), and Android platform-tools (adb).

param(
  [switch]$Build,
  [switch]$Launch,
  [switch]$Logs
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

# Install with retries — this device drops off USB mid-transfer, and the debug
# keystore can change (signature mismatch) after an SDK refresh.
function Install-WithRetry {
  for ($i = 1; $i -le 5; $i++) {
    & $adb wait-for-device
    Start-Sleep -Milliseconds 800
    $res = (& $adb install -r $apk 2>&1) | Out-String
    if ($res -match 'Success') { Write-Host "Installed (attempt $i)." -ForegroundColor Green; return $true }
    if ($res -match 'signatures do not match|INSTALL_FAILED_UPDATE_INCOMPATIBLE') {
      Write-Host 'Signature mismatch — uninstalling old app, then reinstalling...' -ForegroundColor Yellow
      & $adb uninstall $appId 2>$null | Out-Null
      $res = (& $adb install $apk 2>&1) | Out-String
      if ($res -match 'Success') { Write-Host "Installed after uninstall (attempt $i)." -ForegroundColor Green; return $true }
    }
    Write-Host "Install attempt $i failed; retrying..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
  }
  return $false
}

Write-Host "Installing $apk ..." -ForegroundColor Cyan
if (-not (Install-WithRetry)) {
  Write-Error 'Install failed after retries. Check the cable/port and `adb devices`.'
  exit 1
}

if ($Launch) {
  Write-Host 'Launching app...' -ForegroundColor Cyan
  & $adb logcat -c 2>$null    # clear so the capture starts fresh
  & $adb shell am force-stop $appId 2>$null | Out-Null
  & $adb shell monkey -p $appId -c android.intent.category.LAUNCHER 1 | Out-Null
}

if ($Logs) {
  # Give the app a moment to produce output, then dump the buffer to a file that
  # can be read directly (see scripts/device_logs.ps1 for streaming/options).
  Start-Sleep -Seconds 3
  & (Join-Path $PSScriptRoot 'device_logs.ps1')
}

Write-Host 'Done.' -ForegroundColor Green
