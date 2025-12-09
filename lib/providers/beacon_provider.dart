import 'package:flutter/material.dart';
import '../services/beacon_service.dart';

class BeaconProvider extends ChangeNotifier {
  final BeaconService _beaconService;

  bool _isNear = false;

  bool get isNear => _isNear;

  BeaconProvider(this._beaconService) {
    _beaconService.nearStream.listen((near) {
      _isNear = near;
      notifyListeners();
    });
  }

  void start() {
    _beaconService.startMockScanning();
  }

  void stop() {
    _beaconService.stopScanning();
  }
}
