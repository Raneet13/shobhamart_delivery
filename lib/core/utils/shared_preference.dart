import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _prefs;

  static Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }
}
