import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/device_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  final DeviceService deviceService;

  bool _isLoggedIn = false;
  String? _deviceId;

  bool get isLoggedIn => _isLoggedIn;
  String? get deviceId => _deviceId;

  AuthProvider(this.api, this.deviceService);

  Future<void> init() async {
    _deviceId = await deviceService.getOrCreateDeviceId();
    notifyListeners();
  }

  Future<void> mockLogin() async {
    final success = await api.mockLogin();
    _isLoggedIn = success;
    notifyListeners();
  }
}
