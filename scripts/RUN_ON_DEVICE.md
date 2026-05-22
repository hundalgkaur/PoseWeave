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
./scripts/install_apk.ps1            # install the existing APK
./scripts/install_apk.ps1 -Build     # rebuild first, then install
./scripts/install_apk.ps1 -Launch    # install, then launch on the phone
```

The script finds `adb`, checks a device is connected, and runs
`adb install -r build/app/outputs/flutter-apk/app-debug.apk`.

## Alternative: run with live logs (best for debugging)

```bash
flutter run -d <device-id>     # builds, installs, runs with hot reload + logs
```

Use `flutter devices` to get the `<device-id>`.

## What to verify on-device

- **Live camera** → START DETECTION → 33-point skeleton tracks at ~30 FPS; confidence badge updates.
- **Preview ↔ overlay alignment** — does the skeleton sit on the body? (Most likely thing to need tuning.)
- **FLIP** front/back camera and mirroring.
- **RECORD** → records a clip → analyzes it → results screen → **export** opens the share sheet (JSON + video).
- **3D Skeleton** card → drag to rotate, pinch to zoom; Live Angles panel updates.
- First launch pops the **camera permission** dialog — tap Allow.
