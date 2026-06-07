import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_template.dart';

/// Built-in yoga/sport pose templates. Each is defined by joint-angle rules
/// (scale-invariant). Add a pose by appending a [PoseTemplate] here — no engine
/// changes needed.
///
/// Joint angle conventions:
/// - elbow  = shoulder→elbow→wrist (arm bend)
/// - shoulder = hip→shoulder→elbow (arm raised relative to torso)
/// - knee   = hip→knee→ankle (leg bend)
/// - hip    = shoulder→hip→knee (torso/leg fold)
/// The selectable target poses for the guided "Match a target" mode: one entry
/// per pose name (the asymmetric L/R dual-templates collapse to a single tile;
/// the classifier still scores against both variants behind the scenes).
List<PoseTemplate> uniquePoseTargets() {
  final List<PoseTemplate> out = <PoseTemplate>[];
  final Set<String> seen = <String>{};
  for (final PoseTemplate t in kPoseTemplates) {
    if (seen.add(t.name)) out.add(t);
  }
  return out;
}

/// All templates that share a display [name] (so a guided target can be scored
/// against every L/R variant, not just the first).
List<PoseTemplate> templatesNamed(String name) =>
    kPoseTemplates.where((PoseTemplate t) => t.name == name).toList();

const List<PoseTemplate> kPoseTemplates = <PoseTemplate>[
  PoseTemplate(
    name: 'T-Pose',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 178, tolerance: 22, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 178, tolerance: 22, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 90, tolerance: 25, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 90, tolerance: 25, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 20, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 20, label: 'Right knee'),
    ],
  ),
  PoseTemplate(
    name: 'Mountain',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 178, tolerance: 22, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 178, tolerance: 22, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 15, tolerance: 18, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 15, tolerance: 18, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 20, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 20, label: 'Right knee'),
    ],
  ),
  PoseTemplate(
    name: 'Overhead Reach',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 175, tolerance: 22, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 175, tolerance: 22, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 165, tolerance: 25, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 165, tolerance: 25, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 20, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 20, label: 'Right knee'),
    ],
  ),
  PoseTemplate(
    name: 'Chair',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 110, tolerance: 28, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 110, tolerance: 28, label: 'Right knee'),
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftHip, c: PoseLandmarkType.leftKnee, targetDeg: 115, tolerance: 30, label: 'Left hip'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightHip, c: PoseLandmarkType.rightKnee, targetDeg: 115, tolerance: 30, label: 'Right hip'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 150, tolerance: 30, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 150, tolerance: 30, label: 'Right shoulder'),
    ],
  ),
  PoseTemplate(
    name: 'Goddess',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 115, tolerance: 28, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 115, tolerance: 28, label: 'Right knee'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 90, tolerance: 25, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 90, tolerance: 25, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 90, tolerance: 30, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 90, tolerance: 30, label: 'Right elbow'),
    ],
  ),

  // --- Yoga library --------------------------------------------------------
  // Asymmetric poses (Warrior, Tree, Side Bend, Triangle) are listed twice —
  // a left-lead and a right-lead template under the SAME `name` — so the pose
  // matches whichever side the user leads with (the classifier keeps the
  // higher-scoring one and reports the shared name). Targets are starting
  // points; tune tolerance/targetDeg on-device. Side-on poses (Triangle) use
  // the widest tolerances and are approximate on a 2D front camera.

  // 1. Warrior II — arms out level, one knee bent ~110, back leg straight.
  PoseTemplate(
    name: 'Warrior II',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 178, tolerance: 24, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 178, tolerance: 24, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 90, tolerance: 26, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 90, tolerance: 26, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 110, tolerance: 28, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 175, tolerance: 22, label: 'Right knee'),
    ],
  ),
  PoseTemplate(
    name: 'Warrior II',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 178, tolerance: 24, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 178, tolerance: 24, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 90, tolerance: 26, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 90, tolerance: 26, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 175, tolerance: 22, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 110, tolerance: 28, label: 'Right knee'),
    ],
  ),

  // 2. Warrior I — arms overhead, one knee bent ~105, back leg straight.
  PoseTemplate(
    name: 'Warrior I',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 175, tolerance: 24, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 175, tolerance: 24, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 165, tolerance: 26, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 165, tolerance: 26, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 105, tolerance: 28, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 170, tolerance: 24, label: 'Right knee'),
    ],
  ),
  PoseTemplate(
    name: 'Warrior I',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 175, tolerance: 24, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 175, tolerance: 24, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 165, tolerance: 26, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 165, tolerance: 26, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 170, tolerance: 24, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 105, tolerance: 28, label: 'Right knee'),
    ],
  ),

  // 3. Tree — arms overhead, standing leg straight, other knee bent out ~40.
  PoseTemplate(
    name: 'Tree',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 175, tolerance: 26, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 175, tolerance: 26, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 170, tolerance: 26, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 170, tolerance: 26, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 22, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 42, tolerance: 30, label: 'Right knee'),
    ],
  ),
  PoseTemplate(
    name: 'Tree',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 175, tolerance: 26, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 175, tolerance: 26, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 170, tolerance: 26, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 170, tolerance: 26, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 42, tolerance: 30, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 22, label: 'Right knee'),
    ],
  ),

  // 4. Forward Fold (Uttanasana) — deep hip fold, straight knees, arms hang.
  PoseTemplate(
    name: 'Forward Fold',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftHip, c: PoseLandmarkType.leftKnee, targetDeg: 40, tolerance: 28, label: 'Left hip'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightHip, c: PoseLandmarkType.rightKnee, targetDeg: 40, tolerance: 28, label: 'Right hip'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 175, tolerance: 24, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 175, tolerance: 24, label: 'Right knee'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 20, tolerance: 28, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 20, tolerance: 28, label: 'Right shoulder'),
    ],
  ),

  // 5. Cactus Arms (Goalpost) — shoulders 90, elbows 90, legs straight.
  PoseTemplate(
    name: 'Cactus Arms',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 90, tolerance: 25, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 90, tolerance: 25, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 90, tolerance: 26, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 90, tolerance: 26, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 22, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 22, label: 'Right knee'),
    ],
  ),

  // 6. Prayer (Samasthiti) — hands at chest (elbows ~40), arms low, legs straight.
  PoseTemplate(
    name: 'Prayer',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 40, tolerance: 26, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 40, tolerance: 26, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 25, tolerance: 22, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 25, tolerance: 22, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 22, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 22, label: 'Right knee'),
    ],
  ),

  // 7. Standing Side Bend — one arm overhead, one arm down, legs straight.
  PoseTemplate(
    name: 'Standing Side Bend',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 170, tolerance: 26, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 15, tolerance: 22, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 175, tolerance: 26, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 24, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 24, label: 'Right knee'),
    ],
  ),
  PoseTemplate(
    name: 'Standing Side Bend',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 170, tolerance: 26, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 15, tolerance: 22, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 175, tolerance: 26, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 24, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 24, label: 'Right knee'),
    ],
  ),

  // 8. Triangle (Trikonasana) — wide straight legs, one arm up / one down, hip
  // folded. Side-on on a front camera: widest tolerances, approximate.
  PoseTemplate(
    name: 'Triangle',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 175, tolerance: 26, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 175, tolerance: 26, label: 'Right knee'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 40, tolerance: 32, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 160, tolerance: 32, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftHip, c: PoseLandmarkType.leftKnee, targetDeg: 100, tolerance: 32, label: 'Left hip'),
    ],
  ),
  PoseTemplate(
    name: 'Triangle',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 175, tolerance: 26, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 175, tolerance: 26, label: 'Right knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 40, tolerance: 32, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 160, tolerance: 32, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightHip, c: PoseLandmarkType.rightKnee, targetDeg: 100, tolerance: 32, label: 'Right hip'),
    ],
  ),

  // 9. Garland / Deep Squat (Malasana) — deep knees, hips folded, prayer hands.
  PoseTemplate(
    name: 'Deep Squat',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 55, tolerance: 28, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 55, tolerance: 28, label: 'Right knee'),
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftHip, c: PoseLandmarkType.leftKnee, targetDeg: 60, tolerance: 30, label: 'Left hip'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightHip, c: PoseLandmarkType.rightKnee, targetDeg: 60, tolerance: 30, label: 'Right hip'),
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 45, tolerance: 30, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 45, tolerance: 30, label: 'Right elbow'),
    ],
  ),

  // 10. Eagle Arms (Garudasana arms) — elbows deeply bent, hands centered.
  PoseTemplate(
    name: 'Eagle Arms',
    constraints: <JointConstraint>[
      JointConstraint(a: PoseLandmarkType.leftShoulder, b: PoseLandmarkType.leftElbow, c: PoseLandmarkType.leftWrist, targetDeg: 30, tolerance: 24, label: 'Left elbow'),
      JointConstraint(a: PoseLandmarkType.rightShoulder, b: PoseLandmarkType.rightElbow, c: PoseLandmarkType.rightWrist, targetDeg: 30, tolerance: 24, label: 'Right elbow'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftShoulder, c: PoseLandmarkType.leftElbow, targetDeg: 80, tolerance: 24, label: 'Left shoulder'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightShoulder, c: PoseLandmarkType.rightElbow, targetDeg: 80, tolerance: 24, label: 'Right shoulder'),
      JointConstraint(a: PoseLandmarkType.leftHip, b: PoseLandmarkType.leftKnee, c: PoseLandmarkType.leftAnkle, targetDeg: 178, tolerance: 24, label: 'Left knee'),
      JointConstraint(a: PoseLandmarkType.rightHip, b: PoseLandmarkType.rightKnee, c: PoseLandmarkType.rightAnkle, targetDeg: 178, tolerance: 24, label: 'Right knee'),
    ],
  ),
];
