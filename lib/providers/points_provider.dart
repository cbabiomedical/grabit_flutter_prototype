import 'package:flutter/material.dart';
import '../models/points_model.dart';
import '../services/mock_api_service.dart';

class PointsProvider extends ChangeNotifier {
  final MockApiService api;

  PointsProvider(this.api);

  PointsModel? _points;
  bool _loading = false;

  PointsModel? get points => _points;
  bool get isLoading => _loading;

  Future<void> loadPoints() async {
    _loading = true;
    notifyListeners();

    _points = await api.getUserPoints();

    _loading = false;
    notifyListeners();
  }
}
