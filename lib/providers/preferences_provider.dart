import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PreferencesProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs;

  PreferencesProvider(this._prefs);

  Future<bool?> getBool(String key) async {
    return (await _prefs).getBool(key);
  }

  Future<int?> getInt(String key) async {
    return (await _prefs).getInt(key);
  }

  Future<double?> getDouble(String key) async {
    return (await _prefs).getDouble(key);
  }

  Future<String?> getString(String key) async {
    return (await _prefs).getString(key);
  }

  Future<List<String>?> getStringList(String key) async {
    return (await _prefs).getStringList(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final result = await (await _prefs).setBool(key, value);
    notifyListeners();
    return result;
  }

  Future<bool> setInt(String key, int value) async {
    final result = await (await _prefs).setInt(key, value);
    notifyListeners();
    return result;
  }

  Future<bool> setDouble(String key, double value) async {
    final result = await (await _prefs).setDouble(key, value);
    notifyListeners();
    return result;
  }

  Future<bool> setString(String key, String value) async {
    final result = await (await _prefs).setString(key, value);
    notifyListeners();
    return result;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final result = await (await _prefs).setStringList(key, value);
    notifyListeners();
    return result;
  }

  Future<bool> remove(String key) async {
    final result = await (await _prefs).remove(key);
    notifyListeners();
    return result;
  }
}
