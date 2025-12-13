import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BeaconService {
  StreamSubscription<List<ScanResult>>? _scanSub;
  bool isScanning = false;

  // RSSI thresholds for distance buckets
  static const int nearThreshold = -55;   // Very close (<1–2m)
  static const int midThreshold  = -70;   // Medium range (<4–6m)

  String getDistanceBucket(int rssi) {
    if (rssi >= nearThreshold) return "NEAR";
    if (rssi >= midThreshold)  return "MID";
    return "FAR";
  }

  /// Start BLE scanning – returns MAC + RSSI for each detected beacon
  void startScanning({
    required Function(String name, String mac, int rssi) onDetect,
  }) {
    if (isScanning) return;
    isScanning = true;

    // Start BLE scan
    FlutterBluePlus.startScan();

    // Subscribe to scan results
    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        final device = result.device;

        final name = device.platformName;  // Beacon name
        final mac = device.remoteId.str;
        final rssi = result.rssi;

        if (name.isEmpty) continue;

        // FILTER BY BEACON NAME PREFIX
        if (!name.startsWith("CBA")) continue;

        // Filter out weak noise signals
        if (rssi < -90) continue;

        // Report detection to provider
        onDetect(name, mac, rssi);
      }
    });
  }

  /// Stop BLE scanning
  void stopScanning() {
    if (!isScanning) return;

    isScanning = false;
    FlutterBluePlus.stopScan();

    _scanSub?.cancel();
    _scanSub = null;
  }
}
