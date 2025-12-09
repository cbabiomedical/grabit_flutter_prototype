import 'package:flutter/material.dart';
import '../services/mock_api_service.dart';
import '../services/device_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final MockApiService api;
  final DeviceService deviceService;

  bool _isLoading = false;
  bool _isLoggedIn = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;

  AuthProvider(this.api, this.deviceService);

  Future<void> init() async {
    await deviceService.getOrCreateDeviceId();
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final success = await api.mockRegister(email, password);

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> verify(String code) async {
    _isLoading = true;
    notifyListeners();

    final success = await api.mockVerify(code);

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final success = await api.mockLogin(email, password);
    if (success) {
      _user = UserModel('abcde123456');
      _isLoggedIn = true;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void logout() {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}
