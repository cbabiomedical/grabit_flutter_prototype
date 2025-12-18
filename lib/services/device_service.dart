import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class DeviceService {
  String? _deviceId;

  Future<String> getOrCreateDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      _deviceId = android.id; // ANDROID_ID (stable)
    } else {
      _deviceId = "unknown-device";
    }

    debugPrint("📱 DEVICE ID (Android ID): $_deviceId");

    return _deviceId!;
  }
}

// import 'dart:math';
//
// class DeviceService {
//   String? _deviceId;
//
//   Future<String> getOrCreateDeviceId() async {
//     _deviceId ??= _generateId();
//     return _deviceId!;
//   }
//
//   String _generateId() {
//     const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//     final rand = Random();
//     return List.generate(12, (_) => chars[rand.nextInt(chars.length)]).join();
//   }
// }
