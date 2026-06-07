/// The exercises the rep counter can track. Each maps to a joint-angle (or
/// position) signal + threshold spec inside `RepCounter` (core/utils).
enum Exercise { squat, pushup, situp, bicepCurl, jumpingJack }

extension ExerciseX on Exercise {
  /// Human-readable name for pickers and headers.
  String get label {
    switch (this) {
      case Exercise.squat:
        return 'Squats';
      case Exercise.pushup:
        return 'Push-ups';
      case Exercise.situp:
        return 'Sit-ups';
      case Exercise.bicepCurl:
        return 'Bicep Curls';
      case Exercise.jumpingJack:
        return 'Jumping Jacks';
    }
  }

  /// Short cue shown on the picker card and live coaching banner.
  String get instructions {
    switch (this) {
      case Exercise.squat:
        return 'Side-on, full body in frame. Bend knees then stand tall.';
      case Exercise.pushup:
        return 'Side-on, full body. Lower until elbows bend, then press up.';
      case Exercise.situp:
        return 'Side-on, full body. Curl up then lower back down.';
      case Exercise.bicepCurl:
        return 'Face the camera. Curl the forearm up, then extend down.';
      case Exercise.jumpingJack:
        return 'Face the camera, full body. Open arms/legs, then close.';
    }
  }
}
