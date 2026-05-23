# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project State

The **Phase 1 MVP plus the Phase 2 3D viewer are implemented** (at the repo root): all layers built (domain → data → repository → BLoC → UI), DI wired, Android permissions/SDK/NDK configured, and tests written. Verified: `flutter pub get`, code generation, `flutter analyze` (0 issues), `flutter test` (22/22 pass), **and `flutter build apk --debug` succeeds** (debug APK at `build/app/outputs/flutter-apk/app-debug.apk`). NDK is pinned to `27.0.12077973` in `android/app/build.gradle.kts` (all native plugins require it). **Still unverified:** on-device runtime behavior — ML Kit doesn't run on emulators, so verify real detection on a physical Android device; for emulator/UI work use the home-screen triple-tap mock mode. The implementation plan lives at `C:\Users\jaska\.claude\plans\whimsical-cuddling-hinton.md`.

Note: if a clean machine can't download the Gradle distribution (the first build fetches ~217 MB from `services.gradle.org` → GitHub releases and can reset mid-transfer), fetch it directly with a resuming downloader into `~/.gradle/wrapper/dists/gradle-8.10.2-all/<hash>/gradle-8.10.2-all.zip` and the wrapper will unpack it instead of re-downloading.

Key reference docs:
- `PRD.md` — the authoritative spec (tech stack, architecture, domain models, BLoC state machine, screen layouts). Source of truth for *what* to build.
- `Claude_Code_Playbook_PoseWeave.md` — the slice-by-slice build guide and architecture-enforcement rules.
- `design/` — per-screen HTML mockups (`code.html`) + screenshots (`screen.png`), and `design/cyber_kinetic_precision/DESIGN.md` (design-system spec). Visual source of truth for UI.

