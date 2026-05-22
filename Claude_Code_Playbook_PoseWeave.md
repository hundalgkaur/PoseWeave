# PoseWeave — Claude Code Project Playbook
## Senior Architect's Development Guide (25-Year Experience Perspective)
**Date:** 2026-05-22  
**Tool:** Anthropic Claude Code CLI  
**Project:** Flutter Pose Tracker + 3D Skeleton  
**Purpose:** Turn the PRD into production-ready code using AI-assisted development

---

## 1. Executive Summary

Claude Code is not a magic wand. It is a **senior pair programmer** that works at the speed of light but lacks context. This guide treats Claude Code as a junior-senior hybrid: it can write perfect syntax but will architect like a first-year grad if you let it.

**The 25-year rule:** Every instruction you give must enforce **boundaries**. Claude Code without boundaries generates spaghetti. With boundaries, it generates Clean Architecture faster than any human.

---

## 2. Environment Setup (Do This Once)

### 2.1 Prerequisites

```bash
# Verify versions — do not proceed if any fail
flutter --version        # Must be >=3.19.0
claude --version         # Use a recent build; run `claude update` to upgrade
dart --version           # Must be >=3.3.0
```

### 2.2 Project Initialization

```bash
# Create project with strict linting from day zero
flutter create poseweave --org com.yourname.poseweave --project-name poseweave

# Enter project — this is your workspace root
cd poseweave

# Start Claude Code in this directory, then generate the context file:
claude
# ...inside the interactive session, run the slash command:
/init
```

`/init` scaffolds a `CLAUDE.md` at the repo root by analyzing the codebase. Edit it to add the enforcement rules below.

### 2.3 The `CLAUDE.md` File (Critical)

`CLAUDE.md` at the repo root is the file Claude Code loads into context automatically at the start of every session. This is your **architecture enforcement layer**. (Older guides reference `.claude/project.md`; the current convention is `CLAUDE.md` at the project root. You can also keep nested `CLAUDE.md` files in subdirectories for layer-specific rules.)

```markdown
# PoseWeave — Claude Code Context

## Architecture Rules (Non-Negotiable)
- STRICT Clean Architecture: data/ → domain/ → presentation/ layers only
- NO business logic in widgets. EVER.
- NO direct ML Kit calls in UI layer. Use repository pattern.
- State management: flutter_bloc ONLY. No setState, no ChangeNotifier, no Riverpod.
- All models: freezed with json_serializable.
- All dependencies: injected via get_it + injectable.
- All public methods: documented with /// dartdoc.
- All functions: max 30 lines. Extract helpers immediately.

## Tech Stack (Locked)
- flutter_bloc: ^8.1.3
- camera: ^0.10.5+9
- google_mlkit_pose_detection: ^0.12.0
- get_it: ^7.6.4
- injectable: ^2.3.2
- freezed: ^2.4.5
- permission_handler: ^11.0.1

## Naming Conventions
- Files: snake_case.dart
- Classes: PascalCase
- Private members: _leadingUnderscore
- Blocs: [Feature]Bloc
- Events: [Feature]Event
- States: [Feature]State
- UseCases: [Action][Entity]UseCase (e.g., DetectPoseFromCamera)

## Forbidden Patterns
- No FutureBuilder in presentation layer. Use BlocBuilder.
- No print(). Use debugPrint() or bloc observer logging.
- No dynamic types. All generics must be explicit.
- No null assertions (!). Use ?? defaults or early returns.
- No widget trees deeper than 60 lines. Extract widgets.

## Output Expectations
- Generate complete files, not snippets.
- Include all imports.
- Include part directives for freezed.
- Write unit test scaffolding for every public class.
- Comment complex algorithms with "WHY", not "WHAT".
```

---

## 3. Claude Code Workflow Architecture

### 3.1 The Session Strategy

**Never** ask Claude Code to "build the whole app." It will hallucinate dependencies and skip architecture.

**Instead**, use the **Vertical Slice Method:**

