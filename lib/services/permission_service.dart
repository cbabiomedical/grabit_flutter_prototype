import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestBlePermissions() async {
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();

    // IMPORTANT: request FINE location explicitly
    final location = await Permission.locationWhenInUse.request();

    return scan.isGranted &&
        connect.isGranted &&
        location.isGranted;
  }
}


// import 'package:permission_handler/permission_handler.dart';
//
// class PermissionService {
//   static Future<bool> requestBlePermissions() async {
//     final scan = await Permission.bluetoothScan.request();
//     final connect = await Permission.bluetoothConnect.request();
//     final loc = await Permission.location.request();
//
//     return scan.isGranted && connect.isGranted && loc.isGranted;
//   }
// }
