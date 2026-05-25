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
];
