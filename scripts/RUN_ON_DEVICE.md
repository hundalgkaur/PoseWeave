# Running PoseWeave on a physical Android device

ML Kit pose detection only runs on real hardware (not emulators), so live
detection must be verified on a phone. (For emulator/UI work, triple-tap the
home-screen logo to toggle mock mode.)

## One-time phone setup

1. **Enable Developer Options:** Settings → About phone → tap **Build number** 7×.
2. **Enable USB debugging:** Settings → System → Developer options → **USB debugging** on.
3. **Connect via USB** and tap **Allow** on the "Allow USB debugging?" prompt
   (tick "Always allow from this computer").
4. Confirm the PC sees it: `adb devices` (or `flutter devices`) should list the phone.

## Install the current build

From the project root, run the install script:

```powershell
./scripts/install_apk.ps1                 # install the existing APK
./scripts/install_apk.ps1 -Build          # rebuild first, then install
./scripts/install_apk.ps1 -Launch         # install, then launch on the phone
./scripts/install_apk.ps1 -Launch -Logs   # also dump device logs to build/device.log
```

The script finds `adb`, **retries** the install (this device drops off USB
mid-transfer), recovers from a **signature mismatch** by uninstalling first, and
runs `adb install -r build/app/outputs/flutter-apk/app-debug.apk`.

## Capturing device logs

`flutter run` can't attach on this machine (the Android SDK is missing
`cmdline-tools`/`aapt`), so use the log script instead. It writes to
**`build/device.log`**, which is the single place to read the device output
(Flutter `debugPrint` + `BlocObserver`, incl. the on-screen **DETECT DEBUG**
line, plus Java/native crashes):

```powershell
./scripts/device_logs.ps1               # dump the recent buffer once (reliable)
./scripts/device_logs.ps1 -Clear        # clear first, then dump
./scripts/device_logs.ps1 -Lines 500    # dump the last N matching lines
./scripts/device_logs.ps1 -Follow       # stream continuously (auto-reconnects on USB drop)
./scripts/device_logs.ps1 -All          # unfiltered (all tags), not just app/errors
```

Typical loop: `./scripts/install_apk.ps1 -Launch`, reproduce the issue on the
phone, then `./scripts/device_logs.ps1` and read `build/device.log`.

## What to verify on-device

- **Live camera** → START DETECTION → 33-point skeleton tracks at ~30 FPS; confidence badge updates.
- **Preview ↔ overlay alignment** — does the skeleton sit on the body? (Most likely thing to need tuning.)
- **FLIP** front/back camera and mirroring.
- **RECORD** → records a clip → analyzes it → results screen → **export** opens the share sheet (JSON + video).
- **3D Skeleton** card → drag to rotate, pinch to zoom; Live Angles panel updates.
- First launch pops the **camera permission** dialog — tap Allow.