```
Slice 1: Domain Layer (Entities + Contracts)
Slice 2: Data Layer (ML Kit Datasource + Models)
Slice 3: Repository Layer (Bridge)
Slice 4: BLoC Layer (State Machine)
Slice 5: Presentation Layer (UI + Painters)
Slice 6: Integration (DI + Main + Routing)
```

Each slice is a focused unit of work. Claude Code auto-summarizes (compacts) the conversation as context fills, so a slice does not have to map to a hard session boundary — but keeping each slice tightly scoped still produces the highest-quality output and makes review easier.

### 3.2 The Prompt Template (Use This Every Time)

```
CONTEXT:
I am building [Slice X] of a Flutter Clean Architecture app. 
The full PRD is at PRD.md (repo root).
The architecture rules are in CLAUDE.md (loaded automatically).

TASK:
[Specific, bounded task. One file or one folder.]

CONSTRAINTS:
- Follow CLAUDE.md rules strictly
- Use existing types from [list files already created]
- Generate COMPLETE file with all imports
- Include freezed part directives
- Write 3 unit test cases as comments at bottom
- Max 30 lines per function

OUTPUT FORMAT:
- Full file path as header
- Complete Dart code
- No markdown code blocks inside explanations
```

---

## 4. Session-by-Session Instructions

### SESSION 1: Domain Foundation (30 minutes)

**Your prompt:**
```
Create the domain layer for PoseWeave:

1. lib/domain/entities/landmark_entity.dart — 33 PoseLandmarkType enum values matching ML Kit exactly, LandmarkEntity value object with Equatable
2. lib/domain/entities/pose_entity.dart — PoseEntity aggregate with 33 landmark assertion, getLandmark() accessor, PoseSource enum
3. lib/core/errors/failures.dart — Failure abstract class, CameraFailure, MLFailure, PermissionFailure with message strings
4. lib/core/usecases/usecase.dart — abstract UseCase<<Type, Params> with call() method

Rules:
- Zero dependencies on Flutter material in domain layer (except Equatable)
- All classes immutable (const constructors, final fields)
- Include dartdoc comments explaining WHY each class exists
- Write test scaffolding comments at bottom of each file
```

**Human checkpoint:** Verify `PoseLandmarkType` enum order matches ML Kit exactly (0=nose, 1=leftEyeInner... 32=rightFootIndex).

---

### SESSION 2: Constants & Math (20 minutes)

**Your prompt:**
```
Create core utilities:

1. lib/core/constants/pose_constants.dart — All 32 bone connections as List<List<int>>, region color mapping (face=cyan, torso=green, leftArm=orange, rightArm=purple, leftLeg=red, rightLeg=blue), confidence thresholds
2. lib/core/utils/pose_math.dart — calculateAngle3Points(), normalizedToCanvas(), project3DTo2D() using vector_math

Rules:
- Use dart:math, not external packages for trig
- Vector3/Vector4 from vector_math package (built into Flutter SDK)
- All functions static, pure (no side effects)
- Include mathematical formula comments (e.g., "Law of Cosines: c² = a² + b² - 2ab·cos(C)")
- Handle division-by-zero with early returns
```

**Human checkpoint:** Test `calculateAngle3Points` with a right triangle (expect 90°) and straight line (expect 180°).

---

### SESSION 3: Data Models (25 minutes)

**Your prompt:**
```
Create data layer models with freezed:

1. lib/data/models/landmark_model.dart — LandmarkModel freezed class with fromEntity() and toEntity() factory methods. Must map ML Kit PoseLandmark.landmarkType ordinal to PoseLandmarkType enum safely.
2. lib/data/models/pose_model.dart — PoseModel freezed class with List<<LandmarkModel>, timestamp, source. fromMLKitPose() factory that accepts google_mlkit_pose_detection Pose object.

Rules:
- Include part 'landmark_model.freezed.dart'; part 'landmark_model.g.dart'; directives
- toEntity() must return domain entity (NOT model)
- fromEntity() for testing/mock purposes only
- Handle null z-depth gracefully (default to 0.0)
- JSON serialization must preserve enum names as strings
```

**Human checkpoint:** Run `dart run build_runner build`. Fix any generation errors before proceeding.

