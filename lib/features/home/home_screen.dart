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
  }

  Future<void> _requestPermissions() async {
    await PermissionService.requestBlePermissions();
  }

  @override
  Widget build(BuildContext context) {
    final beacon = context.watch<BeaconProvider>();

    // Auto-open QR screen when near
    if (beacon.isNear) {
      Future.microtask(() {
        Navigator.pushNamed(context, AppRoutes.qr);
      });
    }

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
