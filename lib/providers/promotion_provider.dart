import 'package:flutter/material.dart';
import '../models/promotion_model.dart';
import '../services/real_api_service.dart';
import 'auth_provider.dart';

class PromotionProvider extends ChangeNotifier {
  final RealApiService api;
  AuthProvider? auth;

  PromotionProvider({required this.api});

  bool isLoading = false;
  String? error;
  List<PromotionModel> promotions = [];

  Future<void> fetchPromotions() async {
    debugPrint("fetchPromotions() called");

    if (auth == null || !auth!.isLoggedIn) {
      debugPrint("❌ AuthProvider is NULL");
      debugPrint("❌ User is NOT logged in");
      return;
    }

    debugPrint("✅ Logged in as userId=${auth!.user!.userId}");
    debugPrint("🔑 authToken=${auth!.authToken?.substring(0, 10)}...");

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final list = await api.getActivePromotions(
        userId: auth!.user!.userId,
        authToken: auth!.authToken!,
      );

      debugPrint("📦 Promotions received: ${list.length}");

      promotions = list
          .map((e) => PromotionModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ Promotions API error: $e");
      error = "Failed to load promotions";
    }

    isLoading = false;
    notifyListeners();
  }
}
