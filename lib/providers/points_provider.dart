import 'package:flutter/material.dart';
import '../models/points_model.dart';
import '../services/real_api_service.dart';
import '../providers/auth_provider.dart';

class PointsProvider extends ChangeNotifier {
  final RealApiService api;
  AuthProvider? auth;

  PointsProvider({required this.api});

  bool isLoading = false;
  PointsModel? points;

  Future<void> loadPoints() async {
    if (auth == null || !auth!.isLoggedIn) return;

    isLoading = true;
    notifyListeners();

    try {
      final profile = await api.getProfile(
        userId: auth!.user!.userId,
        authToken: auth!.authToken!,
      );

      points = PointsModel.fromJson(profile);
    } catch (e) {
      debugPrint("Failed to load points: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}


// class PointsProvider extends ChangeNotifier {
//   final MockApiService api;
//
//   PointsProvider(this.api);
//
//   PointsModel? _points;
//   bool _loading = false;
//
//   PointsModel? get points => _points;
//   bool get isLoading => _loading;
//
//   Future<void> loadPoints() async {
//     _loading = true;
//     notifyListeners();
//
//     _points = await api.getUserPoints();
//
//     _loading = false;
//     notifyListeners();
//   }
// }
