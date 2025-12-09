import 'dart:math';

class DeviceService {
  String? _deviceId;

  Future<String> getOrCreateDeviceId() async {
    _deviceId ??= _generateId();
    return _deviceId!;
  }

  String _generateId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(12, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
