import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'map_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _tabs = const [
    _HomeTab(),
    _PromoTab(),
    _QrTab(),
    _PointsTab(),
    _SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            user?.friendlyId ?? '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Scan QR at Machine"),
          const SizedBox(height: 16),
          const Expanded(child: MapWidget()),
        ],
      ),
    );
  }
}

class _PromoTab extends StatelessWidget {
  const _PromoTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text("Promotions"));
}

class _QrTab extends StatelessWidget {
  const _QrTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text("QR Scan"));
}

class _PointsTab extends StatelessWidget {
  const _PointsTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text("Points"));
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text("Settings"));
}
