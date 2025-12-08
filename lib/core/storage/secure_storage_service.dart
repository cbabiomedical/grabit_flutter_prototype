import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _keyDeviceId = 'device_id';
  final _storage = const FlutterSecureStorage();

  Future<void> saveDeviceId(String id) async {
    await _storage.write(key: _keyDeviceId, value: id);
  }

  Future<String?> getDeviceId() async {
    return _storage.read(key: _keyDeviceId);
  }
}
