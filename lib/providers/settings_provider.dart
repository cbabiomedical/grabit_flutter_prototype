import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _beaconEnabled = false;

  bool get beaconEnabled => _beaconEnabled;

  void toggleBeacon(bool value) {
    _beaconEnabled = value;
    notifyListeners();
  }
}
