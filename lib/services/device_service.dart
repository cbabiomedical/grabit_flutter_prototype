import 'dart:math';
import '../core/storage/secure_storage_service.dart';

class DeviceService {
  final _storage = SecureStorageService();

  Future<String> getOrCreateDeviceId() async {
    final existing = await _storage.getDeviceId();
    if (existing != null) return existing;

    final newId = _generateId();
    await _storage.saveDeviceId(newId);
    return newId;
  }

  String _generateId() {
    final rand = Random();
    return List.generate(12, (_) => rand.nextInt(16).toRadixString(16)).join();
  }
}
