import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Stores JWT access/refresh tokens encrypted on-device.
@LazySingleton()
class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _access = 'jwt_access';
  static const String _refresh = 'jwt_refresh';

  Future<String?> getAccessToken() => _storage.read(key: _access);
  Future<String?> getRefreshToken() => _storage.read(key: _refresh);

  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: _access, value: access);
    await _storage.write(key: _refresh, value: refresh);
  }

  Future<void> clear() async {
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
  }

  Future<bool> get isLoggedIn async => (await getAccessToken()) != null;
}
