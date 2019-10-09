import 'package:hack_heroes_mobile/logic/app_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  static SharedPreferences perfs;

  static Future<void> load() async {
    perfs = await SharedPreferences.getInstance();
  }


  static bool get firstRun {
//    return true;

    // if perfs was not initialized or the key was not found we are running for the first time
    return perfs?.getBool("firstRun") ?? true;
  }

  static set firstRun(bool value) {
    // will throw if perfs was not initialized
    perfs.setBool("firstRun", value);
  }


  static AppMode get mode {
    // default to Blind
    final mode = perfs?.getInt("appMode") ?? 0;
    switch (mode) {
      case 0:
        return AppMode.Blind;

      case 1:
        return AppMode.Helper;

      default:
        return AppMode.Blind;
    }
  }

  static set mode(AppMode mode) {
    switch (mode) {
      case AppMode.Blind:
        perfs.setInt("appMode", 0);
        break;

      case AppMode.Helper:
        perfs.setInt("appMode", 1);
        break;

      default:
        throw("Unknown mode");
    }
  }


  static bool get demoMode {
    return perfs?.getBool("demoMode") ?? false;
  }

  static set demoMode(bool value) {
    perfs.setBool("demoMode", value);
  }

}