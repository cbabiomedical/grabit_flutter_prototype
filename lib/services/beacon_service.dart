import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BeaconService {
  StreamSubscription<List<ScanResult>>? _scanSub;
  bool isScanning = false;

  static const int nearThreshold = -55;

  void startScanning({
    required Function(String mac, int rssi) onDetect,
  }) {
    if (isScanning) return;
    isScanning = true;

    FlutterBluePlus.startScan();

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final mac = r.device.remoteId.str;
        final rssi = r.rssi;

        if (rssi < -90) continue;

        onDetect(mac, rssi);
      }
    });
  }

  void stopScanning() {
    if (!isScanning) return;
    isScanning = false;
    FlutterBluePlus.stopScan();
    _scanSub?.cancel();
    _scanSub = null;
  }
}
