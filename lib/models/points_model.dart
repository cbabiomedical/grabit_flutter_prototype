class PointsModel {
  final int loyaltyPoints;

  PointsModel({required this.loyaltyPoints});

  factory PointsModel.fromJson(Map<String, dynamic> json) {
    return PointsModel(
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
    );
  }
}


// class PointsModel {
//   final int totalPoints;
//
//   PointsModel(this.totalPoints);
// }
