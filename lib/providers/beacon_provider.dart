import 'package:flutter/material.dart';
import '../services/beacon_service.dart';
import '../services/real_api_service.dart';
import 'auth_provider.dart';

class BeaconProvider extends ChangeNotifier {
  final BeaconService beaconService;
  final RealApiService api;

  AuthProvider? auth; // injected via ProxyProvider

  String? lastBeaconName;
  String? lastBeaconMac;
  int lastRssi = -999;

  bool isNear = false;
  bool scanningEnabled = true;

  BeaconProvider({
    required this.beaconService,
    required this.api,
    required this.auth,
  }) {
    // Start BLE scanning
    startScanning();
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

    final wasNear = isNear;
    isNear = bucket == "NEAR";

    // Notify UI only if state changed
    if (isNear != wasNear) notifyListeners();

    // Debug logs
    print("DETECTED → name=$name mac=$mac rssi=$rssi bucket=$bucket");

    // Must be logged in
    if (auth == null || !auth!.isLoggedIn) return;
    if (auth!.authToken == null) return;

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
      print("Beacon detected event sent to backend.");
    } catch (e) {
      // Ignore backend failures silently
      print("Failed to send beacon-detected event.");
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


// import 'package:flutter/material.dart';
// import '../services/beacon_service.dart';
// import '../services/real_api_service.dart';
// import '../providers/auth_provider.dart';
//
// class BeaconProvider extends ChangeNotifier {
//   final BeaconService beaconService;
//   final RealApiService api;
//   final AuthProvider auth;
//
//   String? lastBeaconId;
//   int lastRssi = -999;
//
//   bool isNear = false;
//   bool scanningEnabled = true;
//
//   BeaconProvider({
//     required this.beaconService,
//     required this.api,
//     required this.auth,
//   });
//
//   // ------------------------------------------------------------
//   // START SCANNING
//   // ------------------------------------------------------------
//   void startScanning() {
//     if (!scanningEnabled) return;
//
//     beaconService.startScanning(
//       onDetect: (mac, rssi) {
//         onBeaconDetected(mac, rssi);
//       },
//     );
//   }
//
//   // ------------------------------------------------------------
//   // STOP SCANNING
//   // ------------------------------------------------------------
//   void stopScanning() {
//     beaconService.stopScanning();
//   }
//
//   // ------------------------------------------------------------
//   // HANDLE BEACON DETECTION
//   // ------------------------------------------------------------
//   Future<void> onBeaconDetected(String mac, int rssi) async {
//     lastBeaconId = mac;
//     lastRssi = rssi;
//
//     final bucket = beaconService.getDistanceBucket(rssi);
//
//     // Update UI state
//     isNear = bucket == "NEAR";
//     notifyListeners();
//
//     // We cannot call backend without being logged in
//     if (!auth.isLoggedIn) return;
//     if (auth.user == null) return;
//
//     try {
//       await api.sendBeaconDetected(
//         userId: auth.user!.userId,
//         deviceId: auth.user!.deviceId,
//         beaconId: mac,
//         rssi: rssi,
//         distanceBucket: bucket,
//         authToken: auth.authToken!, // must exist after login
//       );
//     } catch (e) {
//       // Fail silently for now to avoid UI errors
//     }
//   }
//
//   // ------------------------------------------------------------
//   // SETTINGS: TOGGLE ON/OFF
//   // ------------------------------------------------------------
//   void setScanning(bool enabled) {
//     scanningEnabled = enabled;
//
//     if (enabled) {
//       startScanning();
//     } else {
//       stopScanning();
//     }
//
//     notifyListeners();
//   }
// }
