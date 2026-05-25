import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/one_euro_filter.dart';

void main() {
  group('OneEuroFilter', () {
    test('first sample passes through unchanged (seeds state)', () {
      final OneEuroFilter f = OneEuroFilter();
      expect(f.filter(5.0, 0.0), 5.0);
      expect(f.hasState, isTrue);
      expect(f.lastValue, 5.0);
    });

    test('rejects jitter at rest — output spread < input spread', () {
      final OneEuroFilter f = OneEuroFilter();
      final math.Random rng = math.Random(42);
      const double dt = 1 / 30; // 30 fps
      double t = 0;
      // Seed at the mean so the very first pass-through value isn't an outlier.
      f.filter(0.5, t);
      final List<double> inputs = <double>[];
      final List<double> outputs = <double>[];
      for (int i = 0; i < 200; i++) {
        t += dt;
        final double noisy = 0.5 + (rng.nextDouble() - 0.5) * 0.1; // ±0.05
        inputs.add(noisy);
        outputs.add(f.filter(noisy, t));
      }
      expect(_stdDev(outputs), lessThan(_stdDev(inputs)));
    });

    test('tracks a fast move with less lag than a fixed-alpha EMA', () {
      // Step input from 0 to 1; compare settling against an alpha=0.4 EMA.
      final OneEuroFilter euro =
          OneEuroFilter(minCutoff: 1.0, beta: 0.7, dCutoff: 1.0);
      const double dt = 1 / 30;
      double t = 0;
      euro.filter(0, t);
      double ema = 0;
      const double alpha = 0.4;

      double euroOut = 0;
      for (int i = 0; i < 10; i++) {
        t += dt;
        euroOut = euro.filter(1.0, t);
        ema = alpha * 1.0 + (1 - alpha) * ema;
      }
      // With a high beta the speed-adaptive cutoff opens up on the step, so the
      // 1€ output should be at least as close to the target as the EMA.
      expect((1.0 - euroOut).abs(), lessThanOrEqualTo((1.0 - ema).abs()));
    });

    test('tolerates duplicate / out-of-order timestamps without NaN', () {
      final OneEuroFilter f = OneEuroFilter();
      f.filter(0.2, 1.0);
      final double dup = f.filter(0.8, 1.0); // dt == 0 → clamped
      final double back = f.filter(0.3, 0.5); // dt < 0 → clamped
      expect(dup.isFinite, isTrue);
      expect(back.isFinite, isTrue);
    });

    test('reset() drops state so the next sample re-seeds', () {
      final OneEuroFilter f = OneEuroFilter();
      f.filter(0.2, 0.0);
      f.filter(0.9, 0.1);
      f.reset();
      expect(f.hasState, isFalse);
      expect(f.filter(0.4, 0.2), 0.4); // pass-through again
    });
  });

  group('LandmarkOneEuro', () {
    test('filters each axis independently and exposes last value', () {
      final LandmarkOneEuro lm = LandmarkOneEuro();
      lm.filter(11, 0.1, 0.2, 0.3, 0.0);
      expect(lm.hasState(11), isTrue);
      expect(lm.hasState(12), isFalse);
      final ({double x, double y, double z}) last = lm.lastValue(11);
      expect(last.x, closeTo(0.1, 1e-9));
      expect(last.y, closeTo(0.2, 1e-9));
      expect(last.z, closeTo(0.3, 1e-9));
    });

    test('reset() clears all per-landmark state', () {
      final LandmarkOneEuro lm = LandmarkOneEuro();
      lm.filter(5, 0.5, 0.5, 0, 0.0);
      lm.reset();
      expect(lm.hasState(5), isFalse);
    });
  });
}

double _stdDev(List<double> xs) {
  final double mean = xs.reduce((a, b) => a + b) / xs.length;
  final double variance =
      xs.map((double x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) /
          xs.length;
  return math.sqrt(variance);
}
