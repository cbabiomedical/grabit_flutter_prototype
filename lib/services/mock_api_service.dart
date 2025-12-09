import '../models/promotion_model.dart';
import '../models/points_model.dart';

class MockApiService {
  Future<bool> mockRegister(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> mockVerify(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return code == '123456';
  }

  Future<bool> mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<List<PromotionModel>> getPromotions() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      PromotionModel(
        promoId: 'PROMO1',
        productName: 'Coca Cola 500ml',
        machineName: 'Machine A',
        basePrice: 300,
        discountedPrice: 240,
        discountValue: 60,
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
      ),
      PromotionModel(
        promoId: 'PROMO2',
        productName: 'Pepsi 1L',
        machineName: 'Machine B',
        basePrice: 420,
        discountedPrice: 350,
        discountValue: 70,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
    ];
  }

  Future<PointsModel> getUserPoints() async {
    await Future.delayed(const Duration(seconds: 1));
    return PointsModel(180);
  }
}
