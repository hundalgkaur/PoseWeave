# PoseWeave — Flutter Pose Tracker & 3D Skeleton
## Product Requirements Document (PRD)
**Version:** 1.0  
**Date:** 2026-05-22  
**Platform:** Android (Phase 1) → iOS (Phase 2)  
**Type:** Demo/Showcase Application with Extensible Architecture  
**Target:** Hand-off ready for immediate development

---

## 1. Executive Summary

PoseWeave is a Flutter-based real-time human pose detection and 3D skeleton visualization application. The app uses on-device ML (Google ML Kit) to detect 33 body landmarks from live camera feed or uploaded video files, renders a 2D skeleton overlay, and provides a foundation for 3D projection. Built with Clean Architecture and BLoC pattern for enterprise-grade maintainability.

**Key Value Propositions:**
- Zero API costs — 100% on-device inference
- Works offline — no internet required for pose detection
- Extensible architecture — swap ML Kit for TensorFlow Lite without touching UI
- Dual input — live camera + video file analysis
- Interview-grade code quality with production patterns

---

## 2. Success Criteria & Acceptance Checklist

### Phase 1 Acceptance (MVP — Must Pass)
- [ ] App launches without crash on Android physical device
- [ ] Camera permission requested with educational rationale
- [ ] Real-time camera feed displays at ≥30 FPS
- [ ] Skeleton overlay (2D) renders 33 landmarks with bone connections
- [ ] Color-coded bones by body region (face, torso, arms, legs)
- [ ] Confidence-based visibility (hide low-confidence landmarks)
- [ ] Video file upload and pose analysis works
- [ ] BLoC state management handles all camera lifecycle events
- [ ] Clean Architecture folder structure strictly followed
- [ ] No memory leaks on camera screen exit

### Phase 2 Acceptance (3D + Polish — Pass if Time)
- [ ] 3D skeleton view with gesture-controlled rotation
- [ ] Joint angle measurement (click 3 joints → display angle)
- [ ] Recording mode: save pose data as JSON + synchronized video
- [ ] Professional UI theme with dark mode
- [ ] Export/share functionality for pose data
- [ ] iOS build compiles and runs

---

## 3. Tech Stack Specification

### 3.1 Core Dependencies

| Package | Version | Purpose | Senior Rationale |
|---------|---------|---------|------------------|
| `flutter_bloc` | ^8.1.3 | State Management | Stream-based, perfect for camera frame pipelines. User has prior experience. |
| `camera` | ^0.10.5+9 | Camera access | Official plugin, handles orientation & lifecycle correctly. |
| `google_mlkit_pose_detection` | ^0.12.0 | Pose inference | On-device, 33 landmarks, zero cost, Google maintained. |
| `image_picker` | ^1.0.7 | Video upload | Standard file selection from gallery. |
| `video_player` | ^2.8.1 | Video preview | Frame extraction preview before analysis. |
| `permission_handler` | ^11.0.1 | Runtime permissions | Single source of truth for camera/storage/mic. |
| `get_it` | ^7.6.4 | Dependency Injection | Testable architecture, swap datasources without UI changes. |
| `injectable` | ^2.3.2 | DI code generation | Reduces boilerplate, compile-time safety. |
| `freezed` | ^2.4.5 | Immutable models | Union types for states/events, JSON serialization. |
| `json_serializable` | ^6.7.1 | JSON codegen | Type-safe export/import of pose data. |
| `path_provider` | ^2.1.1 | File system access | Cache directory for temporary video processing. |
| `share_plus` | ^7.2.1 | Data export | Share JSON/video files via native share sheet. |
| `vector_math` | Built-in | 3D mathematics | No extra dependency, Matrix4/Vector3 for 3D projection. |

### 3.2 Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | ^2.4.7 | Code generation runner |
| `injectable_generator` | ^2.4.1 | DI generation |
| `freezed_annotation` | ^2.4.1 | Freezed annotations |

### 3.3 pubspec.yaml Template

```yaml
name: poseweave
description: Real-time pose detection and 3D skeleton visualization
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  camera: ^0.10.5+9
  image_picker: ^1.0.7
  video_player: ^2.8.1
  google_mlkit_pose_detection: ^0.12.0
  permission_handler: ^11.0.1
  get_it: ^7.6.4
  injectable: ^2.3.2
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  path_provider: ^2.1.1
  share_plus: ^7.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  injectable_generator: ^2.4.1

flutter:
  uses-material-design: true
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
    - family: RobotoMono
      fonts:
        - asset: assets/fonts/RobotoMono-Regular.ttf
```

---

## 4. System Architecture

### 4.1 Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │  HomePage    │  │ CameraPage   │  │ Skeleton3DPage     │   │
│  │  (Mode Select)│  │ (Real-time)  │  │ (3D Projection)    │   │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘   │
│         └─────────────────┴───────────────────────┘              │
│                         │                                        │
│              ┌──────────▼──────────┐                            │
│              │   PoseBloc            │                            │
│              │  ├─ PoseEvent        │                            │
│              │  └─ PoseState         │                            │
│              └──────────┬───────────┘                            │
└───────────────────────┬──────────────────────────────────────────┘
                        │
