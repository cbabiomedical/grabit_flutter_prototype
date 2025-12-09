import 'package:flutter/material.dart';
import '../models/promotion_model.dart';
import '../services/mock_api_service.dart';

class PromotionProvider extends ChangeNotifier {
  final MockApiService api;

  PromotionProvider(this.api);

  List<PromotionModel> _promotions = [];
  bool _loading = false;

  List<PromotionModel> get promotions => _promotions;
  bool get isLoading => _loading;

  Future<void> loadPromotions() async {
    _loading = true;
    notifyListeners();

    _promotions = await api.getPromotions();

    _loading = false;
    notifyListeners();
  }
}
