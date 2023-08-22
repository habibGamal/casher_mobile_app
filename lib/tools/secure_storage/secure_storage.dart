import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SecureStorage {
  static final SecureStorage _instance = SecureStorage();
  static SecureStorage get instance => _instance;
  final secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  Future<String?> getAuthToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  Future<void> setAuthToken(token) async {
    await secureStorage.write(key: 'auth_token', value: token);
  }
}