┌───────────────────────▼──────────────────────────────────────────┐
│                       DOMAIN LAYER                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐     │
│  │ PoseEntity   │  │ LandmarkEntity│  │ PoseRepository   │     │
│  │ (Aggregate)  │  │ (Value Obj)   │  │ (Abstract)       │     │
│  └──────────────┘  └──────────────┘  └──────────────────┘     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐     │
│  │ UseCase:     │  │ UseCase:     │  │ UseCase:         │     │
│  │ DetectFromCam│  │ DetectFromVid│  │ CalcJointAngle   │     │
│  └──────────────┘  └──────────────┘  └──────────────────┘     │
└───────────────────────┬──────────────────────────────────────────┘
                        │
┌───────────────────────▼──────────────────────────────────────────┐
│                        DATA LAYER                                │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐    │
│  │ MLKitCameraDS    │  │ VideoFrameDS     │  │ PoseRepoImpl │    │
│  │ (Live stream)    │  │ (File processor) │  │ (Coordinator)│    │
│  └──────────────────┘  └──────────────────┘  └──────────────┘    │
│  ┌──────────────────┐  ┌──────────────────┐                       │
│  │ PoseModel        │  │ LandmarkModel    │                       │
│  │ (MLKit Mapper)   │  │ (JSON Mapper)    │                       │
│  └──────────────────┘  └──────────────────┘                       │
└──────────────────────────────────────────────────────────────────┘
```

### 4.2 Data Flow (Camera Mode)

```
CameraController.imageStream
         │
         ▼
┌─────────────────┐
│ MLKitCameraDS   │  →  InputImage.fromBytes()
│ (InputImage     │  →  poseDetector.processImage()
│   converter)    │
└────────┬────────┘
         │ List<Pose>
         ▼
┌─────────────────┐
│ PoseModelMapper │  →  Map MLKit Pose → PoseModel
│ (Data Layer)    │
└────────┬────────┘
         │ PoseModel
         ▼
┌─────────────────┐
│ PoseRepository  │  →  Return Stream<PoseEntity>
│ (Domain Bridge) │
└────────┬────────┘
         │ Stream<PoseEntity>
         ▼
┌─────────────────┐
│ PoseBloc        │  →  Throttle: process every 2nd frame
│ (Business Logic)│  →  Emit PoseActive state
└────────┬────────┘
         │ PoseState
         ▼
┌─────────────────┐
│ PoseOverlay     │  →  CustomPainter renders 33 landmarks
│ (UI Widget)     │  →  8 bone groups color-coded
└─────────────────┘
```

---

## 5. Project Folder Structure

```
poseweave/
├── android/                          # Android-specific config
│   └── app/src/main/AndroidManifest.xml  # Permissions declared here
├── ios/                              # iOS config (Phase 2)
├── assets/
│   ├── fonts/                        # Inter + RobotoMono
│   └── images/                       # App icons, empty state illustrations
├── lib/
│   ├── main.dart                     # Entry point, BlocObserver setup
│   ├── app.dart                      # MaterialApp, theme, route generation
│   ├── injection.dart                # get_it initialization + injectable config
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── pose_constants.dart   # 33 landmark indices, bone connections map
│   │   │   ├── app_colors.dart       # Minimal dark theme palette
│   │   │   └── app_theme.dart        # ThemeData definitions
│   │   ├── errors/
│   │   │   ├── failures.dart         # Failure classes (CameraFailure, MLFailure, PermissionFailure)
│   │   │   └── exceptions.dart       # Domain exceptions
│   │   ├── usecases/
│   │   │   └── usecase.dart          # Base abstract class: UseCase<<Type, Params>
│   │   └── utils/
│   │       └── pose_math.dart        # Angle calculation, coordinate transforms, 3D projection helpers
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── pose_entity.dart      # Aggregate: 33 landmarks + timestamp + source
│   │   │   └── landmark_entity.dart  # Value object: x, y, z, confidence, type
│   │   ├── repositories/
│   │   │   └── pose_repository.dart  # Abstract: getCameraStream(), analyzeVideoFile()
│   │   └── usecases/
│   │       ├── detect_pose_from_camera.dart
│   │       ├── detect_pose_from_video.dart
│   │       └── calculate_joint_angle.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── pose_model.dart       # freezed: MLKit ↔ Domain mapper
│   │   │   └── landmark_model.dart   # freezed: individual landmark serialization
│   │   ├── datasources/
│   │   │   ├── mlkit_camera_datasource.dart      # Live camera stream processing
│   │   │   └── video_frame_datasource.dart       # Video file frame extraction + detection
│   │   └── repositories/
│   │       └── pose_repository_impl.dart         # Implements domain contract
│   │
│   └── presentation/
│       ├── bloc/
│       │   ├── pose_bloc.dart        # Business logic: camera lifecycle, frame throttling
│       │   ├── pose_event.dart       # freezed: InitializeCamera, StartDetection, StopDetection, ProcessVideo, PoseDetected
│       │   └── pose_state.dart       # freezed: Initial, Loading, Streaming, Active, Error, VideoProcessing
│       ├── pages/
│       │   ├── home_page.dart        # Mode selector: Camera / Video / 3D
│       │   ├── camera_pose_page.dart # Full-screen camera + overlay
│       │   ├── gallery_pose_page.dart # Video upload + analysis results
│       │   └── skeleton_3d_page.dart # 3D projection view (Phase 2)
│       └── widgets/
│           ├── pose_overlay_painter.dart     # CORE: CustomPainter for 2D skeleton
│           ├── skeleton_3d_painter.dart      # CORE: CustomPainter for 3D projection
│           ├── landmark_dot.dart             # Individual joint visualization
│           ├── confidence_indicator.dart     # Per-landmark confidence bar
│           ├── body_region_legend.dart       # Color key for bone regions
│           ├── mode_selector_card.dart       # Home page navigation cards
│           ├── permission_rationale_dialog.dart
│           └── loading_overlay.dart
│
└── test/                             # Unit tests mirror lib/ structure
    ├── domain/
    ├── data/
    └── presentation/
