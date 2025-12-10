import 'dart:async';
import 'package:flutter/material.dart';
import '../services/beacon_service.dart';
import '../services/mock_api_service.dart';

class BeaconProvider extends ChangeNotifier {
  final BeaconService service;
  final MockApiService api;

  String? lastBeaconId;
  int lastRssi = -999;
  bool isNear = false;

  bool scanningEnabled = true;
  bool _hasSentDetection = false;

  Timer? _debounceTimer;

  static const int nearThreshold = -55;

  BeaconProvider(this.service, this.api);

  void updateBeacon(String mac, int rssi) {
    lastBeaconId = mac;
    lastRssi = rssi;

    final bool newIsNear = rssi >= nearThreshold;

    // If near status changed → notify UI
    if (newIsNear != isNear) {
      isNear = newIsNear;
      notifyListeners();
    }

    // Debounce + send to backend ONCE per detection burst
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _sendBeaconDetectedOnce(mac, rssi);
    });
  }

  // Prevent spamming 100s of API calls while beacon is nearby
  Future<void> _sendBeaconDetectedOnce(String mac, int rssi) async {
    if (_hasSentDetection) return;

    _hasSentDetection = true;
    await api.sendBeaconDetected(mac, rssi);

    // Reset after 10 seconds so user can move between machines
    Timer(const Duration(seconds: 10), () {
      _hasSentDetection = false;
    });
  }

  void setScanning(bool enabled) {
    scanningEnabled = enabled;

    if (enabled) {
      service.startScanning(onDetect: (mac, rssi) {
        updateBeacon(mac, rssi);
      });
    } else {
      service.stopScanning();
      lastBeaconId = null;
      isNear = false;
      notifyListeners();
    }
  }
}
