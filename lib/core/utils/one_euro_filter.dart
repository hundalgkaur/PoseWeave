import 'dart:math' as math;

/// The 1€ (One-Euro) low-pass filter — an adaptive smoother that trades jitter
/// for lag based on speed: nearly-still signals are smoothed hard (low jitter),
/// fast-moving signals are barely smoothed (low lag). This beats a fixed-alpha
/// EMA for live pose landmarks, where a single constant either lags on motion or
/// shakes at rest.
///
/// Reference: Casiez, Roussel & Vogel, "1€ Filter: A Simple Speed-based
/// Low-pass Filter for Noisy Input in Interactive Systems" (CHI 2012).
///
/// Pure Dart — no Flutter/ML Kit imports — so it's unit-testable in isolation.
/// One instance filters a single scalar stream; compose several for x/y/z.
class OneEuroFilter {
  OneEuroFilter({
    this.minCutoff = 1.0,
    this.beta = 0.007,
    this.dCutoff = 1.0,
  });

  /// Minimum cutoff frequency (Hz). Lower = more smoothing at rest.
  final double minCutoff;

  /// Speed coefficient. Higher = less lag when the signal moves fast.
  final double beta;

  /// Cutoff frequency for the derivative low-pass (Hz).
  final double dCutoff;

  double _xPrev = 0;
  double _dxPrev = 0;
  double _tPrev = 0;
  bool _initialized = false;

  /// Drops all state so the next [filter] call re-seeds (used when the tracked
  /// subject is lost/reacquired — never blend two trajectories).
  void reset() => _initialized = false;

  /// True once seeded; lets callers read [lastValue] for hold-last-good.
  bool get hasState => _initialized;

  /// The last emitted value (only meaningful when [hasState]).
  double get lastValue => _xPrev;

  /// Standard low-pass smoothing factor for a cutoff and timestep.
  static double _alpha(double cutoff, double dt) {
    final double tau = 1.0 / (2 * math.pi * cutoff);
    return 1.0 / (1.0 + tau / dt);
  }

  /// Filters [value] sampled at [tSeconds] (absolute, seconds). Returns the
  /// smoothed value. Irregular/duplicate/out-of-order timestamps are tolerated:
  /// dt is clamped to a small positive floor so it can never divide by zero.
  double filter(double value, double tSeconds) {
    if (!_initialized) {
      _initialized = true;
      _xPrev = value;
      _dxPrev = 0;
      _tPrev = tSeconds;
      return value;
    }

    final double dt = math.max(tSeconds - _tPrev, 1e-3);
    _tPrev = tSeconds;

    // Low-pass the derivative, then derive a speed-adaptive cutoff.
    final double dx = (value - _xPrev) / dt;
    final double aD = _alpha(dCutoff, dt);
    final double dxHat = aD * dx + (1 - aD) * _dxPrev;
    _dxPrev = dxHat;

    final double cutoff = minCutoff + beta * dxHat.abs();
    final double a = _alpha(cutoff, dt);
    final double xHat = a * value + (1 - a) * _xPrev;
    _xPrev = xHat;
    return xHat;
  }
}

/// Owns one [OneEuroFilter] per axis (x, y, z) per landmark index, keyed exactly
/// like the previous EMA map. Geometry only — confidence is never filtered here
/// (the caller gates on it). Pure, so it's testable without a camera.
class LandmarkOneEuro {
  LandmarkOneEuro({
    double minCutoff = 1.0,
    double beta = 0.007,
    double dCutoff = 1.0,
  })  : _minCutoff = minCutoff,
        _beta = beta,
        _dCutoff = dCutoff;

  final double _minCutoff;
  final double _beta;
  final double _dCutoff;

  final Map<int, _AxisFilters> _byIndex = <int, _AxisFilters>{};

  _AxisFilters _filtersFor(int index) => _byIndex.putIfAbsent(
        index,
        () => _AxisFilters(
          x: OneEuroFilter(minCutoff: _minCutoff, beta: _beta, dCutoff: _dCutoff),
          y: OneEuroFilter(minCutoff: _minCutoff, beta: _beta, dCutoff: _dCutoff),
          z: OneEuroFilter(minCutoff: _minCutoff, beta: _beta, dCutoff: _dCutoff),
        ),
      );

  /// Whether index [index] has been seeded (so hold-last-good is possible).
  bool hasState(int index) => _byIndex[index]?.x.hasState ?? false;

  /// The last emitted point for [index]; only valid when [hasState] is true.
  ({double x, double y, double z}) lastValue(int index) {
    final _AxisFilters f = _filtersFor(index);
    return (x: f.x.lastValue, y: f.y.lastValue, z: f.z.lastValue);
  }

  /// Filters one landmark's coordinates at [tSeconds].
  ({double x, double y, double z}) filter(
    int index,
    double x,
    double y,
    double z,
    double tSeconds,
  ) {
    final _AxisFilters f = _filtersFor(index);
    return (
      x: f.x.filter(x, tSeconds),
      y: f.y.filter(y, tSeconds),
      z: f.z.filter(z, tSeconds),
    );
  }

  /// Drops all per-landmark state (camera stop, dispose, subject reacquired).
  void reset() => _byIndex.clear();
}

class _AxisFilters {
  _AxisFilters({required this.x, required this.y, required this.z});
  final OneEuroFilter x;
  final OneEuroFilter y;
  final OneEuroFilter z;
}