```

---

## 6. Domain Model Specification

### 6.1 LandmarkEntity (Value Object)

**File:** `lib/domain/entities/landmark_entity.dart`

```dart
import 'package:equatable/equatable.dart';

/// Pose landmark type enumeration
/// Maps 1:1 with Google ML Kit PoseLandmark.landmarkType
enum PoseLandmarkType {
  nose, leftEyeInner, leftEye, leftEyeOuter,
  rightEyeInner, rightEye, rightEyeOuter,
  leftEar, rightEar, leftMouth, rightMouth,
  leftShoulder, rightShoulder, leftElbow, rightElbow,
  leftWrist, rightWrist, leftPinky, rightPinky,
  leftIndex, rightIndex, leftThumb, rightThumb,
  leftHip, rightHip, leftKnee, rightKnee,
  leftAnkle, rightAnkle, leftHeel, rightHeel,
  leftFootIndex, rightFootIndex,
}

class LandmarkEntity extends Equatable {
  final double x;              // Normalized 0.0 - 1.0 (relative to image width)
  final double y;              // Normalized 0.0 - 1.0 (relative to image height)
  final double? z;             // Depth estimate (ML Kit provides approximate depth)
  final double confidence;     // 0.0 - 1.0 detection confidence
  final PoseLandmarkType type; // Semantic landmark identifier

  const LandmarkEntity({
    required this.x,
    required this.y,
    this.z,
    required this.confidence,
    required this.type,
  });

  /// Visibility threshold for UI rendering
  bool get isVisible => confidence >= 0.5;

  /// 3D position vector for projection calculations
  /// Returns Vector3 with z defaulting to 0.0 if not provided

  @override
  List<Object?> get props => [x, y, z, confidence, type];
}
```

### 6.2 PoseEntity (Aggregate Root)

**File:** `lib/domain/entities/pose_entity.dart`

```dart
import 'package:equatable/equatable.dart';
import 'landmark_entity.dart';

enum PoseSource { camera, videoFile, mock }

class PoseEntity extends Equatable {
  final List<<LandmarkEntity> landmarks;  // Always exactly 33 items
  final DateTime timestamp;
  final PoseSource source;
  final Size? imageSize;                  // Original frame dimensions for scaling

  const PoseEntity({
    required this.landmarks,
    required this.timestamp,
    required this.source,
    this.imageSize,
  }) : assert(landmarks.length == 33, 'ML Kit Pose requires exactly 33 landmarks');

  /// Safe accessor by landmark type
  LandmarkEntity? getLandmark(PoseLandmarkType type) {
    try {
      return landmarks.firstWhere((l) => l.type == type);
    } catch (_) {
      return null;
    }
  }

  /// Convenience accessors for major joints
  LandmarkEntity? get nose => getLandmark(PoseLandmarkType.nose);
  LandmarkEntity? get leftShoulder => getLandmark(PoseLandmarkType.leftShoulder);
  LandmarkEntity? get rightShoulder => getLandmark(PoseLandmarkType.rightShoulder);
  // ... etc for all 33

  @override
  List<Object?> get props => [landmarks, timestamp, source, imageSize];
}
```

### 6.3 Pose Bone Topology (Skeleton Rig)

**File:** `lib/core/constants/pose_constants.dart`

```dart
import 'package:flutter/material.dart';

/// Bone connections define which landmarks connect to form skeleton segments.
/// Index corresponds to PoseLandmarkType ordinal value.
class PoseBones {
  PoseBones._();

  /// All bone connections as [startLandmarkIndex, endLandmarkIndex]
  static const List<List<int>> connections = [
    // Face (Cyan)
    [0, 1],   // nose → leftEyeInner
    [1, 2],   // leftEyeInner → leftEye
    [2, 3],   // leftEye → leftEyeOuter
    [3, 7],   // leftEyeOuter → leftEar
    [0, 4],   // nose → rightEyeInner
    [4, 5],   // rightEyeInner → rightEye
    [5, 6],   // rightEye → rightEyeOuter
    [6, 8],   // rightEyeOuter → rightEar
    [0, 9],   // nose → leftMouth
    [0, 10],  // nose → rightMouth

    // Torso (Green)
    [11, 12], // leftShoulder → rightShoulder
    [11, 23], // leftShoulder → leftHip
    [12, 24], // rightShoulder → rightHip
    [23, 24], // leftHip → rightHip

    // Left Arm (Orange)
    [11, 13], // leftShoulder → leftElbow
    [13, 15], // leftElbow → leftWrist
    [15, 17], // leftWrist → leftPinky
    [15, 19], // leftWrist → leftIndex
    [15, 21], // leftWrist → leftThumb

    // Right Arm (Purple)
    [12, 14], // rightShoulder → rightElbow
    [14, 16], // rightElbow → rightWrist
    [16, 18], // rightWrist → rightPinky
    [16, 20], // rightWrist → rightIndex
    [16, 22], // rightWrist → rightThumb

    // Left Leg (Red)
    [23, 25], // leftHip → leftKnee
    [25, 27], // leftKnee → leftAnkle
    [27, 29], // leftAnkle → leftHeel
    [27, 31], // leftAnkle → leftFootIndex

    // Right Leg (Blue)
    [24, 26], // rightHip → rightKnee
    [26, 28], // rightKnee → rightAnkle
    [28, 30], // rightAnkle → rightHeel
    [28, 32], // rightAnkle → rightFootIndex
  ];

