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

    debugPrint("REGISTER → deviceId=$deviceId");

    // Request permission
    await _fcmService.requestPermission();

    // Get FCM token
    final fcmToken = await _fcmService.getToken();

    debugPrint("FCM TOKEN SENT TO BACKEND: $fcmToken");

    final result = await api.register(
      email: email,
      password: password,
      deviceId: deviceId,
      pushToken: fcmToken ?? "", // placeholder
      platform: "android",
    );

    return true; // Navigate to login

  }

  Future<bool> login(String email, String password) async {
    final deviceId = await deviceService.getOrCreateDeviceId();

    debugPrint("LOGIN → deviceId=$deviceId");

    // Request permission
    await _fcmService.requestPermission();

    // Get FCM token
    final fcmToken = await _fcmService.getToken();

    debugPrint("FCM TOKEN SENT TO BACKEND: $fcmToken");

    // 3️⃣ Send token during login

    final result = await api.login(
      email: email,
      password: password,
      deviceId: deviceId,
      pushToken: fcmToken ?? "",
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

    // await _fcmService.requestPermission();

    // final fcmToken = await _fcmService.getToken();
    // if (fcmToken != null) {
    //   debugPrint("FCM TOKEN: $fcmToken");
    //   // TODO: send to backend if endpoint exists
    // }

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
