import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {
  /// Request permissions
  static Future<bool> requestBlePermissions() async {
    final location = await Permission.locationWhenInUse.request();
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();

    return location.isGranted &&
        scan.isGranted &&
        connect.isGranted;
  }

  /// Check GPS enabled
  static Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open GPS settings
  static Future<void> openGpsSettings() async {
    await Geolocator.openLocationSettings();
  }
}


// import 'package:permission_handler/permission_handler.dart';
//
// class PermissionService {
//   static Future<bool> requestBlePermissions() async {
//     final scan = await Permission.bluetoothScan.request();
//     final connect = await Permission.bluetoothConnect.request();
//
//     // IMPORTANT: request FINE location explicitly
//     final location = await Permission.locationWhenInUse.request();
//
//     return scan.isGranted &&
//         connect.isGranted &&
//         location.isGranted;
//   }
// }
//
//
//
