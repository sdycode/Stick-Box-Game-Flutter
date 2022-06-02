import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stick_box/shared.dart';

class vp with ChangeNotifier {
  double sliderValue =Shared.getVolume();

  AudioPlayer musicplayer = AudioPlayer();
  AudioCache musicCache = AudioCache();

  initMusicCahce() {
    musicCache = AudioCache(fixedPlayer: musicplayer);
    musicCache.load('gamemusic.mp3');
  }

  AudioCache getMusicCache() {
    return musicCache;
  }

  startMusicLoop() {
    musicCache.play('gamemusic.mp3', volume: sliderValue);
    // musicplayer.state != PlayerState.PLAYING
    //     ? musicCache.play('gamemusic.mp3', volume: sliderValue)
    //     : musicplayer.pause();
  }

  clearMusicLoop() {
    musicplayer.release();
    musicCache.clearAll();
  }

  pause() {
    musicplayer.pause();
  }

  resume() {
    musicplayer.resume();
  }

  setVolume(double d) {
    sliderValue = d;
    // musicplayer.pause();
    // musicplayer.resume();
    musicplayer.setVolume(sliderValue);
    // notifyListeners();
  }
}
