# PoseWeave — Redesign Source Data

Raw structural + design-token data for redesigning the app. Generated from the
current codebase (Flutter, Clean Architecture + BLoC). Use this as the single
source when rebuilding the UI.

---

## 1. How the app divides — 8 zones, 25 screens

The app splits into **8 functional zones**. Inside the app, the post-login home
is a **4-tab shell** (Live / Analyze / 3D / Clinical); the Clinical zone is a
separate full-screen flow.

| # | Zone | Screens | Notes |
|---|------|---------|-------|
| 1 | **Boot & Auth** | 4 | splash → onboarding (first launch) → login → forgot-password |
| 2 | **Home shell** | 1 (4 tabs) | Bottom nav: Live · Analyze · 3D · Clinical (cards in each) |
| 3 | **Live detection** | 5 | Live Camera, Segment dashboard, Rep Counter (picker + live + video), Pose Coach |
| 4 | **Analyze (gallery)** | 5 | Video analysis, Video trim, Gait analysis, Gait report, Image analysis |
| 5 | **3D** | 1 | 3D skeleton viewer |
| 6 | **Account** | 2 | Settings (BYOK key), Profile (cloud) |
| 7 | **Clinical suite** | 7 | portal login → consent → hub → {live, biomechanical, 3D, gait} |
| 8 | **Shared chrome** | — | Top bar, bottom navs, overlays, dialogs (not screens) |

**Total: 25 distinct screen widgets** (18 main + 7 clinical), driven by **22 named routes**.

---

## 2. Screen inventory (route → file → purpose)

### Zone 1 — Boot & Auth
| Route | File | Purpose |
|-------|------|---------|
| `/` | `splash_page.dart` | Branded splash; routes to onboarding/login |
| `/onboarding` | `onboarding_page.dart` | 3-slide intro (first launch only) |
| `/login` | `login_page.dart` | Gated demo login (test@poseweave.app / test1234) |
| `/forgot-password` | `forgot_password_page.dart` | Password recovery (UI-only) |

### Zone 2 — Home shell
| Route | File | Purpose |
|-------|------|---------|
| `/home` | `home_shell.dart` | 4-tab shell; each tab = list of `ModeSelectorCard`s |

Tabs & cards:
- **Live:** Live Camera, Segment Analysis, Rep Counter, Pose Coach
- **Analyze:** Video Analysis, Record & Analyze, Gait Analysis, Image Analysis
- **3D:** 3D Skeleton (BETA)
- **Clinical:** Diagnostic Suite (CLINICAL)

### Zone 3 — Live detection
| Route | File | Purpose |
|-------|------|---------|
| `/camera` | `camera_pose_page.dart` | Live 2D skeleton + record→analyze |
| `/segments` | `segment_dashboard_page.dart` | Live per-limb angle classification cards |
| `/reps` | `rep_counter_picker_page.dart` | Exercise + source picker |
| (pushed) | `rep_counter_live_page.dart` | Live rep counting + form feedback |
| (pushed) | `rep_counter_video_page.dart` | Rep counting from a clip |
| `/pose-coach` | `pose_classifier_page.dart` | Live yoga/sport pose matching + hints |

### Zone 4 — Analyze
| Route | File | Purpose |
|-------|------|---------|
| `/gallery` | `gallery_pose_page.dart` | Pick video → frame-by-frame analysis → results |
| (pushed) | `video_trim_page.dart` | Trim a clip (range) before analysis |
| `/gait` | `gait_analysis_page.dart` | Pick walking video → gait report |
| (pushed) | `gait_report_page.dart` | Gait metrics, gauges, AI recs, PDF export |
| `/image` | `image_analysis_page.dart` | Single-image pose + angles + coords + crop + export |

### Zone 5 — 3D
| Route | File | Purpose |
|-------|------|---------|
| `/skeleton3d` | `skeleton_3d_page.dart` | Rotatable/zoom 3D skeleton + joint angles |