---

### SESSION 4: ML Kit Datasource (40 minutes)

**Your prompt:**
```
Create ML Kit camera datasource:

1. lib/data/datasources/mlkit_camera_datasource.dart — MLKitCameraDataSource abstract class with initialize(), startPoseStream(), stopDetection(), dispose(), switchCamera()
2. lib/data/datasources/mlkit_camera_datasource_impl.dart — Implementation using camera plugin + google_mlkit_pose_detection

Critical implementation details:
- CameraImage (YUV420) to InputImage conversion must handle rotation using camera.sensorOrientation + device orientation
- Stream must be throttled: process every 2nd frame (15 FPS max) using Stream.throttle or manual timestamp check
- Must dispose PoseDetector in dispose() to prevent native memory leak
- Must handle camera lens direction (front/back) switching without full reinitialization
- Return Stream<PoseModel> (not ML Kit Pose directly) — map inside datasource
- On error: log and continue stream (never crash)

Rules:
- No UI logic. No BuildContext. No Flutter widgets.
- Use debugPrint for logging only
- Include try-catch around every ML Kit call
```

**Human checkpoint:** This is the riskiest file. Review the `InputImage.fromBytes()` conversion manually. ML Kit expects NV21 or YUV420 format correctly.

---

### SESSION 5: Repository Implementation (20 minutes)

**Your prompt:**
```
Create repository bridge:

1. lib/domain/repositories/pose_repository.dart — Abstract class with getCameraStream() returning Either<Failure, Stream<PoseEntity>>, and analyzeVideoFile(String path) returning Either<Failure, List<PoseEntity>>
2. lib/data/repositories/pose_repository_impl.dart — Implementation using MLKitCameraDataSource

Rules:
- Use dartz Either for error handling (Left=Failure, Right=Success)
- Map PoseModel to PoseEntity using toEntity()
- Catch PlatformException and convert to CameraFailure/MLFailure
- Cache last pose in memory for instant replay
- No business logic — pure delegation + error mapping
```

**Human checkpoint:** Verify Either types are correct. Common mistake: wrapping Stream in Either incorrectly.

---

### SESSION 6: BLoC State Machine (35 minutes)

**Your prompt:**
```
Create complete BLoC for pose detection:

1. lib/presentation/bloc/pose_event.dart — freezed events: InitializeCamera, StartDetection, StopDetection, ProcessVideoFile(String), PoseDetected(PoseEntity), SwitchCamera, ToggleMockMode
2. lib/presentation/bloc/pose_state.dart — freezed states: Initial, Loading, NoPermission, Streaming, Active(List<<LandmarkEntity>, double avgConfidence), VideoProcessing(double progress), VideoComplete(List<<PoseEntity>), Error(String message, bool isRecoverable)
3. lib/presentation/bloc/pose_bloc.dart — Implementation

Bloc logic requirements:
- InitializeCamera event: request permission (permission_handler) → init camera → emit Streaming
- StartDetection: subscribe to repository stream, throttle to 15 FPS, emit Active on each pose
- StopDetection: cancel subscription, keep camera alive, emit Streaming
- PoseDetected: only emit new state if confidence changed > 5% (prevents UI jitter)
- Error handling: on CameraFailure → emit Error with isRecoverable=true. On MLFailure → log and skip frame.
- Mock mode: when ToggleMockMode, generate synthetic sine-wave landmarks oscillating between 0.3-0.7 normalized coordinates
- Close(): ALWAYS cancel StreamSubscription, dispose camera controller

Rules:
- Use flutter_bloc Bloc<<PoseEvent, PoseState>
- No setState. No StatefulWidget logic in Bloc.
- Include bloc observer logging in constructor for debugging
```

**Human checkpoint:** Verify `close()` method cancels subscription. Memory leak here = app crash on screen exit.

---

### SESSION 7: CustomPainter (45 minutes)