  /// Bone index ranges for color assignment
  static const Map<String, List<int>> regionRanges = {
    'face': [0, 9],
    'torso': [10, 13],
    'leftArm': [14, 18],
    'rightArm': [19, 23],
    'leftLeg': [24, 27],
    'rightLeg': [28, 31],
  };

  /// Region colors for instant visual parsing
  static const Map<String, Color> regionColors = {
    'face': Color(0xFF00E5FF),      // Cyan
    'torso': Color(0xFF00E676),      // Green
    'leftArm': Color(0xFFFF9100),    // Orange
    'rightArm': Color(0xFFE040FB),   // Purple
    'leftLeg': Color(0xFFFF5252),    // Red
    'rightLeg': Color(0xFF448AFF),   // Blue
  };

  /// Confidence visualization thresholds
  static const double highConfidence = 0.8;
  static const double mediumConfidence = 0.5;
  static const double lowConfidence = 0.3;
}
```

---

## 7. BLoC State Machine Specification

### 7.1 Events

**File:** `lib/presentation/bloc/pose_event.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pose_event.freezed.dart';

@freezed
class PoseEvent with _$PoseEvent {
  const factory PoseEvent.initializeCamera() = InitializeCamera;
  const factory PoseEvent.startDetection() = StartDetection;
  const factory PoseEvent.stopDetection() = StopDetection;
  const factory PoseEvent.processVideoFile(String filePath) = ProcessVideoFile;
  const factory PoseEvent.poseDetected(PoseEntity pose) = PoseDetected;
  const factory PoseEvent.switchCamera() = SwitchCamera;
  const factory PoseEvent.toggleMockMode() = ToggleMockMode;
}
```

### 7.2 States

**File:** `lib/presentation/bloc/pose_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pose_state.freezed.dart';

@freezed
class PoseState with _$PoseState {
  const factory PoseState.initial() = PoseInitial;
  const factory PoseState.loading() = PoseLoading;
  const factory PoseState.noPermission() = PoseNoPermission;
  const factory PoseState.streaming() = PoseStreaming;           // Camera active, waiting for first pose
  const factory PoseState.active({
    required List<<LandmarkEntity> landmarks,
    required double averageConfidence,
    PoseEntity? lastPose,
  }) = PoseActive;
  const factory PoseState.videoProcessing({
    required double progress,  // 0.0 - 1.0
    required int framesProcessed,
  }) = PoseVideoProcessing;
  const factory PoseState.videoComplete({
    required List<<PoseEntity> poses,
    required Duration videoDuration,
  }) = PoseVideoComplete;
  const factory PoseState.error({
    required String message,
    required bool isRecoverable,
  }) = PoseError;
}
```

### 7.3 Bloc Implementation Rules

**File:** `lib/presentation/bloc/pose_bloc.dart`

**Critical Implementation Rules:**

1. **Frame Throttling:** Process maximum 15 frames per second (every 2nd frame at 30fps) to prevent UI thread blocking and battery drain.

2. **Stream Lifecycle:** 
   - On `InitializeCamera`: Request permissions → initialize CameraController → start image stream
   - On `StartDetection`: Subscribe to ML Kit stream
   - On `StopDetection`: Cancel subscription but keep camera preview alive
   - On `Close()`: Dispose CameraController, cancel all subscriptions

3. **Error Recovery:**
   - Camera permission denied → emit `PoseNoPermission` → show rationale dialog
   - ML Kit initialization failure → emit `PoseError(isRecoverable: true)` → allow retry
   - Frame processing failure → log error, skip frame, continue stream (never crash)

4. **Mock Mode:** When `ToggleMockMode` received, generate synthetic sine-wave landmarks for UI testing without physical device.

---

## 8. UI/UX Specification

### 8.1 Design System (Minimal Phase)

**Color Palette:**
| Token | Hex | Usage |
|-------|-----|-------|
| `background` | `#0A0A0A` | Scaffold background |
| `surface` | `#141414` | Cards, dialogs |
| `surfaceBorder` | `#1E1E1E` | 1px card borders |
| `primary` | `#00E5FF` | Active skeleton, CTAs |
| `textPrimary` | `#FFFFFF` | Headings |
| `textSecondary` | `#A0A0A0` | Body, labels |
| `error` | `#FF5252` | Low confidence, errors |
| `success` | `#00E676` | High confidence |

**Typography:**
| Style | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| `display` | Inter | 32 | 700 | Splash, empty states |
| `heading` | Inter | 24 | 600 | Page titles |
| `body` | Inter | 16 | 400 | Descriptions |
| `data` | RobotoMono | 14 | 500 | Confidence scores, coordinates |
| `caption` | Inter | 12 | 500 | Labels, badges |

**Spacing Scale:** 4px base unit (4, 8, 12, 16, 24, 32, 48, 64)

### 8.2 Screen Specifications

#### Screen 1: Home Page (Mode Selector)

**Route:** `/`  
**Widget:** `HomePage`

