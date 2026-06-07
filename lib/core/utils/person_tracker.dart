import 'dart:math' as math;

/// A compact stand-in for "where a detected person is" — the confidence-weighted
/// centre of the torso quad (shoulders + hips) plus a [span] (shoulder-to-hip
/// distance) used as a coarse size for tie-breaking. Coordinates are normalized
/// (0..1). Plain value object — no ML Kit/Flutter types — so it stays testable.
class PoseCentroid {
  const PoseCentroid(this.cx, this.cy, this.span);

  final double cx;
  final double cy;
  final double span;

  /// Euclidean distance between two centroids in normalized space.
  double distanceTo(PoseCentroid other) {
    final double dx = cx - other.cx;
    final double dy = cy - other.cy;
    return math.sqrt(dx * dx + dy * dy);
  }
}

/// Keeps the "primary" person stable across frames. ML Kit returns a
/// `List<Pose>` whose order is **not** guaranteed frame-to-frame, so naively
/// taking `poses.first` lets the tracked subject swap between people mid-rep.
/// This matches the current frame's centroids against the previous primary's
/// and reports which candidate to treat as primary.
///
/// Pure/stateless: the caller owns the previous centroid and passes it in.
class PersonTracker {
  const PersonTracker._();

  /// Picks the candidate centroid closest to [previous].
  ///
  /// Returns the chosen [index] into [candidates] and whether this was a fresh
  /// acquisition ([reacquired] — true when there was no previous subject, or the
  /// nearest candidate is beyond [maxDistance], i.e. the old subject is gone).
  /// On reacquisition the caller should reset any temporal filter so two
  /// people's trajectories never blend.
  ///
  /// Falls back to index 0 when [candidates] is empty (the caller guards that
  /// poses are non-empty, but this keeps the function total).
  static ({int index, bool reacquired}) indexOfClosest({
    required List<PoseCentroid> candidates,
    required PoseCentroid? previous,
    required double maxDistance,
  }) {
    if (candidates.isEmpty) return (index: 0, reacquired: true);
    if (previous == null) return (index: 0, reacquired: true);

    int best = 0;
    double bestDist = candidates[0].distanceTo(previous);
    for (int i = 1; i < candidates.length; i++) {
      final double d = candidates[i].distanceTo(previous);
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }
    if (bestDist > maxDistance) return (index: 0, reacquired: true);
    return (index: best, reacquired: false);
  }
}
