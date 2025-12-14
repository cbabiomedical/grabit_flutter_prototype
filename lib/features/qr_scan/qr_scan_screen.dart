import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _scanned = false;
  String? _machineId;
  String? _error;

  void _handleQr(String raw) {
    if (_scanned) return;
    _scanned = true;

    try {
      // Try JSON first
      final decoded = jsonDecode(raw);

      if (decoded is Map && decoded.containsKey('serialNo')) {
        _machineId = decoded['serialNo'].toString();
      } else {
        _machineId = raw;
      }
    } catch (_) {
      // Plain string QR
      _machineId = raw;
    }

    debugPrint("✅ QR SCANNED → machineId=$_machineId");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Machine QR"),
      ),
      body: _machineId != null
          ? _buildSuccess()
          : _error != null
          ? _buildError()
          : _buildScanner(),
    );
  }

  Widget _buildScanner() {
    return MobileScanner(
      onDetect: (capture) {
        final barcode = capture.barcodes.first;
        final raw = barcode.rawValue;
        if (raw != null) {
          _handleQr(raw);
        }
      },
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Machine Detected",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Machine ID:\n$_machineId",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            /// 🔜 Backend call will go here
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text(
        _error!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