**Layout:**
```
┌─────────────────────────────────────┐
│  StatusBar (transparent, white icons)│
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │  PoseWeave                  │   │  ← App logo/name, 32px bold
│  │  Real-time Pose Intelligence│   │  ← Tagline, 16px secondary
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [Icon: Camera]             │   │
│  │  Live Camera                │   │  ← 24px heading
│  │  Real-time 2D skeleton      │   │  ← 14px secondary
│  │  detection from device      │   │
│  │  camera                     │   │
│  │                    [→]      │   │  ← Arrow icon, primary color
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [Icon: Film]               │   │
│  │  Video Analysis             │   │
│  │  Upload video file for      │   │
│  │  frame-by-frame pose        │   │
│  │  extraction                 │   │
│  │                    [→]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [Icon: Cube]               │   │
│  │  3D Skeleton (Beta)         │   │  ← Phase 2
│  │  View pose in 3D space      │   │
│  │  with rotation control      │   │
│  │                    [→]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  [ Version 1.0 • Built with ML Kit ]│  ← Caption, centered
└─────────────────────────────────────┘
```

**Interactions:**
- Card tap → navigate with fade transition
- Card elevation increases on press (0 → 2px shadow)
- Disabled state for 3D if no prior pose data (greyed, 50% opacity)

#### Screen 2: Camera Pose Page

**Route:** `/camera`  
**Widget:** `CameraPosePage`

**Layout:**
```
┌─────────────────────────────────────┐
│ [⚙️]  PoseWeave           [🔄][📊] │  ← AppBar: Settings, SwitchCam, Stats
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ │      [CAMERA PREVIEW]           │ │  ← AspectRatio 9:16 or 3:4
│ │                                 │ │
│ │    [CUSTOM PAINTER OVERLAY]     │ │  ← 33 dots + bones drawn on top
│ │         •───•                   │ │
│ │        /│   │\                  │ │
│ │       • │   │ •                 │ │
│ │      /  │   │  \                │ │
│ │     •   •   •   •               │ │
│ │    /    │   │    \              │ │
│ │   •     •   •     •             │ │
│ │  /      │   │      \            │ │
│ │ •       •   •       •           │ │
│ │                                 │ │
│ │  [Confidence: 92%]  [FPS: 30]   │ │  ← Floating data badges
│ └─────────────────────────────────┘ │
│                                     │
│  [ ◉  Start ]  [ ⏹ Stop ]  [💾]   │  ← Bottom controls
│                                     │
│  ┌──┬──┬──┬──┬──┬──┐              │
│  │🟠│🟣│🔴│🔵│🟢│⚪│  ← Region color legend (tap to toggle)
│  └──┴──┴──┴──┴──┴──┘              │
└─────────────────────────────────────┘
```

**Overlay Specifications:**
- **Landmark dots:** Radius = 4px + (confidence × 4px). White fill, black 1.5px stroke.
- **Bones:** 3px stroke width, rounded caps (`StrokeCap.round`). Color per region.
- **Low confidence (< 0.5):** Dot turns grey `#666666`, bone hidden completely.
- **Medium confidence (0.5-0.8):** Dot yellow `#FFEA00`, bone dashed pattern (Phase 2).
- **High confidence (> 0.8):** Full color, solid line.

**Floating Badges:**
- Top-left: Average confidence percentage with circular progress indicator
- Top-right: Current FPS counter (RobotoMono)
- Bottom-center: Recording indicator (red pulse animation when active)

**Bottom Controls:**
- **Start:** Primary button (cyan), begins pose detection stream
- **Stop:** Error color (red), stops detection but keeps preview
- **Save:** Only active when poses detected, exports current frame data

#### Screen 3: Gallery/Video Analysis Page

**Route:** `/gallery`  
**Widget:** `GalleryPosePage`

**Flow:**
1. **Upload State:** Large dashed border box with "Tap to select video" prompt
2. **Processing State:** Linear progress bar with frame counter ("Processing frame 142/360")
3. **Results State:** 
   - Video player at top (50% height)
   - Pose timeline scrubber below (horizontal scroll of pose thumbnails)
   - Selected frame skeleton overlay on video
   - Landmark data table (scrollable) showing coordinates + confidence for all 33 points

#### Screen 4: 3D Skeleton Page (Phase 2)

**Route:** `/skeleton3d`  
**Widget:** `Skeleton3DPage`

**Layout:**
```
┌─────────────────────────────────────┐
│  3D Skeleton View         [↩ Back] │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ │      [3D CUSTOM PAINTER]        │ │  ← Black background
│ │         •                       │ │
│ │        /│\                      │ │
│ │       • │ •                     │ │
│ │      /  │  \                    │ │
│ │     •   •   •                   │ │
│ │    /    │    \                  │ │
│ │   •     •     •                 │ │
│ │  /      │      \                │ │
│ │ •       •       •               │ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│  [← Drag to rotate →]               │  ← Gesture hint
│                                     │
│  [Reset] [Auto-Rotate] [Export]     │  ← Controls
└─────────────────────────────────────┘
```

**3D Controls:**
- **Horizontal drag:** Rotate skeleton around Y-axis (0° - 360°)
- **Vertical drag:** Rotate around X-axis (-45° to +45°)
- **Pinch:** Zoom in/out (scale 0.5x - 2.0x)
- **Auto-Rotate:** Toggle continuous slow rotation (15°/sec)

---

## 9. Data Layer Implementation

### 9.1 ML Kit Camera Datasource

**File:** `lib/data/datasources/mlkit_camera_datasource.dart`

