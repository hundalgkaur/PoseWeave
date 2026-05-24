#!/usr/bin/env pwsh
# Capture logs from the connected Android device into build/device.log so they
# can be inspected directly (the file is the single source of truth — read it).
#
# Companion script: install_apk.ps1 (build/install/launch). This script can call
# it via -Install, and install_apk.ps1 calls back here via its -Logs switch — so
# either entry point drives the full install → run → capture-logs flow.
#
# Usage (from the project root):
#   ./scripts/device_logs.ps1                 # dump the recent buffer once (reliable)
#   ./scripts/device_logs.ps1 -Lines 400      # dump the last N matching lines
#   ./scripts/device_logs.ps1 -Clear          # clear the buffer first, then dump
#   ./scripts/device_logs.ps1 -Follow          # stream continuously (auto-reconnects)
#   ./scripts/device_logs.ps1 -All             # include all tags, not just app/errors
#   ./scripts/device_logs.ps1 -Install -Follow # install+launch (via install_apk.ps1), then stream
#   ./scripts/device_logs.ps1 -Install -Build  # rebuild+install+launch, then dump
#
# Filter (default): the Flutter tag (debugPrint + BlocObserver, incl. the
# DETECT DEBUG / "Pose frame skipped" lines) plus Java/native crashes. Use -All
# for the unfiltered stream.

param(
  [int]$Lines = 300,
  [switch]$Clear,
  [switch]$Follow,
  [switch]$All,
  [switch]$Install,
  [switch]$Build
)

$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root 'build/device.log'

# Locate adb: PATH first, then the default Android SDK location.
$adb = (Get-Command adb -ErrorAction SilentlyContinue).Source
if (-not $adb) { $adb = Join-Path $env:LOCALAPPDATA 'Android\sdk\platform-tools\adb.exe' }
if (-not (Test-Path $adb)) {
  Write-Error 'adb not found. Install Android platform-tools or add adb to PATH.'
  exit 1
}

New-Item -ItemType Directory -Force (Split-Path $out) | Out-Null

# Optionally build/install/launch first, via the companion script.
if ($Install) {
  $installArgs = @('-Launch')
  if ($Build) { $installArgs += '-Build' }
  & (Join-Path $PSScriptRoot 'install_apk.ps1') @installArgs
}

# logcat tag filter: app + crashes, unless -All.
$filter = if ($All) { @('-v', 'time') } else { @('-v', 'time', 'flutter:V', 'AndroidRuntime:E', 'DEBUG:F', 'libc:F', '*:S') }

if ($Clear) {
  & $adb wait-for-device
  & $adb logcat -c 2>$null
  Write-Host 'Log buffer cleared.' -ForegroundColor Cyan
}

if ($Follow) {
  Write-Host "Streaming device logs to $out (Ctrl+C to stop)..." -ForegroundColor Cyan
  # Loop so a USB drop (common on this device) doesn't end the capture.
  while ($true) {
    & $adb wait-for-device
    & $adb logcat @filter | Tee-Object -FilePath $out -Append
    Write-Host 'Device disconnected — waiting to reconnect...' -ForegroundColor Yellow
    Start-Sleep -Seconds 1
  }
}
else {
  # One-shot dump of the current buffer — reliable even when the USB link is
  # flaky. NOTE: do NOT use `logcat -t N` with a filterspec — it takes the last
  # N *raw* lines and then filters, so flutter lines get truncated away on a
  # noisy device. Dump the whole filtered buffer, then keep the last N here.
  & $adb wait-for-device
  $dump = @(& $adb logcat -d @filter 2>$null)
  if ($Lines -gt 0 -and $dump.Count -gt $Lines) {
    $dump = $dump | Select-Object -Last $Lines
  }
  $dump | Out-File -FilePath $out -Encoding utf8
  Write-Host "Wrote $($dump.Count) lines to $out" -ForegroundColor Green
  # Echo a short tail to the console too.
  $dump | Select-Object -Last 25
}
