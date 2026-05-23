/// Shared analysis tuning constants.
///
/// Video pose analysis samples one frame every [kVideoSampleInterval] (~10 fps);
/// the gait analyzer uses the same interval to convert frame counts into real
/// time, and results playback steps frames at this rate. Denser sampling gives
/// smoother playback and cleaner step detection at the cost of analysis time.
const Duration kVideoSampleInterval = Duration(milliseconds: 100);
