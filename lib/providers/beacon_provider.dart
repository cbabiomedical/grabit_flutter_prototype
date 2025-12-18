import 'package:flutter/material.dart';
import '../services/beacon_service.dart';
import '../services/real_api_service.dart';
import '../services/local_notification_service.dart';
import 'auth_provider.dart';

class BeaconProvider extends ChangeNotifier {
  final BeaconService beaconService;
  final RealApiService api;

  AuthProvider? auth; // injected via ProxyProvider

  String? lastBeaconName;
  String? lastBeaconMac;
  int lastRssi = -999;
  String? _lastDistanceBucket;

  bool isNear = false;
  bool scanningEnabled = true;

  bool autoOpenQr = true;
  bool qrOpened = false;

  // LOCAL NOTIFICATION FLAG
  bool _localNotificationSent = false;

  //THROTTLING CONFIG
  static const Duration beaconSendInterval = Duration(seconds: 30);
  final Map<String, DateTime> _lastSentTime = {};

  BeaconProvider({
    required this.beaconService,
    required this.api,
    required this.auth,
  }) {
    // // Start BLE scanning
    // startScanning();
  }

  void startScanning() {
    if (!scanningEnabled) return;

    beaconService.startScanning(
      onDetect: (name, mac, rssi) {
        onBeaconDetected(name, mac, rssi);
      },
    );
  }

  void stopScanning() {
    scanningEnabled = false;
    beaconService.stopScanning();
    notifyListeners();
  }

  Future<void> onBeaconDetected(String name, String mac, int rssi) async {
    lastBeaconName = name;
    lastBeaconMac = mac;
    lastRssi = rssi;

    final bucket = beaconService.getDistanceBucket(rssi);

    final previousBucket = _lastDistanceBucket;
    _lastDistanceBucket = bucket;

    isNear = bucket == "NEAR";

    // Trigger notification if bucket changed
    if (previousBucket != bucket) {
      debugPrint(
        "Distance bucket changed: $previousBucket → $bucket",
      );

      // 🔔 LOCAL NOTIFICATION FOR ANY BUCKET
      LocalNotificationService.showBeaconNotification(
        beaconName: name,
        deviceId: auth!.user!.deviceId,
        machineName: name,
        rssi: rssi,
        distanceBucket: bucket,
      );
    }

    // Reset QR only when entering NEAR
    if (bucket == "NEAR" && previousBucket != "NEAR") {
      qrOpened = false;
    }

    notifyListeners();

    // final wasNear = isNear;
    // isNear = bucket == "NEAR";

    // // RESET WHEN USER MOVES AWAY
    // if (!isNear) {
    //   _localNotificationSent = false;
    // }

    // // Notify UI only if state changed
    // if (isNear && !wasNear) {
    //   qrOpened = false; // reset on new approach
    //   notifyListeners();
    // }

    // Debug log (always visible)
    debugPrint(
      "DETECTED → name=$name mac=$mac rssi=$rssi bucket=$bucket",
    );

    debugPrint(
        "📡 BEACON EVENT → userId=${auth!.user!.userId} "
            "deviceId=${auth!.user!.deviceId} "
            "beacon=$name rssi=$rssi"
    );

    // LOCAL NOTIFICATION (IMMEDIATE)
    if (isNear &&
        !_localNotificationSent &&
        auth != null &&
        auth!.isLoggedIn) {
      _localNotificationSent = true;

      LocalNotificationService.showBeaconNotification(
        beaconName: name,
        deviceId: auth!.user!.deviceId,
        machineName: "CBA TEST 1111111111",
        rssi: rssi,
        distanceBucket: bucket,
      );
    }

    // Must be logged in
    if (auth == null || !auth!.isLoggedIn) return;
    if (auth!.authToken == null) return;

    // ⏱️ THROTTLING LOGIC (per beacon NAME)
    final now = DateTime.now();
    final lastSent = _lastSentTime[name];

    if (lastSent != null &&
        now.difference(lastSent) < beaconSendInterval) {
      debugPrint(
        "⏱️ Beacon skipped (throttled) → $name "
            "(${now.difference(lastSent).inSeconds}s)",
      );
      return;
    }

    _lastSentTime[name] = now;

    debugPrint("📡 Sending beacon-detected → $name");

    try {
      await api.sendBeaconDetected(
        userId: auth!.user!.userId,
        deviceId: auth!.user!.deviceId,
        // beaconId: mac,
        beaconId: name, // We now send BEACON NAME (CBA016)
        rssi: rssi,
        distanceBucket: bucket,
        authToken: auth!.authToken!,
      );
      debugPrint("Beacon detected event sent to backend.");
    } catch (e) {
      // Ignore backend failures silently
      debugPrint("Beacon detected event sent to backend.");
    }
  }

  void setScanning(bool enabled) {
    scanningEnabled = enabled;

    if (enabled) {
      startScanning();
    } else {
      stopScanning();
    }

    notifyListeners();
  }
}
