class BeaconModel {
  final String name;
  final String address; // MAC
  final int rssi;
  final Map<int, List<int>> manufacturerData; // raw bytes
  final DateTime timestamp;

  BeaconModel({
    required this.name,
    required this.address,
    required this.rssi,
    required this.manufacturerData,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get displayName => name.isNotEmpty ? name : address;

  // Simple identifier — prefer name if available
  String get beaconId {
    if (name.isNotEmpty) return name;
    return address;
  }

  bool hasManufacturer(int companyId) => manufacturerData.containsKey(companyId);

  List<int>? manufacturerBytes(int companyId) => manufacturerData[companyId];
}
