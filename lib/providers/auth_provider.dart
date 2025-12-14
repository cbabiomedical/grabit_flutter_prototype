import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/real_api_service.dart';
import '../services/device_service.dart';
import '../services/fcm_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final RealApiService api;
  final DeviceService deviceService;
  final FcmService _fcmService = FcmService();

  final _storage = const FlutterSecureStorage();

  UserModel? _user;
  bool _isLoggedIn = false;

  String? _authToken;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  String? get authToken => _authToken;

  AuthProvider(this.api, this.deviceService);

  Future<void> init() async {
    final token = await _storage.read(key: "authToken");
    final userId = await _storage.read(key: "userId");

    if (token != null && userId != null) {
      try {
        final profile = await api.getProfile(
          userId: userId,
          authToken: token,
        );

        _authToken = token;
        _user = UserModel.fromJson(profile);
        _isLoggedIn = true;
      } catch (_) {
        _isLoggedIn = false;
      }
    }

    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    final deviceId = await deviceService.getOrCreateDeviceId();

    final result = await api.register(
      email: email,
      password: password,
      deviceId: deviceId,
      pushToken: "PUSH_TOKEN", // placeholder
      platform: "android",
    );

    return true; // Navigate to login
  }

  Future<bool> login(String email, String password) async {
    final deviceId = await deviceService.getOrCreateDeviceId();

    final result = await api.login(
      email: email,
      password: password,
      deviceId: deviceId,
      pushToken: "PUSH_TOKEN",
      platform: "android",
    );

    final userId = result["userId"].toString();
    final token = result["authToken"];

    _authToken = token;

    await _storage.write(key: "authToken", value: token);
    await _storage.write(key: "userId", value: userId);

    final profile = await api.getProfile(
      userId: userId,
      authToken: token,
    );

    _user = UserModel.fromJson(profile);
    _isLoggedIn = true;

    await _fcmService.requestPermission();

    final fcmToken = await _fcmService.getToken();
    if (fcmToken != null) {
      debugPrint("FCM TOKEN: $fcmToken");
      // TODO: send to backend if endpoint exists
    }

    _fcmService.listenTokenRefresh((newToken) {
      debugPrint("FCM Token refreshed: $newToken");
      // TODO: update backend
    });

    _fcmService.onForegroundMessage();

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _user = null;
    _authToken = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}


// import 'package:flutter/material.dart';
// import '../services/mock_api_service.dart';
// import '../services/device_service.dart';
// import '../models/user_model.dart';
//
// class AuthProvider extends ChangeNotifier {
//   final MockApiService api;
//   final DeviceService deviceService;
//
//   bool _isLoading = false;
//   bool _isLoggedIn = false;
//   UserModel? _user;
//
//   bool get isLoading => _isLoading;
//   bool get isLoggedIn => _isLoggedIn;
//   UserModel? get user => _user;
//
//   AuthProvider(this.api, this.deviceService);
//
//   Future<void> init() async {
//     await deviceService.getOrCreateDeviceId();
//   }
//
//   Future<bool> register(String email, String password) async {
//     _isLoading = true;
//     notifyListeners();
//
//     final success = await api.mockRegister(email, password);
//
//     _isLoading = false;
//     notifyListeners();
//     return success;
//   }
//
//   Future<bool> verify(String code) async {
//     _isLoading = true;
//     notifyListeners();
//
//     final success = await api.mockVerify(code);
//
//     _isLoading = false;
//     notifyListeners();
//     return success;
//   }
//
//   Future<bool> login(String email, String password) async {
//     _isLoading = true;
//     notifyListeners();
//
//     final success = await api.mockLogin(email, password);
//     if (success) {
//       _user = UserModel('abcde123456');
//       _isLoggedIn = true;
//     }
//
//     _isLoading = false;
//     notifyListeners();
//     return success;
//   }
//
//   void logout() {
//     _isLoggedIn = false;
//     _user = null;
//     notifyListeners();
//   }
// }
