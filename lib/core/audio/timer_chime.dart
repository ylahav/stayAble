import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class TimerChime {
  TimerChime._();

  static const _sourcePath = 'sounds/timer_done.wav';
  static AudioPlayer? _player;

  static AudioContext get _context => AudioContext(
        android: const AudioContextAndroid(
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.assistanceSonification,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      );

  static Future<AudioPlayer> _ensurePlayer() async {
    final existing = _player;
    if (existing != null) return existing;
    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setPlayerMode(PlayerMode.mediaPlayer);
    await player.setAudioContext(_context);
    await player.setSource(AssetSource(_sourcePath));
    _player = player;
    return player;
  }

  static Future<void> warmUp() async {
    try {
      await _ensurePlayer();
    } catch (_) {}
  }

  static Future<void> playEnd() async {
    await HapticFeedback.heavyImpact();
    await _play(volume: 1);
  }

  static Future<void> playTick() async {
    await HapticFeedback.selectionClick();
    await _play(volume: 0.45);
  }

  static Future<void> _play({required double volume}) async {
    try {
      final player = await _ensurePlayer();
      await player.setVolume(volume);
      await player.stop();
      await player.seek(Duration.zero);
      await player.resume();
    } catch (_) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }
}
