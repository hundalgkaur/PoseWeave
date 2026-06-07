import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/constants/pose_templates.dart';
import 'package:poseweave/core/utils/pose_classifier.dart';
import 'package:poseweave/core/utils/pose_guide_builder.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';
import 'package:poseweave/domain/entities/pose_template.dart';

void main() {
  group('PoseGuideBuilder', () {
    test('every template yields a valid 33-landmark guide', () {
      for (final PoseTemplate t in kPoseTemplates) {
        expect(PoseGuideBuilder.build(t).landmarks.length, 33,
            reason: t.name);
      }
    });

    test('a generated guide matches its own template (faithful by construction)',
        () {
      // The guide realizes the template's angles, so classifying it against
      // that single template should score high.
      for (final String name in <String>[
        'T-Pose',
        'Mountain',
        'Cactus Arms',
        'Warrior II',
        'Goddess',
      ]) {
        final PoseTemplate t = templatesNamed(name).first;
        final PoseEntity guide = PoseGuideBuilder.build(t);
        final PoseMatchResult r =
            PoseClassifier.classify(guide, templates: <PoseTemplate>[t]);
        expect(r.matchPercent, greaterThan(80),
            reason: '$name guide scored ${r.matchPercent.round()}%');
      }
    });
  });
}
