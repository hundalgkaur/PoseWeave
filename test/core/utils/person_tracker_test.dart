import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/person_tracker.dart';

void main() {
  group('PoseCentroid', () {
    test('distanceTo is Euclidean', () {
      const PoseCentroid a = PoseCentroid(0.0, 0.0, 0.2);
      const PoseCentroid b = PoseCentroid(0.3, 0.4, 0.2);
      expect(a.distanceTo(b), closeTo(0.5, 1e-9));
    });
  });

  group('PersonTracker.indexOfClosest', () {
    test('returns the candidate nearest the previous primary, not index 0', () {
      const PoseCentroid previous = PoseCentroid(0.7, 0.5, 0.2);
      final List<PoseCentroid> candidates = <PoseCentroid>[
        const PoseCentroid(0.2, 0.5, 0.2), // far (was "first")
        const PoseCentroid(0.72, 0.5, 0.2), // close
      ];
      final ({int index, bool reacquired}) r = PersonTracker.indexOfClosest(
        candidates: candidates,
        previous: previous,
        maxDistance: 0.25,
      );
      expect(r.index, 1);
      expect(r.reacquired, isFalse);
    });

    test('no previous → index 0, flagged as fresh acquisition', () {
      final ({int index, bool reacquired}) r = PersonTracker.indexOfClosest(
        candidates: <PoseCentroid>[
          const PoseCentroid(0.2, 0.5, 0.2),
          const PoseCentroid(0.8, 0.5, 0.2),
        ],
        previous: null,
        maxDistance: 0.25,
      );
      expect(r.index, 0);
      expect(r.reacquired, isTrue);
    });

    test('all candidates beyond maxDistance → reacquire at index 0', () {
      const PoseCentroid previous = PoseCentroid(0.1, 0.1, 0.2);
      final ({int index, bool reacquired}) r = PersonTracker.indexOfClosest(
        candidates: <PoseCentroid>[
          const PoseCentroid(0.9, 0.9, 0.2),
          const PoseCentroid(0.8, 0.85, 0.2),
        ],
        previous: previous,
        maxDistance: 0.25,
      );
      expect(r.index, 0);
      expect(r.reacquired, isTrue);
    });

    test('empty candidates → index 0, reacquired', () {
      final ({int index, bool reacquired}) r = PersonTracker.indexOfClosest(
        candidates: const <PoseCentroid>[],
        previous: const PoseCentroid(0.5, 0.5, 0.2),
        maxDistance: 0.25,
      );
      expect(r.index, 0);
      expect(r.reacquired, isTrue);
    });
  });
}