**Scope:** Phase 1 MVP plus the start of Phase 2. **Done:** Phase 1 (camera/video detection + 2D overlay) and the Phase 2 **3D skeleton viewer** (`skeleton_3d_page.dart` + `skeleton_3d_painter.dart`: gesture rotate/zoom, auto-rotate, perspective grid) with an integrated **joint-angle panel** (knee/elbow/hip via `PoseMath.calculateAngle3Points`). The 3D viewer reads the most recent detected pose (`PoseRepository.recentPoses`) and falls back to `sampleStandingPose()`. Also done: **JSON export/share** via `PoseRepository.exportPosesToJson` (writes to the temp dir, then `share_plus` opens the system share sheet) — wired to the 3D viewer Export button, the video-results download button, and recording. Note: `build.yaml` sets `explicit_to_json: true` so nested model lists serialize. **Recording mode (record-then-analyze)**: the camera Record button records a video clip via the `camera` plugin (`PoseRepository.startVideoRecording`/`stopVideoRecording`), then runs that clip through the existing `analyzeVideo` pipeline for poses — so the video and JSON come from the same file and are synchronized by construction. Detection and video recording are mutually exclusive (the plugin can't stream images for ML Kit and record video at once), so recording pauses live detection; results show in the shared `PoseResultsView` (`lib/presentation/widgets/`), used by both the gallery and camera flows, with an export that bundles the JSON + the recorded video. `PoseResultsView` overlays the skeleton on the **real extracted frame image** (frame paths are threaded through the pipeline into `PoseVideoComplete.framePaths`, index-aligned with poses) and has a play/pause that steps frames at the sample rate. A branded **splash screen** launches first. **iOS** is configured (deployment target 15.5 for ML Kit, `ios/Podfile`, Info.plist usage strings) but **cannot be compiled/verified here** — needs a macOS + Xcode machine.

**Later additions (also done):**
- **Gait Analysis** (`gait_report_page.dart`, `gait_analysis_page.dart`, `core/utils/gait_analyzer.dart`, `GaitParameters`): computes cadence, symmetry, knee flexion, arm swing, stance/swing, and *estimated* speed + leg rotation (tagged "~ EST") from a walking-video pose sequence. Reached from a Home card (pick video) and a button on `PoseResultsView`. All heuristic 2D estimates — not clinical.
- **Image Analysis** (`image_analysis_page.dart`): pick a still image → single-shot detection → skeleton overlay + `JointAnglesPanel` + `LandmarkTable`, switchable via a `SegmentedButton`. New repo/datasource methods `pickImage`/`analyzeImage`; bloc `PickAndAnalyzeImage` → `PoseImageComplete`.
- **Gated login** (`login_page.dart`, `forgot_password_page.dart`, `core/constants/auth_constants.dart`): splash → **login** → home; hardcoded demo account `test@poseweave.app` / `test1234` (shown on screen), no guest skip; logout on the Home top-right. UI-only, no backend.
- **Shared widgets** extracted for reuse: `JointAnglesPanel`, `LandmarkTable`; `kVideoSampleInterval` in `core/constants/analysis_constants.dart`.

**Routes:** splash `/` → login `/login` → home `/home`; plus `/camera` `/gallery` `/skeleton3d` `/gait` `/image` `/forgot-password`.

**Still out of scope:** synchronized live overlay *while* recording (OS/plugin limit), an onboarding screen, and a real auth backend.

**Decisions that diverge from the PRD's pubspec:** repositories return `dartz` `Either<Failure, T>` (added `dartz`); fonts via `google_fonts` (Inter + JetBrains Mono) instead of bundled `.ttf`s; added `share_plus`, `video_thumbnail`, `vector_math`. Dependency versions track current pub releases, not the PRD's 2023 pins, but the bloc-8 / freezed-2 APIs are retained.

## What This App Is

PoseWeave: a Flutter app doing **on-device** real-time human pose detection (Google ML Kit, 33 landmarks) from live camera or uploaded video, rendering a 2D skeleton overlay with a Phase-2 path to 3D projection. No backend, no API costs, works offline. Android first, iOS in Phase 2.

## Commands

```bash
flutter pub get                                          # install deps
dart run build_runner build --delete-conflicting-outputs # REQUIRED after any freezed/json/injectable change
dart run build_runner watch --delete-conflicting-outputs # codegen watch mode during dev
flutter run                                              # run on connected device (see ML Kit caveat below)
flutter analyze                                          # static analysis / lint
flutter test                                             # all tests
flutter test test/path/to/file_test.dart                # single test file
flutter test --name "substring of test name"            # single test by name
```

## Architecture

Strict **Clean Architecture + BLoC**, with `get_it`/`injectable` for DI. The layering and the rationale are non-obvious and load-bearing — read PRD §4–§10 before adding to any layer. Key points:

- **Layer rule:** `presentation` → `domain` → `data`. Domain defines abstract `PoseRepository`; `data` implements it. The whole point of the structure is that ML Kit can be swapped for TensorFlow Lite by replacing a datasource without touching domain or UI — don't leak ML Kit types above the data layer.
- **Two datasources, one repository:** `MLKitCameraDataSource` (live camera image stream) and `VideoFrameDataSource` (frame extraction from a file), coordinated by `PoseRepositoryImpl`, which also maps `PoseModel` → `PoseEntity` and converts ML Kit errors into domain `Failure` types.
- **State management:** a single `PoseBloc` drives all camera/video lifecycle. Events and states are `freezed` union types (`PoseEvent`, `PoseState` with variants like `active`, `videoProcessing`, `noPermission`, `error`). Camera frames flow `CameraController stream → MLKit datasource → repository (Stream<PoseEntity>) → PoseBloc → CustomPainter overlay`.
- **Rendering:** the skeleton is drawn with `CustomPainter` (`PoseOverlayPainter` for 2D, `Skeleton3DPainter` for 3D), not widgets. Bone topology, region→color mapping, and confidence thresholds live in `core/constants/pose_constants.dart` (`PoseBones`).

## Code Conventions (enforced)

These are non-negotiable; `analysis_options.yaml` enforces several of them.
- **No business logic in widgets**, ever. UI reads `PoseState` via `BlocBuilder` and dispatches events — nothing more.
- **No ML Kit types above the data layer**, and no `camera` types except the one documented carve-out: `PoseRepository` exposes `CameraController`/`CameraLensDirection` so the UI can render `CameraPreview`. That is display-only; all camera *control* still flows through repository methods. Nothing above the data layer imports `google_mlkit_*`.
- **State management is `flutter_bloc` only** — no `setState`, `ChangeNotifier`, `provider`, or `Riverpod` for app state.
- **All models are `freezed`** (`PoseModel`, `LandmarkModel`, events, states); all entities are plain `Equatable`. JSON via `json_serializable`.
- **All dependencies are injected** via `get_it` + `injectable`. No service locators reached into from widgets except at the route's `BlocProvider`.
- **Forbidden patterns:** no `print` (use `debugPrint`/`BlocObserver`); no `FutureBuilder` in presentation (use `BlocBuilder`); no `dynamic`; no null-assertion `!` (use `??` or early returns); package imports only (no relative imports).
- **Naming:** files `snake_case.dart`; `[Feature]Bloc`/`Event`/`State`; use-cases `[Action][Entity]` (e.g. `DetectPoseFromCamera`).
- Keep functions small and extract widgets aggressively rather than growing deep trees.

## Critical Constraints (easy to get wrong)

- **ML Kit does not work on most emulators.** Real pose detection must be verified on a physical Android device. For emulator/UI work there is a **mock mode** (synthetic sine-wave landmarks) toggled via a BLoC event — use it instead of expecting live detection.
- **Frame throttling is mandatory.** Process at most ~15 FPS (every 2nd frame at 30fps). Running detection on every frame blocks the UI thread and drains battery.
- **`PoseEntity` invariant:** always exactly 33 landmarks (asserted in the constructor). The 33-type enum and index→landmark mapping must stay 1:1 with ML Kit's ordinals — see PRD §19 for the reference table.
- **Camera lifecycle / leaks:** cancel stream subscriptions and dispose the `CameraController` in `Bloc.close()`. Memory leaks on camera-screen exit are a tracked risk.
- **Image conversion:** `CameraImage` (YUV420/NV21) → `InputImage` must account for device orientation and lens direction; offload heavy conversion to an isolate (`compute()`) if frames drop.
- **Codegen:** `freezed`, `json_serializable`, and `injectable` all rely on generated `*.g.dart`/`*.freezed.dart`/`*.config.dart` files. After editing models, events/states, or DI registrations, re-run `build_runner` or the project won't compile.

## Design System

Implement UI to `design/cyber_kinetic_precision/DESIGN.md`: "Dark Neo-Glassmorphism" — pure-black obsidian background, Electric Cyan (`#00E5FF`) accents with neon bloom for active/tracking states, glass panels (`backdrop-filter: blur`), Inter for chrome, JetBrains Mono for all live numeric data (so digits don't shift width during rapid updates). Semantic green/amber/coral are reserved for bio-feedback states only. Per-screen mockups are in the sibling `design/<screen>/` folders.