**Contract:**
```dart
abstract class MLKitCameraDataSource {
  /// Initialize camera with given direction and resolution
  Future<void> initialize({
    required CameraLensDirection direction,
    required ResolutionPreset resolution,
  });

  /// Start streaming pose detection results
  /// Throttled to max 15 FPS internally
  Stream<PoseModel> startPoseStream();

  /// Stop detection but keep camera alive
  Future<void> stopDetection();

  /// Dispose all resources
  Future<void> dispose();

  /// Switch between front/back camera
  Future<void> switchCamera();
}
```

**Implementation Notes:**
- Convert `CameraImage` (YUV420/NV21) to `InputImage` using `InputImage.fromBytes()`
- Must handle image rotation based on device orientation and camera lens direction
- Use `compute()` isolate for heavy format conversion if frame drops observed
- Stream must be `broadcast` to allow multiple listeners (UI + recorder)

### 9.2 Video Frame Datasource

**File:** `lib/data/datasources/video_frame_datasource.dart`

**Contract:**
```dart
abstract class VideoFrameDataSource {
  /// Extract frames from video file and detect poses
  /// Returns stream of progress + final list of poses
  Stream<VideoProcessingProgress> processVideo(String filePath);
}

class VideoProcessingProgress {
  final int currentFrame;
  final int totalFrames;
  final PoseModel? currentPose;
  final double get progress => currentFrame / totalFrames;
}
```

**Implementation Notes:**
- Use `video_player` to get video metadata (duration, dimensions)
- Frame extraction: seek to position every 100ms (10 FPS analysis)
- Convert frame to `InputImage` and run ML Kit detection
- Must dispose video controller after processing

### 9.3 Repository Implementation

**File:** `lib/data/repositories/pose_repository_impl.dart`

**Responsibilities:**
- Coordinate between camera datasource and video datasource
- Map `PoseModel` → `PoseEntity` with timestamp injection
- Handle errors from ML Kit and convert to domain `Failure` types
- Cache last 100 poses in memory for instant playback/review

---

## 10. Core Utilities

### 10.1 Pose Math Utilities

**File:** `lib/core/utils/pose_math.dart`

```dart
class PoseMath {
  PoseMath._();

  /// Calculate angle (in degrees) at vertex point b, between points a-b-c
  /// Used for joint angle measurement (e.g., elbow angle)
  static double calculateAngle3Points(
    LandmarkEntity a,
    LandmarkEntity b,
    LandmarkEntity c,
  ) {
    final ba = Offset(a.x - b.x, a.y - b.y);
    final bc = Offset(c.x - b.x, c.y - b.y);

    final dotProduct = ba.dx * bc.dx + ba.dy * bc.dy;
    final magnitudeBA = math.sqrt(ba.dx * ba.dx + ba.dy * ba.dy);
    final magnitudeBC = math.sqrt(bc.dx * bc.dx + bc.dy * bc.dy);

    if (magnitudeBA == 0 || magnitudeBC == 0) return 0.0;

    final cosAngle = dotProduct / (magnitudeBA * magnitudeBC);
    final clampedCos = cosAngle.clamp(-1.0, 1.0);
    return math.acos(clampedCos) * (180.0 / math.pi);
  }

  /// Convert normalized coordinates (0-1) to canvas coordinates
  static Offset normalizedToCanvas(
    LandmarkEntity landmark,
    Size canvasSize,
    Size imageSize,
  ) {
    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;
    final scale = math.min(scaleX, scaleY); // Maintain aspect ratio

    final offsetX = (canvasSize.width - imageSize.width * scale) / 2;
    final offsetY = (canvasSize.height - imageSize.height * scale) / 2;

    return Offset(
      offsetX + landmark.x * imageSize.width * scale,
      offsetY + landmark.y * imageSize.height * scale,
    );
  }

  /// 3D perspective projection
  /// Projects 3D point to 2D canvas using simple perspective
  static Offset project3DTo2D(
    Vector3 point3D,
    double rotationY,
    double rotationX,
    Size canvasSize,
    double focalLength,
  ) {
    final rotY = Matrix4.rotationY(rotationY);
    final rotX = Matrix4.rotationX(rotationX);
    final combined = rotY * rotX;

    final rotated = combined.transformed3(point3D);
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);

    // Perspective divide
    final scale = focalLength / (focalLength + rotated.z);

    return center + Offset(rotated.x * scale, rotated.y * scale);
  }
}
```

---

## 11. Permission & Platform Configuration

### 11.1 Android Configuration

**File:** `android/app/src/main/AndroidManifest.xml`

Add inside `<manifest>`:
```xml
<!-- Camera permission -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />

<!-- Storage permission (Android 9 and below) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- Features -->
<uses-feature android:name="android.hardware.camera" android:required="true" />
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
```

**File:** `android/app/build.gradle`

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 21  // REQUIRED: ML Kit minimum
        targetSdkVersion 34
        // ...
    }
}
```

### 11.2 iOS Configuration (Phase 2)

**File:** `ios/Runner/Info.plist`

Add:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to detect body poses in real-time.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for video recording with pose data.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select videos for pose analysis.</string>
```

---

## 12. Implementation Roadmap & Checklists

### Phase 1: Foundation (Days 1-2)