### Zone 6 — Account
| Route | File | Purpose |
|-------|------|---------|
| `/settings` | `settings_page.dart` | BYOK API key (test/save/clear) + privacy |
| `/profile` | `profile_page.dart` | Cloud profile (offline-first, often disabled) |

### Zone 7 — Clinical suite
| Route | File | Purpose |
|-------|------|---------|
| `/clinical/login` | `clinical_portal_login_page.dart` | Mock clinician portal |
| `/clinical/consent` | `clinical_consent_page.dart` | HIPAA consent (mock) |
| `/clinical/home` | `clinical_home_page.dart` | Diagnostic Suite hub (cards + bottom nav) |
| `/clinical/live` | `clinical_live_diagnostic_page.dart` | Live feed + kinematics + sensor panels |
| `/clinical/biomechanical` | `clinical_biomechanical_analysis_page.dart` | Frame-by-frame landmark metrics |
| `/clinical/3d` | `clinical_3d_reconstruction_page.dart` | 3D reconstruction (clinical chrome) |
| `/clinical/gait` | `clinical_gait_report_page.dart` | Status pods, ROM table, findings, PDF |

---

## 3. Navigation map

```
splash
 └─ onboarding (first launch) ─ or ─ login
     └─ HOME SHELL  [ Live | Analyze | 3D | Clinical ]  (bottom nav)
         ├─ Live ──► /camera · /segments · /reps(→live|video) · /pose-coach
         ├─ Analyze ► /gallery(→trim) · /gait(→report) · /image
         ├─ 3D ─────► /skeleton3d
         └─ Clinical ► /clinical/login → consent → home (bottom nav: Live|Biomech|3D|Gait)
     top-bar: back · home · ⋮ (Settings · Profile · Log out)
```

Sub-routes (camera, gait report, reps live/video, trim) are **pushed full-screen**
(no bottom nav). Clinical modules share their own bottom nav.

---

## 4. Design tokens (raw — current values)

### 4.1 Color (hex, dark "Cyber-Kinetic Precision")
| Token | Hex | Role |
|-------|-----|------|
| background / surface | `#0D1516` | App base (obsidian) |
| surfaceContainerLowest | `#080F11` | Camera/void backgrounds |
| surfaceContainerLow | `#151D1E` | — |
| surfaceContainer | `#192122` | Panels |
| surfaceContainerHigh | `#242B2D` | Raised panels |
| surfaceContainerHighest / surfaceVariant | `#2E3638` | Chips, badges |
| **primary** | `#C3F5FF` | Primary accent (pale cyan) |
| **primaryContainer** | `#00E5FF` | Electric cyan (active/tracking) |
| onPrimary | `#00363D` | Text on primary |
| onPrimaryContainer | `#00626E` | — |
| surfaceTint | `#00DAF3` | Cyan tint/glow |
| onSurface | `#DCE4E5` | Primary text |
| onSurfaceVariant | `#BAC9CC` | Secondary text |
| outline | `#849396` | Borders |
| outlineVariant | `#3B494C` | Hairline borders |
| **error** (coral) | `#FFB4AB` | Injury-risk / critical |
| onError | `#690005` | — |
| **success** (green) | `#00E676` | Joint aligned / good form |
| **warning** (amber) | `#FEC931` | Improper form / monitor |

Semantic green/amber/coral are **reserved for bio-feedback only**. Cyan is the
single brand accent (with neon bloom for active/tracking states).

