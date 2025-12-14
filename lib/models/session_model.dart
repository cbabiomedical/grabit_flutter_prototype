class SessionModel {
  final String sessionId;
  final String userId;
  final String deviceId;
  final String machineId;
  final String status;
  final DateTime createdAt;
  final DateTime expiresAt;

  SessionModel({
    required this.sessionId,
    required this.userId,
    required this.deviceId,
    required this.machineId,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'],
      userId: json['userId'].toString(),
      deviceId: json['deviceId'],
      machineId: json['machineId'].toString(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
