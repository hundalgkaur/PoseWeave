/// Shared analysis tuning constants.
///
/// Video pose analysis samples one frame every [kVideoSampleInterval]; the gait
/// analyzer uses the same interval to convert frame counts into real time.
const Duration kVideoSampleInterval = Duration(milliseconds: 200);
