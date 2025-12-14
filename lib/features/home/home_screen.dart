import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/beacon_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../promotion/promotion_screen.dart';
import '../qr_scan/qr_scan_screen.dart';
import '../points/points_screen.dart';
import '../settings/settings_screen.dart';
import 'map_widget.dart';
import '../../app/app_routes.dart';
import '../../services/permission_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    _HomeTab(),
    PromotionScreen(),
    QrScanScreen(),
    PointsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _printFcmToken();
  }

  void _printFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM TOKEN: $token");
  }

  Future<void> _requestPermissions() async {
    await PermissionService.requestBlePermissions();
  }

  @override
  Widget build(BuildContext context) {
    final beacon = context.watch<BeaconProvider>();

    // // Auto-open QR screen when near
    // if (beacon.isNear) {
    //   Future.microtask(() {
    //     Navigator.pushNamed(context, AppRoutes.qr);
    //   });
    // }

    if (beacon.isNear &&
        beacon.autoOpenQr &&
        !beacon.qrOpened) {
      beacon.qrOpened = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, AppRoutes.qr);
      });
    }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("GrabIt"),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF0F9D9A),
//               Color(0xFF56C596),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Stack(
//           children: [
//             _screens[_index],
//
//             if (beacon.isNear)
//               Positioned(
//                 bottom: 110,
//                 right: 20,
//                 child: _MachineNearbyBubble(
//                   name: beacon.lastBeaconName ?? "Machine",
//                 ),
//               ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _index,
//         onTap: (i) => setState(() => _index = i),
//       ),
//     );
//   }
// }
//
// class _HomeTab extends StatelessWidget {
//   const _HomeTab();
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final beacon = context.watch<BeaconProvider>();
//
//     return SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(height: 16),
//
//           // USER HEADER CARD
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 26,
//                       backgroundColor: Colors.teal.shade100,
//                       child: const Icon(
//                         Icons.person,
//                         color: Colors.teal,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             auth.user?.friendlyId ?? "",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             beacon.isNear
//                                 ? "Machine nearby"
//                                 : "No nearby machine",
//                             style: TextStyle(
//                               color: beacon.isNear
//                                   ? Colors.green
//                                   : Colors.grey,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (beacon.isNear)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade100,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Text(
//                           "NEAR",
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // MAP
//           const Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: MapWidget(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MachineNearbyBubble extends StatelessWidget {
//   final String name;
//   const _MachineNearbyBubble({required this.name});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.teal.shade700,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           )
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.qr_code_scanner,
//             color: Colors.white,
//             size: 20,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             "Nearby: $name",
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


    return Scaffold(
      appBar: AppBar(
        title: const Text("GrabIt"),
        elevation: 1,
      ),

      body: Stack(
        children: [
          _screens[_index],

          if (beacon.isNear)
            Positioned(
              bottom: 110,
              right: 20,
              child: _MachineNearbyBubble(
                name: beacon.lastBeaconName ?? "Machine",
              ),
            ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          auth.user?.friendlyId ?? "",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        const Expanded(child: MapWidget()),
      ],
    );
  }
}

class _MachineNearbyBubble extends StatelessWidget {
  final String name;
  const _MachineNearbyBubble({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal.shade600,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_tethering, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(
            "Nearby: $name",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
