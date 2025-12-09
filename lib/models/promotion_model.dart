class PromotionModel {
  final String promoId;
  final String productName;
  final String machineName;
  final int basePrice;
  final int discountedPrice;
  final int discountValue;
  final DateTime expiresAt;

  PromotionModel({
    required this.promoId,
    required this.productName,
    required this.machineName,
    required this.basePrice,
    required this.discountedPrice,
    required this.discountValue,
    required this.expiresAt,
  });
}
