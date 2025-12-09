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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  bool _navigatedToQR = false; // prevents multiple pushes

  @override
  Widget build(BuildContext context) {
    final beacon = context.watch<BeaconProvider>();

    // AUTO NAVIGATE TO QR SCAN WHEN NEAR (< 10m)
    if (beacon.isNear && !_navigatedToQR) {
      _navigatedToQR = true;

      Future.microtask(() {
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.qr)
              .then((_) => _navigatedToQR = false);
        }
      });
    }

    final screens = [
      const _HomeTab(),
      const PromotionScreen(),
      const QrScanScreen(),
      const PointsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("GrabIt"),
        centerTitle: true,
      ),

      body: screens[_index],

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
    final beacon = context.watch<BeaconProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // USER FRIENDLY ID
          Text(
            "Your ID: ${auth.user?.friendlyId ?? ''}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // BEACON STATUS INDICATOR
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: beacon.isNear ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              beacon.isNear
                  ? "Near a machine — QR scanning will open automatically"
                  : "Far from machines",
              style: TextStyle(
                fontSize: 16,
                color: beacon.isNear ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // MAP WIDGET
          const Expanded(child: MapWidget()),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/beacon_provider.dart';
// import '../../widgets/bottom_nav_bar.dart';
// import '../promotion/promotion_screen.dart';
// import '../qr_scan/qr_scan_screen.dart';
// import '../points/points_screen.dart';
// import '../settings/settings_screen.dart';
// import 'map_widget.dart';
// import '../../app/app_routes.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _index = 0;
//
//   final _screens = const [
//     _HomeTab(),
//     PromotionScreen(),
//     QrScanScreen(),
//     PointsScreen(),
//     SettingsScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final beacon = context.watch<BeaconProvider>();
//
//     if (beacon.isNear) {
//       Future.microtask(() {
//         Navigator.pushNamed(context, AppRoutes.qrScan);
//       });
//     }
//
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('GrabIt')),
//       body: _screens[_index],
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
//
//     return Column(
//       children: [
//         const SizedBox(height: 12),
//         Text(
//           auth.user?.friendlyId ?? '',
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         const Expanded(child: MapWidget()),
//       ],
//     );
//   }
// }