**Your prompt:**
```
Create skeleton visualization:

1. lib/presentation/widgets/pose_overlay_painter.dart — CustomPainter for 2D skeleton overlay

Requirements:
- Input: List<<LandmarkEntity>, Size imageSize (original frame), Size canvasSize
- Draw bones FIRST (behind dots) using Canvas.drawLine
- Draw 33 landmark dots using Canvas.drawCircle with white fill + black outline
- Dot radius = 4.0 + (confidence * 4.0) — larger = more confident
- Bone color determined by PoseBones.regionColors mapping
- Skip invisible landmarks (confidence < 0.5) entirely
- Use FittedBox scaling: maintain aspect ratio, center in canvas, letterbox if needed
- shouldRepaint: ONLY if landmarks list identity changes (not content)

Performance rules:
- Pre-create Paint objects in constructor (do not create in paint())
- Use Path for complex shapes, not multiple draw calls
- Clip canvas to image bounds to prevent overdraw
```

**Human checkpoint:** Test on device immediately. CustomPainter bugs are invisible in emulator.

---

### SESSION 8: UI Pages (50 minutes)

**Your prompt:**
```
Create presentation layer pages:

1. lib/presentation/pages/home_page.dart — Mode selector with 3 glassmorphism cards (Live Camera, Video Analysis, 3D Skeleton). Dark theme #0A0A0A background. Cards: semi-transparent black #141414 with 1px border #1E1E1E, 8px radius. Cyan #00E5FF accents on primary card.

2. lib/presentation/pages/camera_pose_page.dart — Full-screen camera with PoseOverlayPainter on top. AppBar transparent. Floating badges: confidence % top-left, FPS top-right. Bottom controls: Start/Stop/Record buttons in glass dock.

3. lib/presentation/pages/gallery_pose_page.dart — Upload zone (dashed border), processing linear progress, results with video player + data table.

4. lib/presentation/widgets/mode_selector_card.dart — Reusable card widget with icon, title, subtitle, arrow.

5. lib/presentation/widgets/loading_overlay.dart — Full-screen glass blur with cyan pulsing indicator.

Design system:
- Inter font for UI text (headings 24px/600, body 16px/400)
- RobotoMono for data (confidence, coordinates, FPS)
- No shadows. Use borders and subtle gradient overlays for depth.
- All buttons: 24px radius, cyan fill for primary, outlined for secondary.
```

**Human checkpoint:** Review `camera_pose_page.dart` carefully. Camera preview + overlay alignment is the #1 source of visual bugs.

---

### SESSION 9: Dependency Injection & Main (20 minutes)

**Your prompt:**
```
Create DI and entry point:

1. lib/injection.dart — get_it setup with injectable. Register MLKitCameraDataSourceImpl as singleton, PoseRepositoryImpl as singleton, PoseBloc as factory (new instance per screen).

2. lib/main.dart — void main() with WidgetsFlutterBinding.ensureInitialized(), configureInjection(), runApp(PoseWeaveApp()).

3. lib/app.dart — MaterialApp with dark theme (background #0A0A0A, surface #141414, primary #00E5FF). Route generation: / → HomePage, /camera → CameraPosePage, /gallery → GalleryPosePage.

4. Add BlocObserver for development logging (pose transitions, errors).

Rules:
- No logic in main.dart. Delegate to app.dart immediately.
- ThemeData must specify textTheme using Inter and RobotoMono.
- BlocProvider provided at route level, not root level (dispose on pop).
```

**Human checkpoint:** Run `dart run build_runner build` for injectable generation. Verify get_it resolves all types.

---

### SESSION 10: Integration & Polish (30 minutes)

**Your prompt:**
```
Final integration tasks:

1. AndroidManifest.xml — Add CAMERA, RECORD_AUDIO, READ_EXTERNAL_STORAGE permissions. Set minSdk 21.
2. build.gradle — Verify compileSdk 34, minSdk 21.
3. Add mock mode toggle in HomePage (hidden dev menu: triple-tap logo).
4. Add error boundary: if PoseError emitted, show glass dialog with retry button.
5. Add orientation lock: portrait only for Phase 1.
6. Add splash screen: cyan skeleton icon on black background.

Code cleanup:
- Remove all unused imports
- Ensure no analyzer warnings (dart analyze)
- Format all files (dart format lib/)
```

