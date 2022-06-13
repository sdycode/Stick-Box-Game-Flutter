import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static late SharedPreferences pref;
  static double volume = getVolume();

  static Future init() async {
    // initPlatformState();
    pref = await SharedPreferences.getInstance();
  }

  static double getVolume() {
    return pref.getDouble('volume') ?? 0.2;
  }

  static setVolume(double d) {
    pref.setDouble('volume', d);
  }


 static double getCompSpeed() {
    return pref.getDouble('speed') ?? 0.4;
  }
  static setCompSpeed(double d) {
    pref.setDouble('speed', d);
  }
  static int gameCompleted = pref.getInt('game') ?? 0;

  static void incrementGameCompleteCount() {
    if (pref == null) {
      init().then((v) {
        pref = v;
        gameCompleted = getGameCompletedCount();
        pref.setInt('game', gameCompleted + 1);
      });
    } else {
      gameCompleted = getGameCompletedCount();
      pref.setInt('game', gameCompleted + 1);
    }
  }

  static int getGameCompletedCount() {
    if (pref == null) {
      init();

      return pref.getInt('game') ?? gameCompleted;
    } else {
      return pref.getInt('game') ?? gameCompleted;
    }
  }

  static bool getSoundStatus() {
    if (pref == null) {
      init();
      return pref.getBool('sound') ?? false;
    } else {
      return pref.getBool('sound') ?? false;
    }
  }

  static void changeSoundONOFF(bool b) {
    if (pref == null) {
      init();
      pref.setBool('sound', b);
    } else {
      pref.setBool('sound', b);
    }
  }

  static void setRatedDone() {
    if (pref == null) {
      init().then((v) {
        pref = v;
        pref.setBool('ratedone', true);
      });
    } else {
      pref.setBool('ratedone', true);
    }
  }

  static bool isRatedFun() {
    if (pref == null) {
      init().then((v) {
        pref = v;
        return pref.getBool('ratedone') ?? false;
      });
    } else {
      return pref.getBool('ratedone') ?? false;
    }
    return false;
  }

  static Future resetGameCompletCount(int i) async {
    pref.setInt('game', 0);
  }
}
