# PoseWeave

**On-device, real-time human pose detection for Flutter.**

PoseWeave turns the camera (or an uploaded video / image) into a 33-landmark
skeleton, a 3D viewer, gait & segment analytics, exercise rep counting and
yoga-pose matching, full PDF reports, and AI coaching tips — all running
**offline** on the phone. The pose data never leaves the device.

> **Platform:** Android-first. iOS targets are configured (deployment target
> 15.5, Info.plist usage strings) but compilation requires a macOS + Xcode
> machine. **ML Kit live detection only runs on a physical device**, not
> emulators (a mock-mode toggle is provided for emulator/UI work).

---

## Highlights

| Area | What you can do |
| --- | --- |
| **Live Camera** | Real-time 2D skeleton overlay (33 landmarks), confidence + FPS HUD, front/back flip, record-then-analyze (synchronized video + pose JSON). |
| **Video Analysis** | Pick a clip → frame-by-frame detection → scrub the poses overlaid on the real frames → export JSON + the source video. |
| **Image Analysis** | Single-shot detection with skeleton / joint angles / landmark coordinate views. |
| **3D Skeleton** | Gesture-controlled (rotate + zoom) 3D view with a live joint-angle panel. |
| **Gait Analysis** | Cadence, symmetry, knee flexion, arm swing, stance/swing, estimated speed → on-screen report + **PDF**. |
| **Segment Analysis** | Live per-limb classification (valgus / varus / hyperextended / neutral) for L/R arm + leg. |
| **Rep Counter** | Squats, push-ups, sit-ups, bicep curls, jumping-jacks — Schmitt-hysteresis state machine on a per-exercise angle signal, with phase and form feedback. |
| **Pose Coach (Yoga)** | Rule-based classifier matches the live pose against angle templates (T-Pose, Mountain, Chair, Goddess, Warrior, …) and gives per-joint correction hints. |
| **Clinical / Diagnostic Mode** | Portal login → HIPAA consent → diagnostic hub with Live, Biomechanical, 3D Reconstruction and Clinical Gait Report screens, all reusing the same pipeline under clinical chrome. *(UI-only mock; not a medical device — see Disclaimers.)* |
| **AI recommendations** | Sends the measured gait + segment data to **Google Gemini** (with an Anthropic Claude **BYOK** key as fallback) for physiotherapy/coaching tips that drop into the PDF. |
| **"No human detected"** | Live + analysis flows refuse to produce results without a person — a watchdog flips the UI to a clear *"No human detected"* state instead of an empty/zeroed report. |

The visual source of truth is in **`design/`** (per-screen HTML mockups +
screenshots + `cyber_kinetic_precision/DESIGN.md`).

---

## Architecture

Strict **Clean Architecture + BLoC**, with `get_it` + `injectable` for DI.

```
presentation/  →  domain/  →  data/
   (UI, BLoC)     (entities,    (ML Kit / camera /
                  abstract      video / repository
                  repository)   impl, services)
```

- ML Kit and `camera` types **never leak above the data layer** (one documented
  carve-out: `CameraController` is exposed so the preview can render).
- State management is **`flutter_bloc` only**. A single `PoseBloc` drives the
  camera/video/image lifecycle through `freezed` event/state unions
  (`PoseLoading / Streaming / Searching / Active / VideoProcessing /
  VideoComplete / ImageProcessing / ImageComplete / ReportGenerating /
  ReportReady / Error / NoPermission`, …).
- Skeleton rendering is done with `CustomPainter` (`PoseOverlayPainter` for 2D,
  `Skeleton3DPainter` for 3D), not widgets — fast and flicker-free.
- See **`CLAUDE.md`** for the full architectural rules, conventions, and the
  "easy to get wrong" list. See **`PRD.md`** for the original spec.

```
lib/
  core/                constants, theme, utils (PoseMath, GaitAnalyzer,
                       SegmentAggregator, RepCounter, PoseClassifier,
                       OneEuroFilter, PersonTracker, ClinicalAssessment, …)
  domain/              entities + abstract PoseRepository
  data/                datasources (ML Kit camera, video frames),
                       repository impl, services (PDF, recommendations,
                       Gemini/Claude prompts, secure key storage), network
  presentation/        pages, widgets, BLoC
```