**Day 1: Project Setup**
- [ ] `flutter create poseweave --org com.yourname.poseweave`
- [ ] Add all dependencies to `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Configure `analysis_options.yaml` for strict linting
- [ ] Create folder structure (all directories in Section 5)
- [ ] Add font assets and update `pubspec.yaml`
- [ ] Configure `injectable` with `injection.dart`
- [ ] Create `AppColors` and `AppTheme` in `core/constants/`
- [ ] Setup `BlocObserver` for development logging
- [ ] **Checkpoint:** App builds and runs on emulator with blank scaffold

**Day 2: Domain Layer & Models**
- [ ] Implement `LandmarkEntity` with all 33 types
- [ ] Implement `PoseEntity` with validation
- [ ] Create `PoseBones` constants with all connections
- [ ] Implement `PoseRepository` abstract contract
- [ ] Create `Failure` hierarchy (CameraFailure, MLFailure, PermissionFailure)
- [ ] Implement `UseCase` base class
- [ ] Create `PoseModel` with freezed + JSON serialization
- [ ] Create `LandmarkModel` with ML Kit mapping logic
- [ ] **Checkpoint:** Unit tests pass for entity validation and model mapping

### Phase 2: Data & Camera (Days 3-4)

**Day 3: ML Kit Integration**
- [ ] Implement `MLKitCameraDataSource` interface
- [ ] Handle `CameraImage` → `InputImage` conversion (rotation, format)
- [ ] Integrate `PoseDetector` from `google_mlkit_pose_detection`
- [ ] Map ML Kit `PoseLandmark` to `LandmarkModel`
- [ ] Implement frame throttling (max 15 FPS)
- [ ] Handle stream errors gracefully (skip bad frames)
- [ ] Add mock mode with synthetic sine-wave landmarks
- [ ] **Checkpoint:** ML Kit returns 33 landmarks on physical Android device

**Day 4: Video Pipeline**
- [ ] Implement `VideoFrameDataSource`
- [ ] Integrate `image_picker` for video selection
- [ ] Implement frame extraction from video file
- [ ] Run pose detection on extracted frames
- [ ] Create progress stream for UI feedback
- [ ] Implement `PoseRepositoryImpl` coordinating both datasources
- [ ] **Checkpoint:** Can upload video and receive pose sequence

### Phase 3: Presentation & UI (Days 5-6)

**Day 5: BLoC & Camera Screen**
- [ ] Implement `PoseEvent` freezed classes
- [ ] Implement `PoseState` freezed classes
- [ ] Implement `PoseBloc` with all event handlers
- [ ] Add camera permission handling with rationale dialog
- [ ] Build `CameraPosePage` with `CameraPreview`
- [ ] Implement `PoseOverlayPainter` (CustomPainter)
- [ ] Draw 33 landmark dots with confidence-based sizing
- [ ] Draw bones with region colors
- [ ] Add floating confidence badge
- [ ] Add FPS counter
- [ ] **Checkpoint:** Real-time skeleton overlay renders at 30 FPS

**Day 6: Home, Gallery & Polish**
- [ ] Build `HomePage` with mode selector cards
- [ ] Implement navigation with named routes
- [ ] Build `GalleryPosePage` with upload/processing/results states
- [ ] Add video player with pose timeline scrubber
- [ ] Implement landmark data table
- [ ] Add region color legend widget
- [ ] Add loading overlays and error states
- [ ] Implement mock mode toggle for testing
- [ ] **Checkpoint:** All 3 screens functional, smooth navigation

### Phase 4: 3D & Export (Days 7-8, Optional)

**Day 7: 3D Projection**
- [ ] Implement `Skeleton3DPainter` with `vector_math`
- [ ] Add gesture detection for rotation (horizontal/vertical drag)
- [ ] Implement perspective projection math
- [ ] Add zoom controls (pinch + buttons)
- [ ] Add auto-rotation toggle
- [ ] Build `Skeleton3DPage` with controls
- [ ] **Checkpoint:** 3D skeleton rotates smoothly

**Day 8: Export & Professional Polish**
- [ ] Implement JSON export of pose sequence
- [ ] Add `share_plus` integration
- [ ] Implement screenshot capture of skeleton overlay
- [ ] Add professional animations (page transitions, skeleton fade-in)
- [ ] Add haptic feedback on landmark selection
- [ ] Implement joint angle measurement (tap 3 joints)
- [ ] Add dark/light theme toggle
- [ ] **Checkpoint:** App feels production-ready

### Phase 5: Testing & Hardening (Day 9-10)

- [ ] Unit tests: BLoC event/state transitions
- [ ] Unit tests: PoseMath angle calculations
- [ ] Unit tests: Model mapping accuracy
- [ ] Widget tests: Camera page UI states
- [ ] Integration test: Full camera flow
- [ ] Memory profiling: No leaks on screen exit
- [ ] Test on multiple Android devices (different screen sizes)
- [ ] Test orientation changes (portrait/landscape)
- [ ] Handle edge cases: no person in frame, multiple people (ML Kit picks highest confidence)
- [ ] **Final Checkpoint:** App stable, demo-ready

---

## 13. Testing Strategy

### 13.1 Unit Tests

| Target | Coverage | Key Assertions |
|--------|----------|----------------|
| `PoseMath.calculateAngle3Points` | 100% | Right angle = 90°, straight line = 180° |
| `PoseEntity` validation | 100% | 33 landmarks required, correct types |
| `PoseModel` mapping | 100% | MLKit ordinal → PoseLandmarkType correct |
| `PoseBloc` | 80% | Event → State transitions correct |
| `PoseBones.connections` | 100% | 32 bone connections, no duplicate indices |

### 13.2 Widget Tests

| Screen | Scenario |
|--------|----------|
| HomePage | Tap card → navigate to correct route |
| CameraPosePage | Permission denied → show rationale dialog |
| CameraPosePage | Pose detected → overlay renders dots |
| GalleryPosePage | Select video → progress bar updates |
| Skeleton3DPage | Drag gesture → rotation updates |

### 13.3 Integration Tests

```dart
// test/integration/camera_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full camera pose detection flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap live camera card
    await tester.tap(find.text('Live Camera'));
    await tester.pumpAndSettle();

    // Grant permission (if prompted)
    // ... platform-specific permission grant

    // Wait for camera initialization
    await tester.pump(const Duration(seconds: 2));

    // Verify overlay painter exists
    expect(find.byType(PoseOverlayPainter), findsOneWidget);

    // Tap start
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 3));

    // Verify confidence badge appears
    expect(find.textContaining('Confidence'), findsOneWidget);
  });
}
```

---

## 14. Risk Mitigation Matrix

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| ML Kit fails on emulator | High | Medium | Always test on physical device; implement mock mode for emulator development |
| Camera orientation incorrect | Medium | High | Use `camera` plugin's orientation builder; test in both portrait/landscape |
| Memory leak from image stream | Medium | High | Strict Bloc.dispose() with subscription cancellation; use `WeakReference` if needed |
| Frame drops on low-end device | Medium | Medium | Throttle to 15 FPS; reduce camera resolution to `medium` on devices with <4GB RAM |
| Video file too large | Low | Medium | Limit file size to 100MB; process every 2nd frame for long videos |
| Multiple people in frame | Low | Low | ML Kit returns multiple poses; UI displays highest confidence pose only (Phase 1) |
| iOS build issues (Phase 2) | Medium | High | Use `permission_handler` iOS config; test on physical iPhone early |

---

## 15. Performance Benchmarks

| Metric | Target | Measurement |
|--------|--------|-------------|
| Camera preview FPS | ≥ 30 | Flutter DevTools performance overlay |
| Pose detection latency | < 100ms/frame | Custom logging in datasource |
| UI render time | < 16ms/frame | DevTools timeline |
| Memory usage | < 150MB | Android Profiler |
| App cold start | < 2 seconds | Manual stopwatch |
| Video processing | 10 FPS analysis | Progress stream logging |

---

## 16. Code Generation Commands

After any model or DI change, run:

```bash
# Generate freezed models, JSON serialization, and injectable config
dart run build_runner build --delete-conflicting-outputs