### 4.2 Typography
- **Inter** (`GoogleFonts.interTextTheme`) — all UI chrome, headings, body.
- **JetBrains Mono** — ALL live numeric data (so digits don't shift width).
  - `AppTheme.mono({fontSize:14, weight:w500, letterSpacing:0, color:onSurface})`
  - `AppTheme.labelCaps({fontSize:12, weight:w700, letterSpacing:1.2})` → uppercase labels
- Live metric sizes in use: 72 (rep count), 20–22 (pose %), 14 (mono default), 9–12 (labels).

### 4.3 Spacing, radius, shape (as used)
- Spacing unit **4px**; common gaps 8 / 12 / 16 / 20 / 24; page padding 16–20.
- Card/panel radius **12px** (`GlassPanel` default); chips 6px; camera viewport sharp.
- `GlassPanel`: blur 14, translucent fill (~0.4 alpha), 1px hairline border, gradient light-catch.

### 4.4 Motion
- Skeleton EMA smoothing α=0.4; live throttle ~15 FPS; video sample 100 ms (~10 fps).

---

## 5. Component inventory (reuse / restyle these)

### Shared widgets (`lib/presentation/widgets/`)
| Widget | Renders |
|--------|---------|
| `GlassPanel` | Blurred translucent panel — the core surface |
| `ModeSelectorCard` | Icon + title + subtitle + chevron tile (home/clinical hubs) |
| `AppTopBar` | Back · home · overflow menu (Settings/Profile/Logout) |
| `CameraPoseView` | Camera preview + skeleton overlay in one aligned box (+ "N PERSONS" badge) |
| `PoseOverlayPainter` | 2D skeleton (region-colored bones + dots) |
| `Skeleton3DPainter` | 3D perspective skeleton |
| `ConfidenceIndicator` | Mean-confidence ring + % (mono) |
| `JointAnglesPanel` | L/R knee/elbow/hip angles + symmetry |
| `LandmarkTable` | 33-landmark x/y/z + confidence table |
| `AngleBadge` | Colored classification pill |
| `RadialGauge` | Circular metric gauge (arm swing etc.) |
| `RepCounterDisplay` | Big mono rep count + phase/form/signal |
| `PoseMatchPanel` | Pose name + match % + correction hints |
| `NoPersonBanner` | "No human detected" overlay |
| `LoadingOverlay` | Spinner + message |
| `RecommendationsPanel` | AI rec cards (severity-colored) |
| `SegmentDetailCard` | Per-limb angle card |
| `CameraSwitchButton` / `BodyRegionLegend` / `DetectionDebugHud` / `PermissionRationaleDialog` / `ApiKeyField` | small chrome |
| `PoseResultsView` | Shared video results: scrub + overlay + export (JSON / PDF) |

### Clinical widgets (`lib/presentation/widgets/clinical/`)
`ClinicalBottomNav`, `HudFrame` (corner brackets), `PatientHeader`,
`StatusMetricPod` (NORMAL/WARNING/CRITICAL), `KinematicsPanel`, `RomTable`,
`LandmarkMetricsTable`, `SensorStatusPanel`.

---

## 6. Design references in repo
- `design/cyber_kinetic_precision/DESIGN.md` — consumer design system (dark neo-glassmorphism).
- `design/clinical_high_precision/DESIGN.md` — clinical "surgical clarity" system.
- `design/<screen>/code.html` + `screen.png` — per-screen mockups (incl. `clinical_*`).

---

## 7. Redesign checklist (suggested)
- [ ] Decide if the **4-tab consumer shell** + **separate clinical surface** split stays, or unify.
- [ ] Re-skin the **auth/account screens** (splash/login/onboarding/settings/profile) — currently the least styled.
- [ ] Keep **JetBrains Mono for all numeric/live data**; Inter for chrome.
- [ ] Preserve **cyan = brand**, **green/amber/coral = bio-feedback only** (don't dilute).
- [ ] Reuse `GlassPanel` + `ModeSelectorCard` as the two base surfaces.
- [ ] Verify **WCAG AA** contrast (4.5:1) for body text on `#0D1516` (onSurface `#DCE4E5` passes; check secondary `#BAC9CC` / outline `#849396` for small text).
- [ ] Ensure touch targets ≥ 44×44 and visible focus states.
