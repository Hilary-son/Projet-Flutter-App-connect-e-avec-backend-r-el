import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: 'access', value: access);
    await _storage.write(key: 'refresh', value: refresh);
  }

  Future<String?> get access => _storage.read(key: 'access');
  Future<String?> get refresh => _storage.read(key: 'refresh');

  Future<void> clear() async {
    await _storage.delete(key: 'access');
    await _storage.delete(key: 'refresh');
  }
}
