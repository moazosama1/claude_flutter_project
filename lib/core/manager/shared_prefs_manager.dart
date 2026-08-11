import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPrefsManager {
  final SharedPreferences _prefs;

  SharedPrefsManager(this._prefs);

  String? getString({required String key}) => _prefs.getString(key);

  Future<bool> setString({required String key, required String value}) async =>
      await _prefs.setString(key, value);

  int? getInt({required String key}) => _prefs.getInt(key);

  Future<bool> setInt({required String key, required int value}) async =>
      await _prefs.setInt(key, value);

  bool getBool({required String key}) => _prefs.getBool(key) ?? false;

  Future<bool> setBool({required String key, required bool value}) async =>
      await _prefs.setBool(key, value);

  Future<bool> remove({required String key}) async => await _prefs.remove(key);

  Future<bool> clear() async => await _prefs.clear();
}
