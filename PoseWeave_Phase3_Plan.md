# PoseWeave — Phase 3 Master Plan

**Version:** 1.0
**Date:** 2026-05-23
**Status:** Ready for Claude Code execution
**Scope:** Flutter enhancements + Backend (Node.js/Express/Prisma) + Integration
**Estimated effort:** ~14 dev days
**Infrastructure cost:** $0/month (free tier across the stack)
**Build with:** Anthropic Claude Code CLI on i7 laptop, test on Redmi 12 GB Android

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [What's Already Built](#2-whats-already-built)
3. [Architectural Decisions for Phase 3](#3-architectural-decisions-for-phase-3)
4. [BYOK — Bring Your Own Key Architecture](#4-byok--bring-your-own-key-architecture)
5. [Sprint Roadmap Overview](#5-sprint-roadmap-overview)
6. [Flutter Sprint F1 — Angle Engine + Segment Dashboard](#6-flutter-sprint-f1--angle-engine--segment-dashboard)
7. [Flutter Sprint F2 — PDF Report Generator](#7-flutter-sprint-f2--pdf-report-generator)
8. [Flutter Sprint F3 — AI Recommendations (BYOK)](#8-flutter-sprint-f3--ai-recommendations-byok)
9. [Backend Sprint B1 — Project Setup + Auth](#9-backend-sprint-b1--project-setup--auth)
10. [Backend Sprint B2 — Sync + Analytics + Leaderboard](#10-backend-sprint-b2--sync--analytics--leaderboard)
11. [Integration Sprint I1 — Flutter ↔ Backend Sync Client](#11-integration-sprint-i1--flutter--backend-sync-client)
12. [CLAUDE.md Updates Needed](#12-claudemd-updates-needed)
13. [Quality Gates per Sprint](#13-quality-gates-per-sprint)
14. [Definition of Done](#14-definition-of-done)
15. [Appendix A — Exact Claude Code Prompts](#15-appendix-a--exact-claude-code-prompts)
16. [Appendix B — File Manifest](#16-appendix-b--file-manifest)

---

## 1. Executive Summary

PoseWeave already has a working Phase 1 MVP + Phase 2 3D viewer + Gait Analysis + Image Analysis with strict Clean Architecture + BLoC. Phase 3 adds four user-facing capabilities and the optional cloud backend:

| Capability | What it adds | Where it lives |
|---|---|---|
| Per-segment dashboard | Left/right arm + leg cards with inside/outside angle classification | Flutter UI + `core/utils` |
| PDF report | Shareable session report with charts + AI summary | Flutter `data/services` |
| AI recommendations (BYOK) | Physiotherapy advice from Claude API using user's own key | Flutter `data/services` + Settings |
| Cloud sync (optional) | JWT auth + session sync + analytics + leaderboard | Separate Node.js repo |

The four are independent enough that you can ship F1 and F2 without ever touching the backend. The backend unlocks the social/leaderboard features but is genuinely optional — the app remains offline-first.

**Critical architectural change in this plan vs the earlier draft:** the Claude API key is **not bundled with the app**. Each user provides their own Anthropic API key in Settings (BYOK pattern). This means zero ongoing API costs to you, zero abuse risk, and a clean privacy story for the App Store.

---

## 2. What's Already Built

From the current `CLAUDE.md` on `feature/poseweave-mvp-phase2`:

### Done
- Phase 1 MVP: camera/video detection + 2D skeleton overlay
- Phase 2 3D viewer: gesture rotate/zoom, auto-rotate, perspective grid, joint-angle panel (knee/elbow/hip)
- JSON export/share via `PoseRepository.exportPosesToJson` + `share_plus`
- Recording mode (record-then-analyze): camera Record → video file → existing `analyzeVideo` pipeline
- `PoseResultsView` with real frame overlay + play/pause
- Splash screen, onboarding (3-slide, `shared_preferences` persisted)
- Gated login (demo creds in `auth_constants.dart`)
- Gait Analysis page: cadence, symmetry, knee flexion, arm swing, stance/swing, estimated speed
- Image Analysis page: still image → skeleton + joint angles + landmark table
- Shared widgets: `JointAnglesPanel`, `LandmarkTable`
- iOS configured (deployment target 15.5, Info.plist usage strings)
- 22/22 tests passing, `flutter analyze` clean, debug APK builds

### Architecture in place
- Strict Clean Architecture: `data/` → `domain/` → `presentation/`
- BLoC 8 + freezed events/states
- `get_it` + `injectable` for DI
- `dartz Either<Failure, T>` return types from repositories
- Cyber Kinetic Precision design system (dark, Electric Cyan `#00E5FF`, glass panels)

### Gaps that this plan fills
- No per-segment dashboard with valgus/varus classification
- No PDF export of session data
- No AI-generated recommendations
- No cloud sync, leaderboard, or session history beyond current session
- Temporal jitter on live skeleton (smoothing not applied)
- 3D viewer may not be using ML Kit Z-depth (verify in Sprint F1)

---

## 3. Architectural Decisions for Phase 3

These decisions are deliberate and worth pinning in `CLAUDE.md`:

### 3.1 Where new code lives

| Component | Layer | Path | Why |
|---|---|---|---|
| `AngleClassification` enum + functions | core/utils | `lib/core/utils/pose_math.dart` (extend) | Pure logic, reusable across UI and PDF |
| `SegmentDashboardPage` | presentation | `lib/presentation/pages/` | Reads existing `PoseBloc` state |
| `SegmentDetailCard` | presentation | `lib/presentation/widgets/` | Composable, used in dashboard + report preview |
| `PdfReportService` | data/services | `lib/data/services/` | Uses platform APIs (file system, share) |
| `RecommendationService` | data/services | `lib/data/services/` | External API call → data layer |
| `ApiKeyService` | data/services | `lib/data/services/` | Wraps `flutter_secure_storage` |
| `SettingsPage` | presentation | `lib/presentation/pages/` | UI for BYOK + preferences |
| `LocalSessionDataSource` | data/datasources | `lib/data/datasources/` | Offline SQLite mirror |
| `PoseApiClient` | data/network | `lib/data/network/` (new folder) | dio client for backend |
| `SyncRepository` | data/repositories | `lib/data/repositories/` | Coordinates local + remote |

### 3.2 What does NOT change

- Existing `PoseBloc` event/state names — only additions, never renames (avoids breaking the working camera/video flow)
- Existing `PoseRepository` contract — only extensions, no breaking changes
- The Cyber Kinetic Precision design system — new widgets match existing tokens
- The "no ML Kit types above the data layer" rule — still enforced
- Demo login flow continues to work even after real auth is added (toggleable)

### 3.3 Forbidden in Phase 3

- No moving business logic into widgets, ever — phase 3 violates this if you let it
- No hardcoded API keys anywhere in the repo (BYOK is non-negotiable)
- No `setState`, `Provider`, `Riverpod`, `ChangeNotifier` — still `flutter_bloc` only
- No skipping `dart run build_runner build` after freezed/injectable changes
- No backend dependency in any non-network code path (offline-first invariant)

---

## 4. BYOK — Bring Your Own Key Architecture

This is the central decision for Sprint F3 and worth explaining in detail before the sprint section.

### 4.1 Why BYOK

| Option | Cost to you | Abuse risk | Privacy story | App Store risk |
|---|---|---|---|---|
| Bundled API key | Scales with users | High (key extraction) | Weak | Likely rejected |
| Backend proxies the key | Server costs + rate limits | Medium | Medium | OK |
| BYOK (this plan) | Zero | Zero | Strong | Best |

BYOK also means the app works with any Anthropic-compatible endpoint, including future provider swaps.

### 4.2 User flow

```
First time user taps "Generate AI recommendations"
    ↓
App checks if API key is stored
    ↓
No key → navigate to Settings → "AI Recommendations" section
    ↓
User pastes key (or taps "Get one from Anthropic" link)
    ↓
App calls api.anthropic.com/v1/messages with a 1-token test request
    ↓
Success → store in flutter_secure_storage (encrypted)
    ↓
Failure → show specific error: invalid key, no credit, rate limited
    ↓
Now AI recommendations work for all future sessions
```

### 4.3 Storage and security

- Use `flutter_secure_storage: ^9.2.2` — Android Keystore + iOS Keychain backing
- Key stored under fixed name `anthropic_api_key`
- Never logged, never sent to your backend, never written to disk in plain text
- Cleared on logout
- A "Show key" toggle in Settings reveals it (with biometric prompt on iOS)

### 4.4 Failure modes to handle

| Error | UI response |
|---|---|
| No key configured | Modal: "Add your API key in Settings" with deep link |
| Invalid key (401 from Anthropic) | Toast: "Key rejected — check it in Settings" |
| Rate limited (429) | Banner: "Too many requests — try again in a minute" |
| No internet | Banner: "Offline — recommendations need internet" |
| Anthropic API down (5xx) | Toast: "AI service unavailable — try again later" |

### 4.5 What the user sees in Settings

```
┌─────────────────────────────────────┐
│  Settings                  [← Back] │
├─────────────────────────────────────┤
│                                     │
│  AI Recommendations                 │
│  ─────────────────                  │
│                                     │
│  Status: ⬤ Configured                │
│                                     │
│  Your Anthropic API key             │
│  ┌─────────────────────────────┐   │
│  │ sk-ant-•••••••••••••••• [👁]│   │
│  └─────────────────────────────┘   │
│                                     │
│  [ Test connection ] [ Clear key ]  │
│                                     │
│  Don't have a key?                  │
│  Get one at console.anthropic.com → │
│                                     │
│  ─────────────────────              │
│                                     │
│  Privacy                            │
│  Your key is stored encrypted on    │
│  this device only. It is never sent │
│  to PoseWeave servers.              │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. Sprint Roadmap Overview

| Sprint | Days | Track | Headline | Dependencies |
|---|---|---|---|---|
| F1 | 1–2 | Flutter | Angle engine + segment dashboard | None |
| F2 | 3–4 | Flutter | PDF report generator | F1 (for angles in report) |
| F3 | 5–6 | Flutter | AI recommendations (BYOK) | F1 (input data), F2 (output container) |
| B1 | 7–8 | Backend | Project setup + auth | None — can run parallel to F2/F3 |
| B2 | 9–11 | Backend | Sync + analytics + leaderboard | B1 |
| I1 | 12–14 | Integration | Flutter ↔ backend sync client | B2 |

**Parallelisation tip:** If you have momentum on the Flutter side, push through F1→F2→F3 first (6 days), then switch to backend. The backend work is mostly fresh-context — easier when not bouncing between codebases.

---

## 6. Flutter Sprint F1 — Angle Engine + Segment Dashboard

**Days 1–2 · Risk: Low · Files touched: 6**

### 6.1 Goal

Add `AngleClassification` to `PoseMath`, build a 4-card body segment dashboard, and quick-win the existing app with temporal smoothing + Z-depth verification.

### 6.2 Files to create or modify

| File | Action | Lines (estimate) |
|---|---|---|
| `lib/core/utils/pose_math.dart` | Extend with classification | +120 |
| `lib/presentation/pages/segment_dashboard_page.dart` | Create | ~180 |
| `lib/presentation/widgets/segment_detail_card.dart` | Create | ~140 |
| `lib/presentation/widgets/angle_badge_widget.dart` | Create | ~60 |
| `lib/data/datasources/mlkit_camera_datasource_impl.dart` | Add EMA smoothing | +20 |
| `lib/data/models/landmark_model.dart` | Verify z mapping | ~5 (or 0 if already correct) |
| `lib/presentation/widgets/skeleton_3d_painter.dart` | Verify z usage | ~5 (or 0 if already correct) |
| `lib/app.dart` | Add `/segments` route | +3 |
| `lib/presentation/pages/home_page.dart` | Add Segments card | +20 |
| `test/core/utils/pose_math_test.dart` | Extend tests | +80 |

### 6.3 The angle classification design

`AngleClassification` is the central new concept. Anatomical definitions:

| Joint | Classification options | Trigger thresholds |
|---|---|---|
| Knee | `valgus` (inside collapse), `varus` (outside bow), `neutral`, `hyperflexed`, `extended` | knee_x deviation from hip-ankle midline > 8% of hip width = valgus/varus; angle < 90° = hyperflexed; > 175° = extended |
| Elbow | `hyperflexed` (<30°), `flexed` (30–160°), `extended` (>160°) | Straight angle measurement |
| Hip | `flexed`, `neutral`, `hyperextended` | Trunk-thigh angle |
| Shoulder | `abducted`, `neutral`, `crossed` | Trunk-arm horizontal angle |

```dart
// Skeleton of what goes in pose_math.dart
enum AngleClassification {
  neutral,
  valgus,        // knee collapsing inward (often hip weakness)
  varus,         // knee bowing outward
  hyperflexed,   // joint over-bent
  flexed,        // normal flexion
  extended,      // normal extension
  hyperextended, // joint locked past straight (often injury risk)
  abducted,      // limb away from body midline
  crossed,       // limb crossing midline
}

class AngleAnalysis {
  final double degrees;
  final AngleClassification classification;
  final double confidence; // min of 3 landmark confidences
  final String? riskFlag;  // 'high_valgus', 'knee_lock', etc., or null
  const AngleAnalysis({...});
}

// Add to PoseMath:
static AngleAnalysis analyzeKnee({
  required LandmarkEntity hip,
  required LandmarkEntity knee,
  required LandmarkEntity ankle,
  required bool isLeftSide,
}) { ... }
```

### 6.4 Segment dashboard layout

```
┌─────────────────────────────────────┐
│ [←]  Segment Analysis          [⚙]  │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────────┐  ┌──────────────┐ │
│  │  LEFT ARM    │  │  RIGHT ARM   │ │
│  │              │  │              │ │
│  │    142°      │  │    138°      │ │
│  │  [Flexed]    │  │  [Flexed]    │ │
│  │              │  │              │ │
│  │  Shoulder ●  │  │  Shoulder ●  │ │
│  │  Elbow    ●  │  │  Elbow    ●  │ │
│  │  Wrist    ●  │  │  Wrist    ●  │ │
│  └──────────────┘  └──────────────┘ │
│                                     │
│  ┌──────────────┐  ┌──────────────┐ │
│  │  LEFT LEG    │  │  RIGHT LEG   │ │
│  │              │  │              │ │
│  │    168°      │  │    162°      │ │
│  │ [Valgus ⚠]   │  │  [Neutral]   │ │
│  │              │  │              │ │
│  │  Hip      ●  │  │  Hip      ●  │ │
│  │  Knee     ●  │  │  Knee     ●  │ │
│  │  Ankle    ●  │  │  Ankle    ●  │ │
│  └──────────────┘  └──────────────┘ │
│                                     │
│        [ Generate PDF Report ]      │
│                                     │
└─────────────────────────────────────┘
```

### 6.5 EMA smoothing (the jitter fix)

Add to `MLKitCameraDataSourceImpl`:

```dart
final Map<int, _Smoothed> _ema = {};
static const double _alpha = 0.4; // higher = more responsive

LandmarkModel _smooth(LandmarkModel raw, int index) {
  final prev = _ema[index];
  if (prev == null) {
    _ema[index] = _Smoothed(raw.x, raw.y, raw.z ?? 0, raw.confidence);
    return raw;
  }
  final sx = _alpha * raw.x + (1 - _alpha) * prev.x;
  final sy = _alpha * raw.y + (1 - _alpha) * prev.y;
  final sz = _alpha * (raw.z ?? 0) + (1 - _alpha) * prev.z;
  final sc = _alpha * raw.confidence + (1 - _alpha) * prev.confidence;
  _ema[index] = _Smoothed(sx, sy, sz, sc);
  return raw.copyWith(x: sx, y: sy, z: sz, confidence: sc);
}

// Reset on lifecycle:
@override Future<void> stopDetection() async {
  _ema.clear();
  // ... existing code
}
@override Future<void> switchCamera() async {
  _ema.clear();
  // ... existing code
}
```

### 6.6 Z-depth verification

Two-minute check. Open `landmark_model.dart` and find the ML Kit mapping. It should look like:

```dart
factory LandmarkModel.fromMLKitLandmark(PoseLandmark landmark) {
  return LandmarkModel(
    x: landmark.x,
    y: landmark.y,
    z: landmark.z,  // ← MUST be landmark.z, NOT 0.0 or null
    confidence: landmark.likelihood,
    type: _mapType(landmark.type),
  );
}
```

Then in `skeleton_3d_painter.dart`, the 3D point construction should be:

```dart
final point = Vector3(
  landmark.x * 2 - 1,   // normalize to [-1, 1]
  landmark.y * 2 - 1,
  (landmark.z ?? 0) * 200,  // ← z scaled for visibility, NOT zero
);
```

If either is missing the z, fix it. Expected result: arms and legs visibly move forward/back in 3D view as the user turns.

### 6.7 Tests for F1

```dart
// test/core/utils/pose_math_test.dart additions
group('analyzeKnee', () {
  test('returns valgus when knee deviates inward', () {
    final hip = LandmarkEntity(x: 0.4, y: 0.3, confidence: 0.9, type: leftHip);
    final knee = LandmarkEntity(x: 0.46, y: 0.5, confidence: 0.9, type: leftKnee);
    final ankle = LandmarkEntity(x: 0.35, y: 0.8, confidence: 0.9, type: leftAnkle);

    final result = PoseMath.analyzeKnee(
      hip: hip, knee: knee, ankle: ankle, isLeftSide: true,
    );

    expect(result.classification, AngleClassification.valgus);
    expect(result.riskFlag, 'knee_valgus');
  });

  test('returns neutral for straight leg', () { ... });
  test('returns hyperflexed when angle < 90', () { ... });
});
```

### 6.8 F1 Definition of Done

- [ ] All 4 segment cards render correct data from `PoseBloc.active`
- [ ] EMA smoothing visibly reduces jitter (manual test on Redmi)
- [ ] 3D skeleton shows depth (limbs move forward/back during rotation)
- [ ] `flutter analyze` zero warnings
- [ ] `flutter test` all green including new angle tests
- [ ] Manual test: stand still, knee angle should not flicker > ±2°

---

## 7. Flutter Sprint F2 — PDF Report Generator

**Days 3–4 · Risk: Medium · Files touched: 8**

### 7.1 Goal

Generate a professional PDF report from a completed session. Report contains cover, gait metrics, segment angle summary, skeleton snapshots, and (when available) AI recommendations.

### 7.2 New dependencies

```yaml
dependencies:
  pdf: ^3.10.8        # pure Dart PDF generation
  printing: ^5.13.1   # platform print/share for PDFs
```

After adding, run `flutter pub get` then `dart run build_runner build --delete-conflicting-outputs`.

### 7.3 Files to create

| File | Purpose |
|---|---|
| `lib/data/services/pdf_report_service.dart` | Main service, `@injectable @singleton` |
| `lib/data/services/pdf_page_builders.dart` | Static builders for each page section |
| `lib/data/models/report_data_model.dart` | freezed data bundle passed to the service |
| `lib/core/errors/failures.dart` (extend) | Add `PdfGenerationFailure` |
| `lib/presentation/bloc/pose_event.dart` (extend) | Add `generateReport` event |
| `lib/presentation/bloc/pose_state.dart` (extend) | Add `reportGenerating` + `reportReady` states |
| `lib/presentation/bloc/pose_bloc.dart` (extend) | Handler for the new event |
| `lib/presentation/pages/gait_report_page.dart` (extend) | Export PDF button |

### 7.4 Report structure

```
┌──────────────────────────────────────┐
│         PoseWeave                    │ ← Cover (page 1)
│      Session Report                  │
│                                      │
│   Date: 23 May 2026                  │
│   Duration: 4 min 32 sec             │
│   Exercise: Walking gait             │
│                                      │
│   [skeleton silhouette image]        │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  Gait Metrics                        │ ← Page 2
│                                      │
│  Cadence:       98 steps/min         │
│  Symmetry:      96.3%                │
│  Avg knee flex: 142°                 │
│  Arm swing:     38°                  │
│  Stance/swing:  62 / 38              │
│  Estimated spd: 4.2 km/h ~EST        │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  Joint Angle Summary                 │ ← Page 3
│                                      │
│  ┌──────────┬─────┬─────┬─────────┐ │
│  │ Segment  │ Avg │ Max │ Class.  │ │
│  ├──────────┼─────┼─────┼─────────┤ │
│  │ L arm    │ 142°│ 168°│ Flexed  │ │
│  │ R arm    │ 138°│ 165°│ Flexed  │ │
│  │ L leg    │ 168°│ 178°│ Valgus⚠ │ │
│  │ R leg    │ 162°│ 175°│ Neutral │ │
│  └──────────┴─────┴─────┴─────────┘ │
│                                      │
│  [bar chart of avg angles]           │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  Frame Snapshots                     │ ← Page 4
│                                      │
│  [skeleton overlay images, 4 per pg] │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  AI Recommendations                  │ ← Page 5 (if available)
│                                      │
│  1. Strengthen left hip abductors    │
│     Your left knee shows 12° valgus  │
│     during stance phase, indicating  │
│     weak gluteus medius. Add side    │
│     leg raises 3x/week.              │
│                                      │
│  2. ...                              │
└──────────────────────────────────────┘
```

### 7.5 Service contract

```dart
@injectable
@singleton
class PdfReportService {
  Future<Either<Failure, String>> generateReport({
    required ReportDataModel data,
  }) async {
    try {
      final doc = pw.Document();
      PdfPageBuilders.buildCover(doc, data);
      PdfPageBuilders.buildGaitMetrics(doc, data.gait);
      PdfPageBuilders.buildAngleTable(doc, data.segmentAnalyses);
      if (data.frameImages.isNotEmpty) {
        PdfPageBuilders.buildSnapshots(doc, data.frameImages);
      }
      if (data.recommendations != null && data.recommendations!.isNotEmpty) {
        PdfPageBuilders.buildRecommendations(doc, data.recommendations!);
      }

      final dir = await getTemporaryDirectory();
      final filename = 'poseweave_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(await doc.save());

      return Right(file.path);
    } catch (e, st) {
      debugPrint('PDF generation failed: $e\n$st');
      return Left(PdfGenerationFailure('Could not generate PDF: $e'));
    }
  }
}
```

### 7.6 BLoC wiring

```dart
// In pose_event.dart
const factory PoseEvent.generateReport({
  required ReportDataModel data,
}) = GenerateReport;

// In pose_state.dart
const factory PoseState.reportGenerating() = PoseReportGenerating;
const factory PoseState.reportReady({required String filePath}) = PoseReportReady;
const factory PoseState.reportFailed({required String message}) = PoseReportFailed;

// In pose_bloc.dart constructor
on<GenerateReport>(_onGenerateReport);

Future<void> _onGenerateReport(
  GenerateReport event, Emitter<PoseState> emit) async {
  emit(const PoseState.reportGenerating());
  final result = await _pdfReportService.generateReport(data: event.data);
  result.fold(
    (failure) => emit(PoseState.reportFailed(message: failure.message)),
    (path) => emit(PoseState.reportReady(filePath: path)),
  );
}
```

### 7.7 UI integration

In `gait_report_page.dart`, add the Export button:

```dart
BlocConsumer<PoseBloc, PoseState>(
  listener: (ctx, state) {
    state.whenOrNull(
      reportReady: (path) {
        Printing.sharePdf(bytes: File(path).readAsBytesSync(),
                         filename: path.split('/').last);
      },
      reportFailed: (msg) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
      },
    );
  },
  builder: (ctx, state) {
    final isGenerating = state is PoseReportGenerating;
    return ElevatedButton.icon(
      icon: isGenerating
        ? const CircularProgressIndicator(strokeWidth: 2)
        : const Icon(Icons.picture_as_pdf),
      label: Text(isGenerating ? 'Generating...' : 'Export PDF'),
      onPressed: isGenerating ? null : () {
        ctx.read<PoseBloc>().add(PoseEvent.generateReport(data: _buildData()));
      },
    );
  },
)
```

### 7.8 F2 Definition of Done

- [ ] PDF generates without errors for a completed gait session
- [ ] PDF opens in native viewer on Android (Adobe Reader, Drive, etc.)
- [ ] Skeleton snapshot images embed correctly (not blank rectangles)
- [ ] Share sheet appears via `Printing.sharePdf`
- [ ] File size reasonable (< 2 MB for typical session)
- [ ] BLoC states transition correctly (button disables while generating)
- [ ] Tests added for `PdfReportService` happy path + error case

---

## 8. Flutter Sprint F3 — AI Recommendations (BYOK)

**Days 5–6 · Risk: Medium · Files touched: 11**

### 8.1 Goal

Add Settings page for API key management, build `RecommendationService` that calls Claude API using the user-provided key, integrate recommendations into the gait report and PDF.

### 8.2 New dependencies

```yaml
dependencies:
  flutter_secure_storage: ^9.2.2  # encrypted key storage
  http: ^1.2.2                    # API client (lighter than dio for this use)
```

### 8.3 Files to create

| File | Purpose |
|---|---|
| `lib/data/services/api_key_service.dart` | Secure storage wrapper for the key |
| `lib/data/services/recommendation_service.dart` | Calls Claude API with user's key |
| `lib/data/services/recommendation_prompt_builder.dart` | Structured prompt construction |
| `lib/data/models/recommendation_model.dart` | freezed model: title, detail, severity, bodyPart |
| `lib/domain/entities/recommendation_entity.dart` | Domain entity |
| `lib/presentation/pages/settings_page.dart` | API key UI |
| `lib/presentation/widgets/api_key_field.dart` | Reusable input with show/hide |
| `lib/presentation/widgets/recommendations_panel.dart` | List view in report page |
| `lib/presentation/widgets/recommendation_card.dart` | Single recommendation tile |
| `lib/presentation/bloc/settings_bloc.dart` (new bloc) | Manages API key state |
| `lib/core/errors/failures.dart` (extend) | Add `AiServiceFailure`, `NoApiKeyFailure` |

### 8.4 ApiKeyService contract

```dart
@injectable
@singleton
class ApiKeyService {
  final FlutterSecureStorage _storage;
  static const String _keyName = 'anthropic_api_key';

  ApiKeyService(this._storage);

  Future<String?> getKey() => _storage.read(key: _keyName);

  Future<void> saveKey(String key) => _storage.write(key: _keyName, value: key);

  Future<void> clearKey() => _storage.delete(key: _keyName);

  Future<bool> hasKey() async => (await getKey())?.isNotEmpty ?? false;

  /// Sends a minimal request to verify the key works
  Future<Either<Failure, bool>> testKey(String key) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'x-api-key': key,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-haiku-4-5-20251001',
          'max_tokens': 1,
          'messages': [{'role': 'user', 'content': 'hi'}],
        }),
      );
      if (response.statusCode == 200) return const Right(true);
      if (response.statusCode == 401) return Left(AiServiceFailure('Invalid API key'));
      if (response.statusCode == 429) return Left(AiServiceFailure('Rate limited'));
      return Left(AiServiceFailure('API error ${response.statusCode}'));
    } catch (e) {
      return Left(AiServiceFailure('Network error: $e'));
    }
  }
}
```

### 8.5 RecommendationService contract

```dart
@injectable
@singleton
class RecommendationService {
  final ApiKeyService _keyService;
  RecommendationService(this._keyService);

  Future<Either<Failure, List<RecommendationEntity>>> getRecommendations({
    required GaitParameters gait,
    required Map<String, AngleAnalysis> segmentAnalyses,
  }) async {
    final key = await _keyService.getKey();
    if (key == null || key.isEmpty) {
      return const Left(NoApiKeyFailure('Add your Anthropic API key in Settings'));
    }

    final prompt = RecommendationPromptBuilder.build(gait, segmentAnalyses);

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'x-api-key': key,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-haiku-4-5-20251001',  // cheap + fast for short outputs
          'max_tokens': 1024,
          'system': prompt.system,
          'messages': [{'role': 'user', 'content': prompt.user}],
        }),
      );

      if (response.statusCode != 200) {
        return Left(AiServiceFailure('API returned ${response.statusCode}'));
      }

      final body = jsonDecode(response.body);
      final text = body['content'][0]['text'] as String;
      final recommendations = RecommendationPromptBuilder.parseResponse(text);
      return Right(recommendations);
    } catch (e) {
      return Left(AiServiceFailure('Failed to get recommendations: $e'));
    }
  }
}
```

### 8.6 The prompt design

This is the most important code in F3. Specificity drives quality.

```dart
class RecommendationPromptBuilder {
  static ({String system, String user}) build(
    GaitParameters gait,
    Map<String, AngleAnalysis> segments,
  ) {
    const system = '''You are a sports physiotherapist analysing gait and posture data.
You will receive structured measurements from a pose detection system.
Return ONLY a JSON array, no markdown, no commentary.
Each recommendation must have: title (max 8 words), detail (max 40 words),
severity ("low" | "medium" | "high"), bodyPart (e.g. "left knee", "lower back").
Give 3 to 5 recommendations, prioritised by severity.''';

    final user = '''Subject's gait analysis:
- Cadence: ${gait.cadence.toStringAsFixed(0)} steps/min
- Symmetry: ${(gait.symmetry * 100).toStringAsFixed(1)}%
- Avg knee flexion: ${gait.avgKneeFlexion.toStringAsFixed(0)}°
- Arm swing range: ${gait.armSwing.toStringAsFixed(0)}°
- Stance phase: ${gait.stancePhasePercent.toStringAsFixed(0)}%
- Estimated speed: ${gait.estimatedSpeedKmh.toStringAsFixed(1)} km/h

Segment angle analysis:
${segments.entries.map((e) =>
  '- ${e.key}: ${e.value.degrees.toStringAsFixed(0)}° (${e.value.classification.name})'
  '${e.value.riskFlag != null ? " ⚠ ${e.value.riskFlag}" : ""}'
).join('\n')}

Return JSON array of 3-5 recommendations.''';

    return (system: system, user: user);
  }

  static List<RecommendationEntity> parseResponse(String raw) {
    // Strip markdown fences if present
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceAll(RegExp(r'^```(json)?\n?'), '').replaceAll(RegExp(r'\n?```$'), '');
    }
    final list = jsonDecode(text) as List;
    return list.map((j) => RecommendationEntity(
      title: j['title'] as String,
      detail: j['detail'] as String,
      severity: _parseSeverity(j['severity'] as String),
      bodyPart: j['bodyPart'] as String,
    )).toList();
  }

  static Severity _parseSeverity(String s) {
    switch (s.toLowerCase()) {
      case 'high': return Severity.high;
      case 'medium': return Severity.medium;
      default: return Severity.low;
    }
  }
}
```

### 8.7 Why this prompt works

| Decision | Why |
|---|---|
| `claude-haiku-4-5-20251001` model | Haiku is fast and cheap; recommendations don't need Opus-level reasoning |
| Pass actual numbers, not descriptions | "12° valgus" gives better output than "knee collapse" |
| Demand JSON-only output in system | Cleaner parsing, no markdown-stripping bugs |
| Cap recommendations at 3-5 | Forces prioritisation, prevents wall-of-text |
| Word limits in schema | Keeps output mobile-readable |
| Include risk flags inline | Lets the model focus where it matters |

### 8.8 SettingsBloc

Separate bloc from `PoseBloc` because the lifecycles are different — settings persist across the app, pose state is per-screen.

```dart
@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ApiKeyService _keyService;

  SettingsBloc(this._keyService) : super(const SettingsState.initial()) {
    on<LoadSettings>(_onLoad);
    on<SaveApiKey>(_onSave);
    on<TestApiKey>(_onTest);
    on<ClearApiKey>(_onClear);
  }
  // ... handlers
}
```

### 8.9 F3 Definition of Done

- [ ] Settings page renders, accepts key, masks display by default
- [ ] "Test connection" button verifies key against Anthropic API
- [ ] Key stored encrypted, survives app restart
- [ ] "Generate AI Recommendations" button in gait report works end-to-end
- [ ] Without key: shows friendly modal directing to Settings
- [ ] With invalid key: shows specific 401 error
- [ ] Offline: shows offline banner instead of crashing
- [ ] Recommendations include in PDF when generated
- [ ] No API key ever appears in logs or stack traces

---

## 9. Backend Sprint B1 — Project Setup + Auth

**Days 7–8 · Risk: Low · New repo: poseweave-api**

### 9.1 Goal

Stand up a Node.js + Express + Prisma + PostgreSQL backend with JWT auth, deployed to Render free tier with Neon Postgres and Upstash Redis.

### 9.2 Tech stack confirmation

| Layer | Choice | Reason |
|---|---|---|
| Runtime | Node 20 LTS | Stable, your existing experience |
| Framework | Express 4.x | Minimal, well-known, vast middleware |
| Language | TypeScript 5.x | Type safety, matches Flutter discipline |
| ORM | Prisma 5.x | Type-safe queries, migration system |
| DB | PostgreSQL 15 (Neon free) | Relational, JSONB for landmarks |
| Cache | Redis 7 (Upstash free) | Sessions, rate limit, leaderboard cache |
| Validation | Zod 3.x | TypeScript-first, infer types from schemas |
| Auth | JWT + bcryptjs | Standard, stateless, refreshable |
| Deploy | Render free tier | Zero config, Git push deploys |
| Monitoring | UptimeRobot + Logtail | Free, simple |

### 9.3 Project structure

```
poseweave-api/
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── src/
│   ├── server.ts                  # Express entry point
│   ├── app.ts                     # Middleware wiring
│   ├── config/
│   │   ├── env.ts                 # Validated env vars
│   │   ├── prisma.ts              # Prisma client singleton
│   │   └── redis.ts               # ioredis singleton
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   └── health.controller.ts
│   ├── services/
│   │   ├── auth.service.ts
│   │   └── token.service.ts
│   ├── middleware/
│   │   ├── auth.middleware.ts     # JWT verify
│   │   ├── validate.middleware.ts # Zod factory
│   │   ├── rate-limit.middleware.ts
│   │   └── error.middleware.ts
│   ├── validators/
│   │   └── auth.validator.ts      # Zod schemas
│   ├── routes/
│   │   ├── index.ts               # Router composition
│   │   └── v1/
│   │       ├── auth.routes.ts
│   │       └── health.routes.ts
│   ├── utils/
│   │   ├── api-response.ts        # Envelope helpers
│   │   └── errors.ts              # Custom error classes
│   └── types/
│       └── express.d.ts           # req.user augmentation
├── tests/
│   ├── unit/
│   └── integration/
├── .env.example
├── .gitignore
├── jest.config.ts
├── package.json
├── render.yaml
├── tsconfig.json
└── README.md
```

### 9.4 Initial Prisma schema

Only `User` table in B1. Other tables added in B2.

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id            String    @id @default(uuid())
  email         String    @unique
  passwordHash  String    @map("password_hash")
  displayName   String?   @map("display_name")
  avatarUrl     String?   @map("avatar_url")
  timezone      String    @default("UTC")
  isPremium     Boolean   @default(false) @map("is_premium")
  emailVerified Boolean   @default(false) @map("email_verified")
  createdAt     DateTime  @default(now()) @map("created_at")
  updatedAt     DateTime  @updatedAt @map("updated_at")
  lastSyncAt    DateTime? @map("last_sync_at")

  @@index([email])
  @@map("users")
}
```

### 9.5 Auth endpoints

| Method | Path | Body | Response |
|---|---|---|---|
| POST | `/v1/auth/register` | `{email, password, displayName?}` | `{user, tokens}` |
| POST | `/v1/auth/login` | `{email, password}` | `{tokens}` |
| POST | `/v1/auth/refresh` | `{refreshToken}` | `{tokens}` (rotated) |
| POST | `/v1/auth/logout` | `{refreshToken}` | 204 |
| GET | `/v1/auth/me` | (auth required) | `{user}` |

### 9.6 JWT specifics

- **Access token:** HS256, 15 min expiry, payload `{sub: userId, email, iat, exp}`
- **Refresh token:** HS256, 7 day expiry, stored in Redis as `refresh:{token}` → `userId`
- **Rotation:** every `/refresh` call invalidates the old token and issues a new pair
- **Secrets:** `JWT_SECRET` (access), `JWT_REFRESH_SECRET` (refresh), both 32+ random chars

### 9.7 Response envelope

Every endpoint returns:

```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;    // 'VALIDATION_ERROR', 'AUTH_INVALID', etc.
    message: string;
    details?: unknown;
  };
  meta?: {
    timestamp: string;
    requestId: string;
  };
}
```

### 9.8 Environment variables

```bash
# .env.example
NODE_ENV=development
PORT=3000

DATABASE_URL=postgresql://user:pass@localhost:5432/poseweave?schema=public
REDIS_URL=redis://localhost:6379

JWT_SECRET=change_me_min_32_chars
JWT_REFRESH_SECRET=change_me_min_32_chars
JWT_ACCESS_EXPIRY=900
JWT_REFRESH_EXPIRY=604800

CORS_ORIGIN=http://localhost:8080
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX=200

LOG_LEVEL=info
```

### 9.9 B1 Definition of Done

- [ ] `npm run dev` boots without errors
- [ ] `/v1/health` returns 200 with db + redis status
- [ ] Register → Login → Refresh → Logout flow works in Postman
- [ ] Rate limiting fires on 6th request to `/v1/auth/login` in 15 min
- [ ] Zod rejects malformed payloads with 400 + field details
- [ ] JWT verify middleware blocks unauthenticated `/v1/auth/me`
- [ ] Deployed to Render free tier, accessible at `https://poseweave-api.onrender.com`
- [ ] At least 5 unit tests + 3 integration tests passing

---

## 10. Backend Sprint B2 — Sync + Analytics + Leaderboard

**Days 9–11 · Risk: Medium**

### 10.1 Goal

Add Session, PoseFrame, Challenge tables; implement bulk sync with conflict resolution; add analytics aggregations; build leaderboard with Redis caching.

### 10.2 Prisma schema additions

```prisma
model Session {
  id                String   @id @default(uuid())
  userId            String   @map("user_id")
  deviceId          String   @map("device_id")
  startedAt         DateTime @map("started_at")
  endedAt           DateTime? @map("ended_at")
  durationSeconds   Int?     @map("duration_seconds")
  exerciseType      String   @map("exercise_type")
  totalReps         Int      @default(0) @map("total_reps")
  avgFormScore      Decimal? @map("avg_form_score") @db.Decimal(5, 2)
  maxRom            Decimal? @map("max_rom") @db.Decimal(5, 2)
  minRom            Decimal? @map("min_rom") @db.Decimal(5, 2)
  asymmetryFlag     Boolean  @default(false) @map("asymmetry_flag")
  injuryRiskCount   Int      @default(0) @map("injury_risk_count")
  syncStatus        String   @default("pending") @map("sync_status")
  clientCreatedAt   DateTime @map("client_created_at")
  clientUpdatedAt   DateTime? @map("client_updated_at")
  serverCreatedAt   DateTime @default(now()) @map("server_created_at")
  rawDataUrl        String?  @map("raw_data_url")

  user        User         @relation(fields: [userId], references: [id], onDelete: Cascade)
  poseFrames  PoseFrame[]
  challenges  Challenge[]

  @@unique([userId, deviceId, clientCreatedAt])
  @@index([userId, startedAt(sort: Desc)])
  @@index([deviceId, syncStatus])
  @@map("sessions")
}

model PoseFrame {
  id                String   @id @default(uuid())
  sessionId         String   @map("session_id")
  frameIndex        Int      @map("frame_index")
  timestampMs       Int      @map("timestamp_ms")
  landmarks         Json
  formScore         Decimal? @map("form_score") @db.Decimal(5, 2)
  detectedAsymmetry Boolean  @default(false) @map("detected_asymmetry")
  injuryRiskFlags   Json?    @map("injury_risk_flags")

  session Session @relation(fields: [sessionId], references: [id], onDelete: Cascade)

  @@unique([sessionId, frameIndex])
  @@index([sessionId, frameIndex])
  @@map("pose_frames")
}

model Challenge {
  id                  String    @id @default(uuid())
  userId              String    @map("user_id")
  sessionId           String?   @map("session_id")
  challengeType       String    @map("challenge_type")
  exerciseType        String    @map("exercise_type")
  targetReps          Int?      @map("target_reps")
  timeLimitSeconds    Int?      @map("time_limit_seconds")
  actualReps          Int?      @map("actual_reps")
  actualTimeSeconds   Int?      @map("actual_time_seconds")
  avgFormScore        Decimal?  @map("avg_form_score") @db.Decimal(5, 2)
  grade               String?   @db.Char(1)
  completedAt         DateTime? @map("completed_at")
  createdAt           DateTime  @default(now()) @map("created_at")

  user    User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  session Session? @relation(fields: [sessionId], references: [id], onDelete: SetNull)

  @@index([userId, grade, completedAt(sort: Desc)])
  @@map("challenges")
}

// Update User model to include relations:
// sessions Session[]
// challenges Challenge[]
```

### 10.3 Sync endpoints

#### POST /v1/sync/sessions

Bulk upload with conflict resolution. Critical path code:

```typescript
async syncSessions(userId: string, deviceId: string, payload: SyncPayload) {
  const results: SessionMapping[] = [];

  for (const clientSession of payload.sessions) {
    const existing = await prisma.session.findFirst({
      where: {
        userId,
        deviceId,
        clientCreatedAt: new Date(clientSession.clientCreatedAt),
      },
    });

    if (!existing) {
      const created = await prisma.session.create({
        data: {
          ...this.mapToServerSession(clientSession),
          userId,
          deviceId,
          syncStatus: 'synced',
        },
      });
      results.push({
        clientId: clientSession.clientId,
        serverId: created.id,
        status: 'synced',
      });
    } else if (
      clientSession.clientUpdatedAt &&
      new Date(clientSession.clientUpdatedAt) > (existing.clientUpdatedAt ?? new Date(0))
    ) {
      await prisma.session.update({
        where: { id: existing.id },
        data: {
          ...this.mapToServerSession(clientSession),
          syncStatus: 'synced',
        },
      });
      results.push({
        clientId: clientSession.clientId,
        serverId: existing.id,
        status: 'updated',
      });
    } else {
      results.push({
        clientId: clientSession.clientId,
        serverId: existing.id,
        status: 'conflict',
        serverData: existing,
      });
    }
  }

  await prisma.user.update({
    where: { id: userId },
    data: { lastSyncAt: new Date() },
  });

  return {
    synced: results.filter(r => r.status === 'synced').length,
    updated: results.filter(r => r.status === 'updated').length,
    conflicts: results.filter(r => r.status === 'conflict').length,
    sessionMappings: results,
    serverTimestamp: new Date().toISOString(),
  };
}
```

#### GET /v1/sync/sessions

Delta pull with pagination. Returns sessions newer than `since` timestamp, limited to 50 per page.

### 10.4 Analytics endpoints

| Endpoint | Purpose | Cache |
|---|---|---|
| GET /v1/analytics/summary | Total sessions, total reps, avg form, streak days, favourite exercise | Redis 1h |
| GET /v1/analytics/rom-progress?exercise=squat&period=30d | Time series of avg + max ROM | Redis 1h |
| GET /v1/analytics/weekly?weeks=8 | Per-week aggregates | Redis 1h |

Streak calculation:

```typescript
async getStreak(userId: string): Promise<number> {
  const sessions = await prisma.session.findMany({
    where: { userId, syncStatus: 'synced' },
    select: { startedAt: true },
    orderBy: { startedAt: 'desc' },
  });

  if (sessions.length === 0) return 0;

  let streak = 1;
  let prevDate = new Date(sessions[0].startedAt);
  prevDate.setHours(0, 0, 0, 0);

  for (let i = 1; i < sessions.length; i++) {
    const date = new Date(sessions[i].startedAt);
    date.setHours(0, 0, 0, 0);
    const dayDiff = Math.round((prevDate.getTime() - date.getTime()) / 86400000);
    if (dayDiff === 1) {
      streak++;
      prevDate = date;
    } else if (dayDiff > 1) {
      break;
    }
  }
  return streak;
}
```

### 10.5 Leaderboard

```typescript
async getWeeklyLeaderboard(exerciseType: string, requestingUserId: string) {
  const cacheKey = `leaderboard:${exerciseType}:weekly`;
  const cached = await redis.get(cacheKey);
  if (cached) return JSON.parse(cached);

  const rows = await prisma.$queryRaw<LeaderboardRow[]>`
    SELECT
      u.id as user_id,
      u.display_name,
      COUNT(s.id)::int as session_count,
      SUM(s.total_reps)::int as total_reps,
      AVG(s.avg_form_score)::decimal(5,2) as avg_form,
      RANK() OVER (ORDER BY SUM(s.total_reps) DESC) as rank
    FROM sessions s
    JOIN users u ON s.user_id = u.id
    WHERE s.exercise_type = ${exerciseType}
      AND s.started_at > NOW() - INTERVAL '7 days'
      AND s.sync_status = 'synced'
    GROUP BY u.id, u.display_name
    ORDER BY rank
    LIMIT 50;
  `;

  const userRank = rows.find(r => r.user_id === requestingUserId)?.rank ?? null;

  const result = {
    exercise: exerciseType,
    period: 'weekly',
    leaderboard: rows.map(r => ({ ...r, isCurrentUser: r.user_id === requestingUserId })),
    userRank,
    totalParticipants: rows.length,
  };

  await redis.set(cacheKey, JSON.stringify(result), 'EX', 3600);
  return result;
}
```

### 10.6 Challenges

| Endpoint | Purpose |
|---|---|
| POST /v1/challenges | Create challenge with target + expiry |
| POST /v1/challenges/:id/complete | Submit results, calculate grade |
| GET /v1/challenges | List user's challenges (active + completed) |

Grade formula:

```typescript
function calculateGrade(
  actualReps: number,
  targetReps: number,
  avgFormScore: number,
): 'S' | 'A' | 'B' | 'C' | 'D' {
  if (actualReps >= targetReps && avgFormScore >= 85) return 'S';
  if (actualReps >= targetReps && avgFormScore >= 75) return 'A';
  if (actualReps >= targetReps) return 'B';
  if (actualReps >= targetReps * 0.9) return 'C';
  return 'D';
}
```

### 10.7 B2 Definition of Done

- [ ] All Prisma migrations apply cleanly
- [ ] Sync endpoint handles 100-session bulk upload in < 2s
- [ ] Conflict resolution returns server data correctly
- [ ] Analytics summary returns in < 500ms (cache hit) or < 1s (cache miss)
- [ ] Leaderboard cached for 1 hour, refreshes on miss
- [ ] Challenge grades calculate correctly for boundary cases
- [ ] 15+ unit tests + 8+ integration tests
- [ ] Artillery load test passes 10 req/sec for 60 seconds

---

## 11. Integration Sprint I1 — Flutter ↔ Backend Sync Client

**Days 12–14 · Risk: High (network errors are sneaky)**

### 11.1 Goal

Wire the Flutter app to the deployed backend. Add SQLite local persistence, dio HTTP client, sync repository with exponential backoff, profile + history pages. Replace demo login with real JWT.

### 11.2 New dependencies

```yaml
dependencies:
  sqflite: ^2.3.3       # local SQLite
  dio: ^5.7.0           # HTTP client with interceptors
  connectivity_plus: ^6.0.5  # detect online/offline
```

### 11.3 Files to create

| File | Purpose |
|---|---|
| `lib/data/datasources/local_session_datasource.dart` | SQLite session storage |
| `lib/data/network/pose_api_client.dart` | dio client with typed methods |
| `lib/data/network/auth_interceptor.dart` | Bearer token + refresh on 401 |
| `lib/data/network/token_storage.dart` | flutter_secure_storage for JWT |
| `lib/data/repositories/sync_repository.dart` | Coordinates local + remote |
| `lib/data/repositories/auth_repository.dart` | Real login replacing demo |
| `lib/presentation/pages/profile_page.dart` | User stats + logout |
| `lib/presentation/pages/session_history_page.dart` | List of past sessions |
| `lib/presentation/pages/leaderboard_page.dart` | Top users + own rank |
| `lib/presentation/bloc/sync_bloc.dart` | Background sync state |
| `lib/presentation/bloc/auth_bloc.dart` | Real auth (replaces demo logic in login) |

### 11.4 SQLite schema

```sql
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  server_id TEXT,
  user_id TEXT,
  device_id TEXT NOT NULL,
  started_at INTEGER NOT NULL,
  ended_at INTEGER,
  exercise_type TEXT NOT NULL,
  total_reps INTEGER DEFAULT 0,
  avg_form_score REAL,
  max_rom REAL,
  asymmetry_flag INTEGER DEFAULT 0,
  injury_risk_count INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'local',  -- local, pending, synced, error
  sync_attempts INTEGER DEFAULT 0,
  last_sync_error TEXT,
  last_sync_at INTEGER,
  client_created_at INTEGER NOT NULL,
  client_updated_at INTEGER
);

CREATE INDEX idx_sessions_sync ON sessions(sync_status, client_created_at);
```

### 11.5 Auth interceptor

```dart
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokens;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor(this._tokens, this._dio);

  @override
  Future<void> onRequest(options, handler) async {
    final token = await _tokens.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(err, handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshed = await _refreshTokens();
        if (refreshed) {
          // Retry original request with new token
          final newToken = await _tokens.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err);
  }

  Future<bool> _refreshTokens() async { /* ... */ }
}
```

### 11.6 Sync triggers

The `SyncRepository.sync()` method is triggered by:

1. **App resume** — `WidgetsBindingObserver.didChangeAppLifecycleState` in `app.dart`
2. **Network reconnect** — `connectivity_plus` stream listener
3. **Session complete** — fired from `PoseBloc` after `videoComplete` state
4. **Manual** — pull-to-refresh on history page

Exponential backoff:

```dart
class SyncRepository {
  int _retryCount = 0;
  Timer? _retryTimer;

  Future<Either<Failure, SyncResult>> sync() async {
    final result = await _attemptSync();
    return result.fold(
      (failure) {
        _scheduleRetry();
        return Left(failure);
      },
      (success) {
        _retryCount = 0;
        return Right(success);
      },
    );
  }

  void _scheduleRetry() {
    _retryCount++;
    final delaySeconds = math.min(math.pow(2, _retryCount).toInt(), 3600);
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(seconds: delaySeconds), () => sync());
  }
}
```

### 11.7 Profile page wireframe

```
┌─────────────────────────────────────┐
│  Profile                       [⚙]  │
├─────────────────────────────────────┤
│                                     │
│         ┌───────┐                   │
│         │  GK   │                   │
│         └───────┘                   │
│      Gurleen Kaur                   │
│      gurleen@example.com            │
│                                     │
│  ─────────────────                  │
│                                     │
│  This week                          │
│  ┌─────┬─────┬─────┐                │
│  │  7  │ 240 │ 78% │                │
│  │days │reps │form │                │
│  └─────┴─────┴─────┘                │
│                                     │
│  Squat leaderboard                  │
│  Your rank: 12 of 342               │
│  [ View full leaderboard → ]        │
│                                     │
│  ─────────────────                  │
│                                     │
│  [ Session history ]                │
│  [ Settings ]                       │
│  [ Sign out ]                       │
│                                     │
└─────────────────────────────────────┘
```

### 11.8 I1 Definition of Done

- [ ] Real register → login → token storage → authenticated API call works
- [ ] Logout clears local DB + secure storage
- [ ] Sessions saved offline appear in server after sync
- [ ] Sync survives airplane mode → reconnect cycle
- [ ] 401 auto-refresh works (manually expire token to test)
- [ ] Profile page shows real analytics from backend
- [ ] Leaderboard shows current user's rank
- [ ] Session history shows cloud sync indicator per row
- [ ] No regression: demo offline mode still works if backend is down

---

## 12. CLAUDE.md Updates Needed

Before starting Sprint F1, append this section to your existing `CLAUDE.md`:

```markdown
## Phase 3 Architecture Rules (Non-Negotiable)

### New service locations
- All external API services: `lib/data/services/`
- All network clients: `lib/data/network/`
- All local database sources: `lib/data/datasources/local_*.dart`

### BYOK invariants
- The Anthropic API key is NEVER hardcoded, NEVER in env vars, NEVER in dart-define
- The key is provided by the user at runtime via SettingsPage
- The key is stored in flutter_secure_storage only
- The key is never logged, never sent to PoseWeave backend, never written to disk in plain text
- API calls that need the key must check via ApiKeyService.hasKey() first

### Sync invariants
- SQLite is the source of truth for sessions, never the backend
- Backend is optional sync only — app must function fully offline
- Never block UI on a sync call
- All sync operations use exponential backoff on failure

### BLoC additions only
- PoseBloc events and states are extended in Phase 3, never renamed
- SettingsBloc, AuthBloc, SyncBloc are separate from PoseBloc
- A bloc handles one feature lifecycle — do not merge concerns

### Failure types added
- PdfGenerationFailure
- AiServiceFailure
- NoApiKeyFailure
- SyncFailure
- AuthFailure
- NetworkFailure

### Forbidden patterns (in addition to existing CLAUDE.md rules)
- No `final apiKey = 'sk-ant-...'` ANYWHERE in the codebase
- No `print()` of any object that might contain a key
- No widget that imports `package:http` directly (always via a service)
- No `setState()` on the SettingsPage (use SettingsBloc)
- No swallowing of API errors — always surface as Failure or BLoC state
```

---

## 13. Quality Gates per Sprint

After every sprint, run all of these. Do not move to the next sprint until all pass.

### Gate 1: Static analysis
```bash
flutter analyze --fatal-infos
```
Zero warnings, zero infos.

### Gate 2: Codegen
```bash
dart run build_runner build --delete-conflicting-outputs
```
Must complete without errors. Verify `*.freezed.dart` and `*.g.dart` files are newer than sources.

### Gate 3: Formatting
```bash
dart format lib/ test/ --set-exit-if-changed
```

### Gate 4: Tests
```bash
flutter test --coverage
```
All tests pass. Coverage doesn't drop below current baseline.

### Gate 5: Device verification
- Build debug APK: `flutter build apk --debug`
- Install on Redmi: `adb install build/app/outputs/flutter-apk/app-debug.apk`
- Manual smoke test per sprint:
  - F1: Open Segments page, see all 4 cards with live data
  - F2: Complete a video session, tap Export PDF, share sheet opens
  - F3: Open Settings, add key, test connection succeeds; generate recommendations
  - I1: Register account, complete session, check session appears in backend DB

### Gate 6 (backend only): API checks
```bash
npm run typecheck
npm run lint
npm test
```

---

## 14. Definition of Done — Whole Phase 3

The phase is done when:

- [ ] All 6 sprints pass their individual DoD
- [ ] End-to-end demo flow works: register → record gait video → analyse → see segments → generate AI recs → export PDF → sync to backend → see in profile
- [ ] App size hasn't ballooned (< 50 MB debug APK)
- [ ] Cold start under 3 seconds on Redmi
- [ ] No memory leaks (DevTools shows stable heap after 5 sessions)
- [ ] All sensitive data encrypted (keys, refresh tokens)
- [ ] README updated with new features + screenshots
- [ ] CLAUDE.md reflects current architecture
- [ ] Backend deployed and accessible
- [ ] At least 60% test coverage on new code

---

## 15. Appendix A — Exact Claude Code Prompts

Copy-paste these into Claude Code, one per session. Each prompt is self-contained.

### Sprint F1 prompts

**F1.1 — Angle classification engine**

```
CONTEXT: PoseWeave Flutter app, Clean Architecture, BLoC. Existing file lib/core/utils/pose_math.dart already has calculateAngle3Points, normalizedToCanvas, project3DTo2D.

TASK: Extend lib/core/utils/pose_math.dart with anatomical angle classification.

Add:
1. AngleClassification enum: neutral, valgus, varus, hyperflexed, flexed, extended, hyperextended, abducted, crossed
2. AngleAnalysis class: final degrees, classification, confidence, riskFlag (nullable String)
3. Static method PoseMath.analyzeKnee(hip, knee, ankle, isLeftSide) returning AngleAnalysis
   - Computes angle via existing calculateAngle3Points
   - Computes valgus/varus by knee_x deviation from hip-ankle midline (threshold 8% of hip width)
   - Sets riskFlag = 'knee_valgus' if deviation > 12%
4. Static method PoseMath.analyzeElbow(shoulder, elbow, wrist) returning AngleAnalysis
5. Static method PoseMath.analyzeHip(shoulder, hip, knee) returning AngleAnalysis
6. Static method PoseMath.analyzeShoulder(hip, shoulder, elbow) returning AngleAnalysis

RULES:
- Pure static methods, no side effects
- Use existing LandmarkEntity, no new domain models needed
- Include dartdoc explaining anatomical basis for each threshold
- No null assertions (!), no print(), no setState references
- Function bodies max 30 lines

Also write test cases in test/core/utils/pose_math_test.dart for analyzeKnee:
- returns valgus when knee deviates inward beyond threshold
- returns varus when knee deviates outward
- returns neutral for straight leg
- returns hyperflexed when angle < 90
- handles low-confidence landmarks gracefully (returns neutral with low confidence)
```

**F1.2 — EMA smoothing**

```
CONTEXT: PoseWeave Flutter. File lib/data/datasources/mlkit_camera_datasource_impl.dart streams pose detections to the rest of the app.

TASK: Add exponential moving average smoothing to reduce jitter.

1. Add private class _Smoothed { final double x, y, z, confidence; const _Smoothed(...); }
2. Add field: final Map<int, _Smoothed> _ema = {};
3. Add constant: static const double _alpha = 0.4;
4. Add private method _smooth(LandmarkModel raw, int index) that:
   - Reads previous from _ema map
   - If null, store raw and return raw
   - Else compute smoothed values: smoothed.x = _alpha * raw.x + (1 - _alpha) * prev.x
     (same for y, z, confidence)
   - Update _ema map
   - Return raw.copyWith with smoothed values
5. Modify the existing stream mapping to call _smooth() on each landmark
6. Clear _ema in stopDetection() and switchCamera()

RULES:
- Do not change the public Stream<PoseModel> interface
- Do not change LandmarkModel structure (it's freezed)
- No null assertions
- Keep all existing throttling logic intact
```

**F1.3 — Z-depth verification**

```
CONTEXT: PoseWeave Flutter. ML Kit landmarks include z (depth) but it may not be propagated correctly.

TASK: Audit and fix Z-depth handling in two files:

1. lib/data/models/landmark_model.dart
   - In fromMLKitLandmark factory, verify z is mapped from landmark.z (not 0.0 or null)
   - If wrong, fix it

2. lib/presentation/widgets/skeleton_3d_painter.dart
   - Find where Vector3 is constructed from a landmark
   - Verify z component uses landmark.z * 200.0 (not 0.0)
   - If wrong, fix it

Show me the current state of both files first, then propose the minimal diff.
```

**F1.4 — Segment dashboard page**

```
CONTEXT: PoseWeave Flutter, Cyber Kinetic Precision design system. Existing PoseBloc emits PoseState.active with landmarks. PoseMath now has analyzeKnee, analyzeElbow, analyzeHip, analyzeShoulder.

TASK: Create three new files:

1. lib/presentation/widgets/angle_badge_widget.dart
   - StatelessWidget AngleBadge with required AngleClassification classification
   - Renders a small pill with classification name
   - Color: neutral=green, valgus/varus/hyperflexed/hyperextended=red, else=cyan
   - Matches existing widget styling (glass panel, 12px text, RobotoMono if numeric)

2. lib/presentation/widgets/segment_detail_card.dart
   - StatelessWidget SegmentDetailCard with required: title (String), analysis (AngleAnalysis), landmarks (List<LandmarkEntity>)
   - Layout: title at top, big angle number (RobotoMono 32px), AngleBadge below, 3 landmark rows with confidence bars
   - Glass panel style: backdrop blur, #141414 fill, 1px #1E1E1E border

3. lib/presentation/pages/segment_dashboard_page.dart
   - StatefulWidget SegmentDashboardPage
   - BlocBuilder<PoseBloc, PoseState>
   - On state.active: extract 4 segments (leftArm, rightArm, leftLeg, rightLeg) using analyzeElbow/analyzeKnee
   - 2x2 GridView of SegmentDetailCard
   - "Generate PDF Report" button at bottom (disabled for now, wired in F2)
   - AppBar with back button + settings icon

Also add /segments route to lib/app.dart and a Segments card to home_page.dart.

RULES: All architecture rules from CLAUDE.md. Use BlocBuilder, not setState. No business logic in widgets.
```

### Sprint F2 prompts

**F2.1 — Add PDF dependencies**

```
TASK: Update pubspec.yaml to add:
  pdf: ^3.10.8
  printing: ^5.13.1

Then run:
  flutter pub get
  dart run build_runner build --delete-conflicting-outputs

Confirm no conflicts with existing share_plus dependency.
```

**F2.2 — Report data model**

```
CONTEXT: PoseWeave Flutter, freezed + json_serializable.

TASK: Create lib/data/models/report_data_model.dart as a freezed class.

Fields:
- String sessionDate (ISO timestamp string)
- Duration sessionDuration
- String exerciseType
- GaitParameters gait
- Map<String, AngleAnalysis> segmentAnalyses (keys: 'leftArm', 'rightArm', 'leftLeg', 'rightLeg')
- List<Uint8List> frameImages (PNG bytes of skeleton snapshots, can be empty)
- List<RecommendationEntity>? recommendations (nullable, optional)

Include freezed annotations, part directives, and JSON serialization.
Run dart run build_runner build after.
```

**F2.3 — PDF service**

```
CONTEXT: PoseWeave Flutter, Clean Architecture, dartz Either, injectable DI.

TASK: Create lib/data/services/pdf_report_service.dart.

Class PdfReportService:
- @injectable @singleton
- Single public method:
  Future<Either<Failure, String>> generateReport({required ReportDataModel data})
- Uses package:pdf to build a multi-page document
- Calls PdfPageBuilders.* static methods for each page (will create in next prompt)
- Writes to PathProvider.getTemporaryDirectory()
- Filename: 'poseweave_${timestamp}.pdf'
- Returns Right(filePath) on success, Left(PdfGenerationFailure(message)) on error

Add PdfGenerationFailure to lib/core/errors/failures.dart.

Add registration to dependency injection (run build_runner after).
```

**F2.4 — PDF page builders**

```
CONTEXT: PoseWeave Flutter, package:pdf imported as pw.

TASK: Create lib/data/services/pdf_page_builders.dart with class PdfPageBuilders containing static methods:

- buildCover(pw.Document doc, ReportDataModel data)
  Adds a page with: "PoseWeave Session Report" title, date, duration, exercise type, optional logo block

- buildGaitMetrics(pw.Document doc, GaitParameters gait)
  Adds a page with a 2-column table of gait metrics

- buildAngleTable(pw.Document doc, Map<String, AngleAnalysis> segments)
  Adds a page with a 4-row table (left arm, right arm, left leg, right leg)
  Columns: Segment, Avg angle, Classification, Risk flag

- buildSnapshots(pw.Document doc, List<Uint8List> images)
  Adds pages with 4 images per page in a 2x2 grid

- buildRecommendations(pw.Document doc, List<RecommendationEntity> recs)
  Adds a page with numbered list of recommendations, severity color coding

Use pw.* types throughout. Dark theme approximation: pw.PdfColor(0.04, 0.04, 0.04) background where needed.

Page size: A4. Margins: 40pt. Font: pw.Font from default (do not require asset loading).
```

**F2.5 — Wire PDF to BLoC**

```
CONTEXT: PoseWeave Flutter, existing PoseBloc, freezed events/states. PdfReportService now exists.

TASK:

1. Add to lib/presentation/bloc/pose_event.dart:
   const factory PoseEvent.generateReport({required ReportDataModel data}) = GenerateReport;

2. Add to lib/presentation/bloc/pose_state.dart:
   const factory PoseState.reportGenerating() = PoseReportGenerating;
   const factory PoseState.reportReady({required String filePath}) = PoseReportReady;
   const factory PoseState.reportFailed({required String message}) = PoseReportFailed;

3. Add to lib/presentation/bloc/pose_bloc.dart:
   - Inject PdfReportService via constructor (update DI)
   - Register on<GenerateReport>(_onGenerateReport)
   - Handler emits reportGenerating, calls service, emits reportReady or reportFailed

4. Add "Export PDF" button to lib/presentation/pages/gait_report_page.dart:
   - Uses BlocConsumer to listen for reportReady state
   - On reportReady, calls Printing.sharePdf with file bytes
   - Button shows CircularProgressIndicator while state is reportGenerating

5. Also enable the previously-disabled "Generate PDF Report" button on segment_dashboard_page.dart.

Run build_runner after.
```

### Sprint F3 prompts (BYOK)

**F3.1 — API key service**

```
CONTEXT: PoseWeave Flutter, Clean Architecture, injectable DI.

TASK:

1. Add to pubspec.yaml:
   flutter_secure_storage: ^9.2.2
   http: ^1.2.2

2. Add to lib/core/errors/failures.dart:
   class AiServiceFailure extends Failure { ... }
   class NoApiKeyFailure extends Failure { ... }

3. Create lib/data/services/api_key_service.dart:
   @injectable @singleton class ApiKeyService
   Constructor takes FlutterSecureStorage (register in DI)
   Methods:
     Future<String?> getKey()
     Future<void> saveKey(String key)
     Future<void> clearKey()
     Future<bool> hasKey()
     Future<Either<Failure, bool>> testKey(String key) — sends 1-token test request to api.anthropic.com/v1/messages

   Storage key name: 'anthropic_api_key'
   Storage options: AndroidOptions(encryptedSharedPreferences: true)

RULES:
- Never log the key or any value derived from it
- Never include the key in stack traces (catch and re-throw clean Failure)
- The testKey call uses claude-haiku-4-5-20251001 model with max_tokens: 1
```

**F3.2 — Recommendation models**

```
CONTEXT: PoseWeave Flutter, freezed + json_serializable.

TASK:

1. Create lib/domain/entities/recommendation_entity.dart:
   class RecommendationEntity extends Equatable
   Fields: title (String), detail (String), severity (Severity), bodyPart (String)
   enum Severity { low, medium, high }

2. Create lib/data/models/recommendation_model.dart as freezed:
   Fields matching the entity, plus fromEntity/toEntity factory methods
   JSON serialization with fromJson/toJson

Run build_runner after.
```

**F3.3 — Recommendation prompt builder**

```
CONTEXT: PoseWeave Flutter. GaitParameters and AngleAnalysis exist.

TASK: Create lib/data/services/recommendation_prompt_builder.dart.

Class RecommendationPromptBuilder with static methods:

1. build(GaitParameters gait, Map<String, AngleAnalysis> segments) returns ({String system, String user})

System prompt: "You are a sports physiotherapist analysing gait and posture data.
Return ONLY a JSON array, no markdown, no commentary.
Each recommendation must have: title (max 8 words), detail (max 40 words),
severity ('low' | 'medium' | 'high'), bodyPart (e.g. 'left knee').
Give 3 to 5 recommendations, prioritised by severity."

User prompt: structured data block with actual gait numbers + segment classifications.
For each segment, include: angle in degrees, classification name, risk flag if present.

2. parseResponse(String raw) returns List<RecommendationEntity>
   - Strip markdown fences if present (```json or ```)
   - jsonDecode as List<dynamic>
   - Map each to RecommendationEntity
   - Wrap in try/catch, throw FormatException with detail on parse failure
```

**F3.4 — Recommendation service**

```
CONTEXT: PoseWeave Flutter, Clean Architecture, dartz Either, injectable DI. ApiKeyService and RecommendationPromptBuilder exist.

TASK: Create lib/data/services/recommendation_service.dart.

Class RecommendationService:
- @injectable @singleton
- Constructor: ApiKeyService _keyService, http.Client _httpClient
- Single public method:
  Future<Either<Failure, List<RecommendationEntity>>> getRecommendations({
    required GaitParameters gait,
    required Map<String, AngleAnalysis> segmentAnalyses,
  })

Logic:
1. Get key via _keyService.getKey()
2. If null, return Left(NoApiKeyFailure('Add your Anthropic API key in Settings'))
3. Build prompt via RecommendationPromptBuilder.build(...)
4. POST to https://api.anthropic.com/v1/messages with headers:
   x-api-key: <key>
   anthropic-version: 2023-06-01
   content-type: application/json
5. Request body: model: claude-haiku-4-5-20251001, max_tokens: 1024, system, messages
6. On 200: parse body.content[0].text via RecommendationPromptBuilder.parseResponse
7. On non-200: return Left(AiServiceFailure) with specific message based on status
8. On exception: return Left(AiServiceFailure('Network error: $e'))

RULES:
- Never log the API key
- Catch and clean errors before throwing — no key in stack traces
- Function bodies max 30 lines (extract helpers)
```

**F3.5 — Settings page**

```
CONTEXT: PoseWeave Flutter, Cyber Kinetic Precision design system, BLoC pattern.

TASK:

1. Create lib/presentation/bloc/settings_bloc.dart:
   - SettingsEvent freezed: loadSettings, saveApiKey(String), testApiKey(String), clearApiKey
   - SettingsState freezed: initial, loading, configured, notConfigured, testing, testSucceeded, testFailed(String), cleared
   - Inject ApiKeyService

2. Create lib/presentation/widgets/api_key_field.dart:
   - StatefulWidget with controller + obscure toggle (eye icon)
   - Show only last 4 chars of existing key when present and obscured
   - Validation: starts with 'sk-ant-' and length > 20

3. Create lib/presentation/pages/settings_page.dart:
   - AppBar with back button
   - Section: "AI Recommendations"
   - Status indicator (configured / not configured)
   - ApiKeyField widget
   - Buttons: "Test connection", "Clear key"
   - Below: link "Don't have a key? Get one at console.anthropic.com" using url_launcher
   - Privacy disclaimer text
   - Uses BlocConsumer for SettingsBloc
   - Match dark theme (#0A0A0A bg, #141414 surface, #00E5FF accent)

4. Add /settings route to lib/app.dart
5. Add Settings entry to profile_page.dart (will exist after I1) and home_page.dart drawer
```

**F3.6 — Recommendations panel + AI button**

```
CONTEXT: PoseWeave Flutter. RecommendationService exists. Cyber Kinetic Precision design.

TASK:

1. Create lib/presentation/widgets/recommendation_card.dart:
   - StatelessWidget with required RecommendationEntity
   - Left border color by severity: low=success green, medium=warning amber, high=danger red
   - Title bold 16px, detail body 14px, bodyPart pill at top right
   - Glass panel style

2. Create lib/presentation/widgets/recommendations_panel.dart:
   - StatelessWidget with required: List<RecommendationEntity>? recs, bool isLoading
   - isLoading: show 3 shimmer placeholder cards
   - recs == null && !isLoading: show "Tap Analyse with AI to generate recommendations" empty state
   - recs.isEmpty: show "No recommendations available"
   - Otherwise: column of RecommendationCard widgets

3. Add to lib/presentation/bloc/pose_event.dart:
   const factory PoseEvent.generateRecommendations({
     required GaitParameters gait,
     required Map<String, AngleAnalysis> segments,
   }) = GenerateRecommendations;

4. Add to lib/presentation/bloc/pose_state.dart:
   const factory PoseState.recommendationsLoading() = PoseRecommendationsLoading;
   const factory PoseState.recommendationsReady({required List<RecommendationEntity> recs}) = PoseRecommendationsReady;
   const factory PoseState.recommendationsFailed({required String message}) = PoseRecommendationsFailed;

5. Add handler in pose_bloc.dart calling RecommendationService.getRecommendations

6. In gait_report_page.dart, add:
   - "Analyse with AI" button below gait metrics
   - RecommendationsPanel widget below the button
   - BlocBuilder watches for recommendationsReady, passes to panel
   - On NoApiKeyFailure: show dialog → "Go to Settings" button
```

### Backend prompts

**B1.1 — Scaffold project**

```
TASK: Create a new Node.js + Express + TypeScript backend project for PoseWeave.

Repo name: poseweave-api (separate from Flutter repo).

Structure:
- src/
  - server.ts (Express entry)
  - app.ts (middleware wiring)
  - config/{env.ts, prisma.ts, redis.ts}
  - controllers/, services/, middleware/, validators/, routes/v1/, utils/, types/
- prisma/schema.prisma
- tests/{unit, integration}
- .env.example, .gitignore, jest.config.ts, package.json, render.yaml, tsconfig.json

Dependencies:
  express, zod, @prisma/client, bcryptjs, jsonwebtoken, ioredis, helmet, cors,
  express-rate-limit, dotenv, uuid

Dev dependencies:
  typescript, ts-node-dev, @types/{express,node,bcryptjs,jsonwebtoken,cors,uuid},
  jest, ts-jest, @types/jest, supertest, @types/supertest, eslint,
  @typescript-eslint/{eslint-plugin,parser}, prisma

Scripts in package.json:
  dev: ts-node-dev --respawn src/server.ts
  build: tsc
  start: node dist/server.js
  test: jest
  lint: eslint src --ext .ts
  typecheck: tsc --noEmit
  prisma:gen: prisma generate
  prisma:migrate: prisma migrate dev

tsconfig.json: strict true, target ES2022, module commonjs, outDir dist, rootDir src.

Initial endpoint: GET /v1/health returns { success, data: { status, db, redis, timestamp } }.

Implement env validation in config/env.ts using zod schema.
```

**B1.2 — Prisma schema for users**

```
CONTEXT: PoseWeave backend, Prisma 5.x, PostgreSQL.

TASK: Create prisma/schema.prisma with the User model:

generator client { provider = "prisma-client-js" }
datasource db { provider = "postgresql"; url = env("DATABASE_URL") }

model User {
  id            String    @id @default(uuid())
  email         String    @unique
  passwordHash  String    @map("password_hash")
  displayName   String?   @map("display_name")
  avatarUrl     String?   @map("avatar_url")
  timezone      String    @default("UTC")
  isPremium     Boolean   @default(false) @map("is_premium")
  emailVerified Boolean   @default(false) @map("email_verified")
  createdAt     DateTime  @default(now()) @map("created_at")
  updatedAt     DateTime  @updatedAt @map("updated_at")
  lastSyncAt    DateTime? @map("last_sync_at")

  @@index([email])
  @@map("users")
}

Then run:
  npx prisma migrate dev --name init_users

This requires a local PostgreSQL or a Neon project to be set up first.
```

**B1.3 — Auth service and controller**

```
CONTEXT: PoseWeave backend.

TASK: Create auth flow with these files:

1. src/validators/auth.validator.ts
   - Zod schemas: RegisterSchema, LoginSchema, RefreshSchema
   - RegisterSchema: email (email format), password (min 8, must contain letter + number),
     displayName (optional, 2-50 chars), timezone (optional)

2. src/services/token.service.ts
   - generateAccessToken(userId, email) — HS256, 15min
   - generateRefreshToken(userId) — HS256, 7day, stored in Redis as "refresh:{token}" → userId
   - verifyAccessToken(token) — returns payload or null
   - verifyRefreshToken(token) — checks Redis, returns userId or null
   - rotateRefreshToken(oldToken) — invalidates old, issues new pair

3. src/services/auth.service.ts
   - register(email, password, displayName?, timezone?) — hashes with bcrypt rounds=12,
     creates User, returns { user, tokens }
   - login(email, password) — verifies password, returns tokens
   - logout(refreshToken) — deletes Redis key
   - getMe(userId) — returns user without passwordHash

4. src/controllers/auth.controller.ts
   - Express handlers for POST /register, /login, /refresh, /logout, GET /me
   - Uses ApiResponse envelope from src/utils/api-response.ts
   - Catches errors, delegates to error middleware

5. src/routes/v1/auth.routes.ts
   - Wire controllers, attach validate middleware with Zod schemas
   - Attach rate-limit middleware (5 req / 15 min) to register and login

RULES:
- Never return passwordHash in any response
- Never log passwords or tokens
- All errors thrown, caught by error middleware
- Use prisma client from src/config/prisma.ts singleton
```

**B1.4 — Middleware stack**

```
CONTEXT: PoseWeave backend.

TASK: Create middleware files:

1. src/middleware/error.middleware.ts
   - Global error handler (4-arg signature)
   - Maps ZodError → 400 VALIDATION_ERROR with field details
   - Maps JsonWebTokenError → 401 AUTH_INVALID
   - Maps TokenExpiredError → 401 AUTH_EXPIRED
   - Maps PrismaClientKnownRequestError P2002 → 409 CONFLICT
   - Default → 500 INTERNAL_ERROR (do not leak stack in production)
   - Logs full error with requestId

2. src/middleware/auth.middleware.ts
   - verifyJwt: reads Authorization: Bearer <token>, verifies, attaches to req.user
   - On invalid: 401 AUTH_INVALID
   - Augment Express.Request via src/types/express.d.ts to include user: { id, email }

3. src/middleware/validate.middleware.ts
   - Factory: validate(schema: ZodSchema, source: 'body' | 'query' | 'params') => middleware
   - Parses + assigns parsed value back to req[source]
   - Throws ZodError on failure (caught by error middleware)

4. src/middleware/rate-limit.middleware.ts
   - Three limiters: authLimiter (5/15min), syncLimiter (30/min), generalLimiter (200/min)
   - All use Redis store via rate-limit-redis package
   - keyGenerator: prefer req.user?.id, fall back to req.ip

Wire all middleware in src/app.ts in correct order: helmet → cors → bodyParser → generalLimiter → routes → errorHandler
```

### B2, I1 prompts

Backend Sprint B2 (sync, analytics, leaderboard) and Integration Sprint I1 (Flutter sync client) each follow the same pattern — one prompt per file, each self-contained with rules. Generate them in your Claude Code session by referring to the file manifest in Appendix B and the contracts in Sections 10 and 11.

---

## 16. Appendix B — File Manifest

Complete list of files created or modified across Phase 3.

### Flutter — new files (32)

```
lib/core/utils/pose_math.dart                         [extended]
lib/core/errors/failures.dart                         [extended]
lib/data/services/pdf_report_service.dart             [new]
lib/data/services/pdf_page_builders.dart              [new]
lib/data/services/api_key_service.dart                [new]
lib/data/services/recommendation_service.dart         [new]
lib/data/services/recommendation_prompt_builder.dart  [new]
lib/data/models/report_data_model.dart                [new]
lib/data/models/recommendation_model.dart             [new]
lib/data/models/landmark_model.dart                   [verify]
lib/data/datasources/mlkit_camera_datasource_impl.dart [extended]
lib/data/datasources/local_session_datasource.dart    [new — I1]
lib/data/network/pose_api_client.dart                 [new — I1]
lib/data/network/auth_interceptor.dart                [new — I1]
lib/data/network/token_storage.dart                   [new — I1]
lib/data/repositories/sync_repository.dart            [new — I1]
lib/data/repositories/auth_repository.dart            [new — I1]
lib/domain/entities/recommendation_entity.dart        [new]
lib/presentation/widgets/segment_detail_card.dart     [new]
lib/presentation/widgets/angle_badge_widget.dart      [new]
lib/presentation/widgets/api_key_field.dart           [new]
lib/presentation/widgets/recommendation_card.dart     [new]
lib/presentation/widgets/recommendations_panel.dart   [new]
lib/presentation/pages/segment_dashboard_page.dart    [new]
lib/presentation/pages/settings_page.dart             [new]
lib/presentation/pages/profile_page.dart              [new — I1]
lib/presentation/pages/session_history_page.dart      [new — I1]
lib/presentation/pages/leaderboard_page.dart          [new — I1]
lib/presentation/pages/gait_report_page.dart          [extended]
lib/presentation/pages/home_page.dart                 [extended]
lib/presentation/bloc/pose_bloc.dart                  [extended]
lib/presentation/bloc/pose_event.dart                 [extended]
lib/presentation/bloc/pose_state.dart                 [extended]
lib/presentation/bloc/settings_bloc.dart              [new]
lib/presentation/bloc/sync_bloc.dart                  [new — I1]
lib/presentation/bloc/auth_bloc.dart                  [new — I1]
lib/presentation/widgets/skeleton_3d_painter.dart     [verify]
lib/app.dart                                          [extended]
pubspec.yaml                                          [extended]
CLAUDE.md                                             [extended]
```

### Backend — new files (~30)

```
poseweave-api/
├── prisma/schema.prisma
├── prisma/migrations/[generated]
├── src/server.ts
├── src/app.ts
├── src/config/env.ts
├── src/config/prisma.ts
├── src/config/redis.ts
├── src/controllers/auth.controller.ts
├── src/controllers/sync.controller.ts
├── src/controllers/analytics.controller.ts
├── src/controllers/leaderboard.controller.ts
├── src/controllers/challenge.controller.ts
├── src/controllers/health.controller.ts
├── src/services/auth.service.ts
├── src/services/token.service.ts
├── src/services/sync.service.ts
├── src/services/analytics.service.ts
├── src/services/leaderboard.service.ts
├── src/services/challenge.service.ts
├── src/middleware/auth.middleware.ts
├── src/middleware/validate.middleware.ts
├── src/middleware/rate-limit.middleware.ts
├── src/middleware/error.middleware.ts
├── src/validators/auth.validator.ts
├── src/validators/sync.validator.ts
├── src/validators/challenge.validator.ts
├── src/routes/index.ts
├── src/routes/v1/auth.routes.ts
├── src/routes/v1/sync.routes.ts
├── src/routes/v1/analytics.routes.ts
├── src/routes/v1/leaderboard.routes.ts
├── src/routes/v1/challenge.routes.ts
├── src/routes/v1/health.routes.ts
├── src/utils/api-response.ts
├── src/utils/errors.ts
├── src/types/express.d.ts
├── tests/unit/auth.service.test.ts
├── tests/unit/sync.service.test.ts
├── tests/unit/leaderboard.service.test.ts
├── tests/integration/auth.test.ts
├── tests/integration/sync.test.ts
└── README.md
```

---

## Closing notes

- This plan deliberately keeps the cost at zero. Free tiers handle hundreds of users. When you outgrow that, the upgrade path is one paid plan per service (~$30/mo total) — not a rearchitecture.
- BYOK means you can ship the AI features without ever paying for inference. Users who care about AI bring their own keys; users who don't never see a paywall.
- Every prompt in Appendix A is designed to work standalone. If a Claude Code session gets confused, `/clear` and start the next prompt fresh.
- The hardest sprint is I1 (network errors are sneaky). Budget extra time there. The other sprints are mostly mechanical once the contracts are set.

*End of plan — ready for hand-off to Claude Code.*