---

## 5. Claude Code Command Reference

Claude Code is an **interactive agent**, not a set of one-shot subcommands. You start it with `claude`, then talk to it in natural language. It reads, searches, edits, and creates files itself using its tools (asking permission before changes, per your permission mode). There is no `claude /ask` or `claude /edit` subcommand — you simply describe the task.

### 5.1 How to Drive It

```bash
# Start an interactive session in the project directory
claude

# Run a one-off prompt non-interactively (prints the result and exits)
claude -p "Fix all `dart analyze` warnings in lib/"

# Resume the previous conversation
claude --continue
```

Then, inside the session, just ask in plain language — the agent decides which tools to use:

```
"Create lib/domain/entities/landmark_entity.dart per Session 1 of the playbook."
"Refactor lines 45-60 of mlkit_camera_datasource_impl.dart: extract the ML Kit
 call into the datasource and inject the repository into the BLoC."
"Where is PoseEntity used?"        # the agent greps the codebase for you
"Explain lib/presentation/bloc/pose_bloc.dart"
"Write unit tests for this file using bloc_test and mocktail."
```

### 5.2 Slash Commands That Actually Exist

Slash commands are typed **inside** the interactive session (not as `claude /x` on the shell):

| Command | Use When | Why |
|---------|----------|-----|
| `/init` | First time in a repo | Generates/refreshes `CLAUDE.md` from the codebase |
| `/clear` | Starting an unrelated task | Wipes conversation history for a clean slate (optional) |
| `/review` | Reviewing a PR or diff | Built-in code review |
| `/config` | Changing model, theme, settings | Adjusts harness configuration |

**On context management:** you do **not** need to manually `/clear` every few files. The session auto-summarizes older context as it grows, so architecture rules in `CLAUDE.md` stay in effect throughout. Use `/clear` when you deliberately want to drop the current thread and start something unrelated — not as a routine anti-hallucination ritual. The real safeguard against drift is keeping `CLAUDE.md` accurate and scoping each request tightly.

---

## 6. Quality Gates (Check After Every Session)

### Gate 1: Architecture Compliance
```bash
dart analyze --fatal-infos
```
- Zero warnings
- No material imports in domain/ or data/ layers

### Gate 2: Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
```
- Must complete without errors
- freezed files must be newer than source files

### Gate 3: Formatting
```bash
dart format lib/ --set-exit-if-changed
```
- Zero unformatted files

### Gate 4: Test Compilation
```bash
flutter test --no-test-randomize-ordering-seed --compilation-mode=jit
```
- At minimum, tests must compile (even if failing)

### Gate 5: Device Verification
```bash
flutter run --device-id [your_android_device]
```
- Must launch without crash
- Camera permission dialog must appear on first run

---

## 7. Advanced Claude Code Techniques

### 7.1 The "Refactor, Don't Rewrite" Pattern

When Claude Code generates code that violates architecture (e.g., puts ML Kit call in widget):

```
BAD: "Rewrite this file correctly"
GOOD: "Refactor lines 45-60: extract the ML Kit call into MLKitCameraDataSourceImpl 
       and inject the repository into the BLoC. Keep the UI logic unchanged."