## Tech stack

Flutter 3.29.2 / Dart 3.7.2 (FVM-pinned; `.fvmrc` checked in) ·
`flutter_bloc 8` · `freezed 2` · `get_it` / `injectable` ·
`google_mlkit_pose_detection` · `camera` (CameraX) · `video_thumbnail` +
`video_player` · `pdf` / `printing` · `flutter_dotenv` (Gemini) ·
`flutter_secure_storage` (Claude BYOK) · `dio` + `sqflite` +
`connectivity_plus` (cloud client foundation) · `google_fonts` (Inter +
JetBrains Mono).

Android NDK pinned to **`27.0.12077973`** in `android/app/build.gradle.kts`.

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after freezed/injectable/json changes
flutter analyze
flutter test
flutter build apk --debug
```

### AI recommendations — set your Gemini key (optional but recommended)

```bash
cp .env.example .env
# then edit .env:
#   GEMINI_API_KEY=AIza...          # get one at https://aistudio.google.com/apikey
#   GEMINI_MODEL=gemini-2.0-flash   # optional (default)
```

`.env` is **git-ignored** and bundled into the APK at build time, so rebuild
after changing the key. Without a Gemini key the app falls back to an
Anthropic Claude BYOK key entered in the in-app Settings; without either, the
recommendations card explains how to add one.

### Running on a real device

Detection only works on hardware. Two PowerShell helpers handle the install
and log capture (and call each other for an install → run → capture-logs flow):

```powershell
./scripts/install_apk.ps1 -Build -Launch -Logs    # build, install (with retries), launch, dump logs
./scripts/device_logs.ps1 -Follow                 # stream device logs to build/device.log
./scripts/device_logs.ps1 -Install -Follow        # install+launch, then stream
```

Device logs land in **`build/device.log`** (Flutter `debugPrint` + BLoC
transitions + crashes). See `scripts/RUN_ON_DEVICE.md` for one-time phone
setup. On emulators, **triple-tap** the app title to toggle mock mode
(synthetic pose) for UI work.

### Testing

```bash
flutter test
```

Coverage spans the math (`PoseMath`, `GaitAnalyzer`, `ClinicalAssessment`),
the rep counter and pose classifier, the YUV_420_888 → NV21 conversion, the
person tracker / one-euro filter, model JSON round-trips, the `PoseBloc`
state machine, and widget smoke tests.

## Project layout

```
android/   ios/           platform configs (Android verified; iOS unverified)
assets/    images/        app icons + bundled assets
design/                   per-screen HTML mockups + design system spec
lib/                      app source (see Architecture above)
scripts/                  install_apk.ps1, device_logs.ps1, RUN_ON_DEVICE.md
test/                     unit + widget tests
.env.example              copy to .env and add your Gemini key (ignored)
CLAUDE.md                 architecture rules, conventions, gotchas
PRD.md                    original product / tech spec
README.md                 this file
```

## Status

- `flutter analyze` clean.
- All unit + widget tests pass (currently **76 tests**).
- Debug APK builds and installs on a connected Android device.
- Live ML Kit detection is validated on physical hardware. Round-by-round
  on-device fixes (camera format YUV_420_888 → NV21 for CameraX, lifecycle
  hardening, "no human" watchdog, diagnostics HUD) live in `CLAUDE.md`.

## Disclaimers

- This is a **technology demo**, **not a medical device**.
- All clinical login, patient records, SSO/SmartCard, DICOM export, and
  referral flows are **UI-only mocks** — no PHI is collected, stored, or
  transmitted.
- "mm" landmark values and the gait *speed* / leg-rotation estimates are
  **uncalibrated heuristics** derived from 2D + ML Kit Z, labelled as such in
  the UI (`~ EST`). They are not clinical measurements.
- The Anthropic Claude key is **BYOK** and stored encrypted on-device; the
  Gemini key lives in a git-ignored `.env`. Neither key is bundled with the
  source.
