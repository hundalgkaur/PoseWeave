# PoseWeave

On-device, real-time **human pose detection** for Flutter. Uses Google ML Kit
(33 landmarks) from the live camera or an uploaded video/image, renders a 2D
skeleton overlay and a gesture-controlled 3D view, and turns the motion data
into gait/segment analysis, PDF reports, and AI coaching recommendations.
Runs **offline** — detection happens on the device; no pose data leaves it.

> Android-first. iOS targets are configured but unverified (needs a macOS +
> Xcode build). ML Kit detection only runs on **physical** devices, not emulators.

## Features

- **Live Camera** — real-time 2D skeleton overlay, confidence + FPS, front/back
  flip, record-then-analyze.
- **Video Analysis** — pick a clip, extract frames, scrub the detected poses,
  export JSON (+ the source video).
- **Image Analysis** — single-shot detection with skeleton / joint angles /
  landmark coordinates.
- **3D Skeleton** — rotate/zoom a pose in 3D with a live joint-angle panel.
- **Gait Analysis** — cadence, symmetry, knee flexion, arm swing, stance/swing
  and estimated speed from a walking clip → on-screen report + **PDF**.
- **Segment Analysis** — live per-limb angle classification (valgus/varus/etc.).
- **Clinical / Diagnostic Mode** — a clinically-themed surface (portal → consent
  → live / biomechanical / 3D / gait) reusing the same pipeline. All clinical
  auth/patient/DICOM/referral are **UI-only mocks**; "mm" values are uncalibrated
  estimates.
- **AI recommendations** — gait/segment data → physiotherapy/coaching tips via
  **Google Gemini** (key from a local `.env`), with an Anthropic Claude BYOK key
  as fallback.
- **"No human detected"** — live and analysis flows refuse to produce results
  without a person and show a clear prompt instead of empty/zeroed output.

## Architecture

Clean Architecture + BLoC, `get_it`/`injectable` DI. `presentation → domain →
data`; ML Kit/camera types never leak above the data layer (one documented
carve-out: the `CameraController` for the preview). State is a single
`PoseBloc` with `freezed` event/state unions. Skeletons render with
`CustomPainter`. See `CLAUDE.md` for the full architecture and conventions, and
`PRD.md` / `design/` for the spec and per-screen mockups.

```
lib/
  core/            constants, theme, utils (pose math, gait analyzer, …)
  domain/          entities + abstract PoseRepository
  data/            datasources (ML Kit camera, video frames), repository impl, services
  presentation/    pages, widgets, BLoC
```

## Getting started

Requires Flutter (FVM-pinned 3.29.2 / Dart 3.7.2 on the dev machine) and the
Android SDK (NDK `27.0.12077973`).

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after any freezed/injectable/json change
flutter analyze
flutter test
flutter build apk --debug
```

### AI recommendations (optional)

Copy the env template and add your Google Gemini key (the file is git-ignored):

```bash
cp .env.example .env
# then edit .env:
#   GEMINI_API_KEY=AIza...          # https://aistudio.google.com/apikey
#   GEMINI_MODEL=gemini-2.0-flash   # optional
```

The key is bundled at build time, so rebuild after changing `.env`. Without a
Gemini key the app falls back to an Anthropic key entered in Settings; without
either, the recommendations section shows a "no key" prompt.

## Running on a device

ML Kit needs real hardware. See `scripts/RUN_ON_DEVICE.md` for setup. The two
PowerShell helpers are linked and handle the flaky USB on this device:

```powershell
./scripts/install_apk.ps1 -Build -Launch -Logs   # build, install (with retries), launch, dump logs
./scripts/device_logs.ps1 -Follow                # stream device logs to build/device.log
./scripts/device_logs.ps1 -Install -Follow       # install+launch, then stream
```

Device logs land in `build/device.log` (Flutter `debugPrint` + BLoC transitions
+ crashes). On emulators, triple-tap the title to toggle **mock mode** (synthetic
pose) for UI work.

## Testing

`flutter test` — unit tests for pose math, gait/clinical assessment, the rep
counter, the YUV→NV21 conversion, model round-trips, the `PoseBloc`, and widget
smoke tests.

## Status & honesty

- Built, analyzed clean, and unit-tested; debug APK builds and installs.
- On-device live detection is validated on a physical Android device (ML Kit
  can't run on emulators).
- Clinical auth/records/SSO/DICOM/referral are mocks; gait "speed"/leg-rotation
  and clinical "mm" values are heuristic 2D estimates, not clinical measurements.
- Not a medical device.