```

Specificity prevents Claude from destroying working code.

### 7.2 The "Test First" Constraint

Append this to every generation prompt:

```
After generating the implementation, write a test file in test/ mirroring the 
file path. Use mocktail for mocks. Include 3 tests:
1. Happy path
2. Null/empty input handling  
3. Error propagation
```

This forces Claude to think about edge cases during implementation, not after.

### 7.3 The "Diff Review" Protocol

Before accepting Claude's output, ask:

```
Explain the architectural trade-offs in this code:
1. Why is [X] in the data layer vs domain layer?
2. Where could memory leaks occur?
3. Which functions are not pure and why?
```

If Claude cannot answer satisfactorily, the code has hidden flaws.

---

## 8. Common Claude Code Pitfalls (Learned the Hard Way)

| Pitfall | Symptom | Prevention |
|---------|---------|------------|
| **Dependency Drift** | Claude adds `provider`, `getx`, or random packages | Lock stack in `CLAUDE.md`, reject additions |
| **Context Pollution** | Code references types from earlier that don't exist | Verify imports against real files; `/clear` only when switching to unrelated work |
| **The God File** | 400-line widget with everything inside | Enforce 60-line max per widget, extract aggressively |
| **Mock Confusion** | Tests mock wrong layer (mocking UI instead of datasource) | Specify "mock the datasource, not the widget" |
| **Platform Assumptions** | Generates iOS-specific code when building Android first | State "Android primary, iOS Phase 2" in every prompt |
| **Null Safety Laziness** | Uses `!` everywhere instead of proper null handling | Reject any file with `!` operator. Demand `??` or early returns. |
| **Stream Leaks** | No `cancel()` on subscriptions | Explicitly ask "Where are streams cancelled?" |

---

## 9. Session Checklist (Print and Tick)

Before starting each Claude Code session:

- [ ] `CLAUDE.md` is saved and current
- [ ] Previous slice's code compiles (`dart analyze` clean)
- [ ] `build_runner` generated files are up to date
- [ ] I know exactly which 1-2 files this slice will create
- [ ] I have the PRD section relevant to this slice open
- [ ] I will `/clear` only if the next slice is unrelated to the current thread

After each session:
- [ ] Generated code follows naming conventions
- [ ] No analyzer warnings
- [ ] Freezed part directives included
- [ ] Imports are correct (no unused imports)
- [ ] Functions under 30 lines
- [ ] dartdoc comments on public APIs
- [ ] Test file scaffolding created
- [ ] I tested on physical Android device (if camera/ML involved)

---

## 10. Emergency Recovery

### Scenario: Claude Code Generates Broken Code

```bash
# 1. Stop. Do not continue prompting.
# 2. Revert to last known good state (from your shell, or ask the agent to run it):
git checkout -- .

# 3. Inside the Claude Code session, clear the conversation:
/clear

# 4. Re-anchor on the rules, then re-prompt with SMALLER scope (plain language):
"Read CLAUDE.md and confirm the architecture rules, then create ONLY the
 LandmarkEntity class. Nothing else."
```

### Scenario: Build Runner Fails After Freezed Generation

```bash
# Usually caused by circular imports or syntax errors in source files
# 1. Delete generated files:
find lib -name "*.freezed.dart" -delete
find lib -name "*.g.dart" -delete

# 2. Fix syntax errors in source files (Claude can help identify)
dart analyze lib/domain lib/data lib/presentation

# 3. Regenerate:
dart run build_runner build --delete-conflicting-outputs
```

---

## 11. Performance Benchmarks for Claude Code Sessions

| Task | Expected Time | If Exceeds, Do This |
|------|-------------|---------------------|
| Single entity class | 2 min | Too complex — simplify requirements |
| Freezed model with JSON | 5 min | Check for circular dependencies |
| BLoC implementation | 10 min | Break into Event/State/Bloc separately |
| CustomPainter | 8 min | Provide ASCII art of expected output |
| Full page UI | 12 min | Extract widgets first, then compose |
| Integration (main.dart) | 5 min | Should be simple delegation only |

**Rule:** If Claude takes >15 minutes on any single file, your prompt is too broad. Slice smaller.

---

## 12. Final Wisdom

> "Claude Code writes code at the level of your instructions. 
> Vague instructions = junior-level spaghetti. 
> Precise architectural constraints = senior-level craftsmanship. 
> The bottleneck is never the AI's speed. It is the clarity of your boundaries."

**Your job as the human architect:**
1. Define the borders (Clean Architecture layers)
2. Enforce the borders (quality gates after every session)
3. Verify the reality (physical device testing — emulator lies about camera/ML)
4. Refuse mediocrity (reject any file that violates `CLAUDE.md`)

**Claude Code's job:**
1. Type fast
2. Remember syntax
3. Suggest patterns you might forget
4. Never argue when you enforce a rule

---

*End of Playbook — Execute with discipline.*
