import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/beacon_provider.dart';
import '../../providers/auth_provider.dart';
import '../../app/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beacon = context.watch<BeaconProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.teal,
        elevation: 1,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F9D9A), Color(0xFF56C596)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // =====================================================
            // BEACON SETTINGS
            // =====================================================
            _SectionCard(
              title: "Beacon Settings",
              icon: Icons.bluetooth,
              children: [
                SwitchListTile(
                  title: const Text("Enable Beacon Scanning"),
                  subtitle: Text(
                    beacon.scanningEnabled
                        ? "Scanning for nearby machines"
                        : "Scanning disabled",
                  ),
                  value: beacon.scanningEnabled,
                  onChanged: (enabled) {
                    context.read<BeaconProvider>().setScanning(enabled);
                  },
                ),
                SwitchListTile(
                  title: const Text("Auto-open QR"),
                  subtitle:
                  const Text("Open QR scanner automatically when detected"),
                  value: beacon.autoOpenQr,
                  onChanged: (v) {
                    beacon.autoOpenQr = v;
                    beacon.notifyListeners();
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =====================================================
            // BEACON INFO
            // =====================================================
            _SectionCard(
              title: "Last Detected Beacon",
              icon: Icons.info_outline,
              children: [
                _InfoTile(
                  icon: Icons.bluetooth_connected,
                  label: "Beacon Name",
                  value:
                  beacon.lastBeaconName ?? "No beacon detected yet",
                ),
                _InfoTile(
                  icon: Icons.qr_code_2,
                  label: "Beacon MAC",
                  value:
                  beacon.lastBeaconMac ?? "No beacon detected yet",
                ),
                _InfoTile(
                  icon: Icons.wifi_tethering,
                  label: "RSSI",
                  value: beacon.lastRssi == -999
                      ? "N/A"
                      : "${beacon.lastRssi} dBm",
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =====================================================
            // MACHINE STATUS
            // =====================================================
            if (beacon.isNear)
              Card(
                color: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Machine nearby (strong signal detected)",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // =====================================================
            // LOGOUT
            // =====================================================
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Sign out from this device"),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text(
                          "Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(ctx, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await auth.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                            (_) => false,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// REUSABLE SECTION CARD
// =====================================================
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, color: Colors.teal),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            ...children,
          ],
        ),
      ),
    );
  }
}

// =====================================================
// INFO TILE
// =====================================================
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/beacon_provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../app/app_routes.dart';
//
// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final beacon = context.watch<BeaconProvider>();
//     final auth = context.read<AuthProvider>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Settings"),
//         elevation: 1,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//
//           // SECTION HEADER
//           const Text(
//             "Beacon Settings",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//
//           // TOGGLE SCANNING SWITCH
//           SwitchListTile(
//             title: const Text("Enable Beacon Scanning"),
//             subtitle: Text(
//               beacon.scanningEnabled
//                   ? "Scanning for nearby machines"
//                   : "Scanning disabled",
//             ),
//             value: beacon.scanningEnabled,
//             onChanged: (enabled) {
//               context.read<BeaconProvider>().setScanning(enabled);
//             },
//           ),
//
//           SwitchListTile(
//             title: const Text("Auto-open QR on machine detect"),
//             subtitle: const Text("Open QR scanner automatically"),
//             value: beacon.autoOpenQr,
//             onChanged: (v) {
//               beacon.autoOpenQr = v;
//               beacon.notifyListeners();
//             },
//           ),
//
//
//           const Divider(height: 24),
//
//           // BEACON NAME
//           ListTile(
//             leading: const Icon(Icons.bluetooth),
//             title: const Text("Beacon Name"),
//             subtitle: Text(
//               beacon.lastBeaconName ?? "No beacon detected yet",
//             ),
//           ),
//
//           // // LAST BEACON INFO
//           // ListTile(
//           //   title: const Text("Last Beacon ID"),
//           //   subtitle: Text(beacon.lastBeaconMac ?? "No beacon detected yet"),
//           //   leading: const Icon(Icons.bluetooth_searching),
//           // ),
//
//           // MAC ADDRESS
//           ListTile(
//             leading: const Icon(Icons.qr_code_2),
//             title: const Text("Beacon MAC"),
//             subtitle: Text(
//               beacon.lastBeaconMac ?? "No beacon detected yet",
//             ),
//           ),
//
//           // RSSI
//           ListTile(
//             leading: const Icon(Icons.wifi_tethering),
//             title: const Text("Last RSSI"),
//             subtitle: Text(
//               beacon.lastRssi == -999 ? "N/A" : "${beacon.lastRssi} dBm",
//             ),
//           ),
//
//           // ListTile(
//           //   title: const Text("Last RSSI"),
//           //   subtitle: Text(beacon.lastRssi == -999
//           //       ? "N/A"
//           //       : "${beacon.lastRssi} dBm"),
//           //   leading: const Icon(Icons.wifi_tethering),
//           // ),
//
//           const SizedBox(height: 20),
//
//           // MACHINE NEAR STATUS
//           if (beacon.isNear)
//             Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade600,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.check_circle, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       "Machine nearby (Strong signal)",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//
//           const Divider(height: 32),
//
//           // --------------------------
//           // LOGOUT
//           // --------------------------
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text(
//               "Logout",
//               style: TextStyle(color: Colors.red),
//             ),
//             onTap: () async {
//               final confirm = await showDialog<bool>(
//                 context: context,
//                 builder: (ctx) => AlertDialog(
//                   title: const Text("Logout"),
//                   content:
//                   const Text("Are you sure you want to logout?"),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(ctx, false),
//                       child: const Text("Cancel"),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => Navigator.pop(ctx, true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       child: const Text("Logout"),
//                     ),
//                   ],
//                 ),
//               );
//
//               if (confirm == true) {
//                 await auth.logout();
//                 if (context.mounted) {
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     AppRoutes.login,
//                         (_) => false,
//                   );
//                 }
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/beacon_provider.dart';
//
// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final beacon = context.watch<BeaconProvider>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Settings")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             SwitchListTile(
//               value: beacon.scanningEnabled,
//               onChanged: (v) => beacon.setScanning(v),
//               title: const Text("Enable Beacon Scanning"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
