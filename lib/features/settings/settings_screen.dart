import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/beacon_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final beacon = context.watch<BeaconProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Beacon Scanning'),
            value: settings.beaconEnabled,
            onChanged: (val) {
              settings.toggleBeacon(val);
              if (val) {
                beacon.start();
              } else {
                beacon.stop();
              }
            },
          ),
        ],
      ),
    );
  }
}