# Or watch mode for continuous generation during development
dart run build_runner watch --delete-conflicting-outputs
```

---

## 17. Git Strategy

```bash
# Branch structure for team development
main
├── develop
│   ├── feature/camera-integration
│   ├── feature/video-pipeline
│   ├── feature/3d-skeleton
│   ├── feature/export-functionality
│   └── feature/ui-polish
└── hotfix/memory-leak-camera
```

**Commit Convention:**
- `feat:` New feature
- `fix:` Bug fix
- `refactor:` Code restructuring
- `perf:` Performance improvement
- `test:` Tests only
- `docs:` Documentation

---

## 18. Definition of Done

A feature is complete when:
- [ ] Code compiles with zero warnings (strict linting)
- [ ] Unit tests written and passing (min 80% coverage)
- [ ] Widget tests for UI components
- [ ] Tested on physical Android device
- [ ] No memory leaks (verified with DevTools)
- [ ] Documentation comments on all public APIs
- [ ] PR reviewed and approved
- [ ] Demo screen recording attached to PR

---

## 19. Appendix: ML Kit Landmark Index Reference

| Index | LandmarkType | Body Region |
|-------|-------------|-------------|
| 0 | nose | Face |
| 1 | leftEyeInner | Face |
| 2 | leftEye | Face |
| 3 | leftEyeOuter | Face |
| 4 | rightEyeInner | Face |
| 5 | rightEye | Face |
| 6 | rightEyeOuter | Face |
| 7 | leftEar | Face |
| 8 | rightEar | Face |
| 9 | leftMouth | Face |
| 10 | rightMouth | Face |
| 11 | leftShoulder | Torso |
| 12 | rightShoulder | Torso |
| 13 | leftElbow | Left Arm |
| 14 | rightElbow | Right Arm |
| 15 | leftWrist | Left Arm |
| 16 | rightWrist | Right Arm |
| 17 | leftPinky | Left Arm |
| 18 | rightPinky | Right Arm |
| 19 | leftIndex | Left Arm |
| 20 | rightIndex | Right Arm |
| 21 | leftThumb | Left Arm |
| 22 | rightThumb | Right Arm |
| 23 | leftHip | Torso |
| 24 | rightHip | Torso |
| 25 | leftKnee | Left Leg |
| 26 | rightKnee | Right Leg |
| 27 | leftAnkle | Left Leg |
| 28 | rightAnkle | Right Leg |
| 29 | leftHeel | Left Leg |
| 30 | rightHeel | Right Leg |
| 31 | leftFootIndex | Left Leg |
| 32 | rightFootIndex | Right Leg |

---

**Document Owner:** Product/Architecture Lead  
**Review Cycle:** Weekly during development  
**Distribution:** All Flutter developers, QA team, Interview panel

---

*End of PRD — Ready for development hand-off*
