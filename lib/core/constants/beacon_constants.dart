class BeaconConstants {
  // The exact name prefix or name to match your beacons (from your scan)
  // Use exact 'CBA016' for specific device or 'CBA' to match many devices.
  static const String specificBeaconName = 'CBA016';
  static const String beaconNamePrefix = 'CBA';

  // RSSI thresholds (tune in the field)
  // Very Near: auto-open QR
  static const int rssiVeryNear = -55; // > -55 dBm -> very near
  // Near: show bubble, considered in proximity
  static const int rssiNear = -70;     // > -70 dBm -> near
  // Far: ignore
  static const int rssiFar = -100;

  // Manufacturer company id to check (0x0201 → 513 decimal)
  // from your scan the Company is AR Timing <0x0201>
  static const int companyIdArTiming = 0x0201;
}
