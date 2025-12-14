import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../services/real_api_service.dart';
import 'auth_provider.dart';

class SessionProvider extends ChangeNotifier {
  final RealApiService api;
  AuthProvider? auth;

  SessionModel? activeSession;
  bool isLoading = false;
  String? error;

  SessionProvider({required this.api});

  Future<void> startSession(String machineId) async {
    if (auth == null || !auth!.isLoggedIn) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await api.startSession(
        userId: auth!.user!.userId,
        deviceId: auth!.user!.deviceId,
        machineId: machineId,
        authToken: auth!.authToken!,
      );

      activeSession = SessionModel.fromJson(res);
    } catch (e) {
      error = "Failed to start session";
    }

    isLoading = false;
    notifyListeners();
  }

  void clearSession() {
    activeSession = null;
    notifyListeners();
  }
}
