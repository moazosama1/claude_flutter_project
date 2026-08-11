import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageManager {
  final FlutterSecureStorage _secureStorage;

  SecureStorageManager(this._secureStorage);

  Future<bool> setString({required String key, required String value}) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getString({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  Future<bool> setInt({required String key, required int value}) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int?> getInt({required String key}) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) {
      return null;
    }
    return int.parse(value);
  }

  Future<bool> setBool({required String key, required bool value}) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getBool({required String key}) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) {
      return false;
    }
    return value.toLowerCase() == "true";
  }

  Future<bool> remove({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      await _secureStorage.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }
}
