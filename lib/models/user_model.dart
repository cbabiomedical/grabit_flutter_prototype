class UserModel {
  final String userId;
  final String email;
  final String deviceId;
  final int loyaltyPoints;

  UserModel({
    required this.userId,
    required this.email,
    required this.deviceId,
    required this.loyaltyPoints,
  });

  // Friendly ID like GRB-3AF92C
  String get friendlyId {
    final short = userId.length > 6 ? userId.substring(userId.length - 6) : userId;
    return "GRB-${short.toUpperCase()}";
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"].toString(),
      email: json["email"] ?? "",
      deviceId: json["deviceId"] ?? "",
      loyaltyPoints: json["loyaltyPoints"] ?? 0,
    );
  }
}
