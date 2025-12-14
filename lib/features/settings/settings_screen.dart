import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/beacon_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beacon = context.watch<BeaconProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // SECTION HEADER
          const Text(
            "Beacon Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // TOGGLE SCANNING SWITCH
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
            title: const Text("Auto-open QR on machine detect"),
            subtitle: const Text("Open QR scanner automatically"),
            value: beacon.autoOpenQr,
            onChanged: (v) {
              beacon.autoOpenQr = v;
              beacon.notifyListeners();
            },
          ),


          const Divider(height: 24),

          // BEACON NAME
          ListTile(
            leading: const Icon(Icons.bluetooth),
            title: const Text("Beacon Name"),
            subtitle: Text(
              beacon.lastBeaconName ?? "No beacon detected yet",
            ),
          ),

          // // LAST BEACON INFO
          // ListTile(
          //   title: const Text("Last Beacon ID"),
          //   subtitle: Text(beacon.lastBeaconMac ?? "No beacon detected yet"),
          //   leading: const Icon(Icons.bluetooth_searching),
          // ),

          // MAC ADDRESS
          ListTile(
            leading: const Icon(Icons.qr_code_2),
            title: const Text("Beacon MAC"),
            subtitle: Text(
              beacon.lastBeaconMac ?? "No beacon detected yet",
            ),
          ),

          // RSSI
          ListTile(
            leading: const Icon(Icons.wifi_tethering),
            title: const Text("Last RSSI"),
            subtitle: Text(
              beacon.lastRssi == -999 ? "N/A" : "${beacon.lastRssi} dBm",
            ),
          ),

          // ListTile(
          //   title: const Text("Last RSSI"),
          //   subtitle: Text(beacon.lastRssi == -999
          //       ? "N/A"
          //       : "${beacon.lastRssi} dBm"),
          //   leading: const Icon(Icons.wifi_tethering),
          // ),

          const SizedBox(height: 20),

          // MACHINE NEAR STATUS
          if (beacon.isNear)
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Machine nearby (Strong signal)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}



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
