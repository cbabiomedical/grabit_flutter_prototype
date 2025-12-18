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
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  bool _gpsEnabled = true;
  bool _permissionGranted = true;
  bool _checkedEnv = false;

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
    // _requestPermissions();
    _initPermissions();
    _printFcmToken();
  }

  void _printFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM TOKEN: $token");
  }

  // Future<void> _requestPermissions() async {
  //   await PermissionService.requestBlePermissions();
  //
  //   final enabled = await Geolocator.isLocationServiceEnabled();
  //   if (!enabled) {
  //     // show dialog → enable GPS
  //     await Geolocator.openLocationSettings();
  //   }
  // }

  Future<void> _initPermissions() async {
    final granted = await PermissionService.requestBlePermissions();

    if (!granted) {
      debugPrint("BLE permissions not granted");
      return;
    }

    final gps = await PermissionService.isGpsEnabled();

    if (!gps) {
      debugPrint("GPS is OFF");
      return;
    }

    debugPrint("Permissions + GPS OK → starting scan");

    if (!mounted) return;

    if (mounted) {
      setState(() {
        _permissionGranted = granted;
        _gpsEnabled = gps;
        _checkedEnv = true;
      });
    }

    if (granted && gps && mounted) {
      context.read<BeaconProvider>().startScanning();
    }

    // setState(() {
    //   _permissionGranted = granted;
    //   _gpsEnabled = gps;
    // });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("GrabIt"),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F9D9A),
              Color(0xFF56C596),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            _screens[_index],

            if (_checkedEnv && (!_gpsEnabled || !_permissionGranted))
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _PermissionWarningBanner(
                  onEnable: () async {
                    await PermissionService.openGpsSettings();
                    await Future.delayed(const Duration(seconds: 2));
                    _initPermissions(); // re-check + restart scan
                  },
                ),
              ),

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
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _PermissionWarningBanner extends StatelessWidget {
  final VoidCallback onEnable;

  const _PermissionWarningBanner({required this.onEnable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade700,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.white),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Enable Location & Permissions to detect nearby machines",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: onEnable,
            child: const Text(
              "Enable",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
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

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),

          // USER HEADER CARD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(
                        Icons.person,
                        color: Colors.teal,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.user?.friendlyId ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            beacon.isNear
                                ? "Machine nearby"
                                : "No nearby machine",
                            style: TextStyle(
                              color: beacon.isNear
                                  ? Colors.green
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (beacon.isNear)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "NEAR",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // MAP
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: MapWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MachineNearbyBubble extends StatelessWidget {
  final String name;
  const _MachineNearbyBubble({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.teal.shade700,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            "Nearby: $name",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
