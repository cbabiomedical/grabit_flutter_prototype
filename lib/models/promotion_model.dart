class PromotionModel {
  final String promotionId;
  final String productId;
  final String discountType;
  final int discountValue;
  final DateTime expiresAt;
  final ProductModel product;

  PromotionModel({
    required this.promotionId,
    required this.productId,
    required this.discountType,
    required this.discountValue,
    required this.expiresAt,
    required this.product,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      promotionId: json['promotionId'].toString(),
      productId: json['productId'].toString(),
      discountType: json['discountType'],
      discountValue: json['discountValue'],
      expiresAt: DateTime.parse(json['expiresAt']),
      product: ProductModel.fromJson(json['product']),
    );
  }
}

class ProductModel {
  final String itemCode;
  final String name;
  final String? description;

  ProductModel({
    required this.itemCode,
    required this.name,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      itemCode: json['itemCode'],
      name: json['name'],
      description: json['description'],
    );
  }
}



// class PromotionModel {
//   final String promoId;
//   final String productName;
//   final String machineName;
//   final int basePrice;
//   final int discountedPrice;
//   final int discountValue;
//   final DateTime expiresAt;
//
//   PromotionModel({
//     required this.promoId,
//     required this.productName,
//     required this.machineName,
//     required this.basePrice,
//     required this.discountedPrice,
//     required this.discountValue,
//     required this.expiresAt,
//   });
// }
