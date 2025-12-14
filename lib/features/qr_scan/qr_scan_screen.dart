import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../providers/session_provider.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _scanned = false;
  String? _machineId;
  String? _error;

  // --------------------------
  // HANDLE QR DETECTION
  // --------------------------
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_scanned) return;

    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue;

    if (rawValue == null || rawValue.isEmpty) {
      setState(() => _error = "Invalid QR code");
      return;
    }

    // 🔐 Mark scanned to avoid duplicates
    setState(() {
      _scanned = true;
      _machineId = rawValue.trim(); // KEEP AS-IS
    });

    // 🔁 Call backend session start
    try {
      await context.read<SessionProvider>().startSession(_machineId!);
    } catch (_) {
      setState(() => _error = "Failed to start session");
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
      ),
      body: Stack(
        children: [
          // --------------------------
          // CAMERA VIEW
          // --------------------------
          if (!_scanned)
            MobileScanner(
              fit: BoxFit.cover,
              onDetect: _onDetect,
            ),

          // --------------------------
          // LOADING STATE
          // --------------------------
          if (session.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // --------------------------
          // ERROR STATE
          // --------------------------
          if (_error != null)
            _buildMessage(
              icon: Icons.error,
              color: Colors.red,
              title: "Error",
              message: _error!,
            ),

          // --------------------------
          // SUCCESS STATE
          // --------------------------
          if (session.activeSession != null)
            _buildSuccess(session),
        ],
      ),
    );
  }

  // --------------------------
  // SUCCESS UI
  // --------------------------
  Widget _buildSuccess(SessionProvider session) {
    final s = session.activeSession!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              "Session Started",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Machine ID: ${s.machineId}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Session ID:\n${s.sessionId}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                session.clearSession();
                Navigator.pop(context);
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------
  // GENERIC MESSAGE UI
  // --------------------------
  Widget _buildMessage({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _scanned = false;
                  _error = null;
                });
              },
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// import 'package:provider/provider.dart';
// import '../../providers/session_provider.dart';
//
// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});
//
//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }
//
// class _QrScanScreenState extends State<QrScanScreen> {
//   bool _scanned = false;
//   String? _machineId;
//   String? _error;
//
//   // --------------------------
//   // HANDLE QR DETECTION
//   // --------------------------
//   Future<void> _onDetect(BarcodeCapture capture) async {
//     if (_scanned) return;
//
//     final barcode = capture.barcodes.first;
//     final rawValue = barcode.rawValue;
//
//     if (rawValue == null || rawValue.isEmpty) {
//       setState(() => _error = "Invalid QR code");
//       return;
//     }
//
//     // 🔐 Mark scanned to avoid duplicates
//     setState(() {
//       _scanned = true;
//       _machineId = rawValue.trim(); // KEEP AS-IS
//     });
//
//     // 🔁 Call backend session start
//     try {
//       await context.read<SessionProvider>().startSession(_machineId!);
//     } catch (_) {
//       setState(() => _error = "Failed to start session");
//     }
//   }
//
//   void _handleQr(String raw) {
//     if (_scanned) return;
//     _scanned = true;
//
//     try {
//       // Try JSON first
//       final decoded = jsonDecode(raw);
//
//       if (decoded is Map && decoded.containsKey('serialNo')) {
//         _machineId = decoded['serialNo'].toString();
//       } else {
//         _machineId = raw;
//       }
//     } catch (_) {
//       // Plain string QR
//       _machineId = raw;
//     }
//
//     debugPrint("✅ QR SCANNED → machineId=$_machineId");
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan Machine QR"),
//       ),
//       body: _machineId != null
//           ? _buildSuccess()
//           : _error != null
//           ? _buildError()
//           : _buildScanner(),
//     );
//   }
//
//   Widget _buildScanner() {
//     return MobileScanner(
//       onDetect: (capture) {
//         final barcode = capture.barcodes.first;
//         final raw = barcode.rawValue;
//         if (raw != null) {
//           _handleQr(raw);
//         }
//       },
//     );
//   }
//
//   Widget _buildSuccess() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.check_circle, color: Colors.green, size: 80),
//             const SizedBox(height: 20),
//             const Text(
//               "Machine Detected",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               "Machine ID:\n$_machineId",
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 30),
//
//             /// 🔜 Backend call will go here
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Continue"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildError() {
//     return Center(
//       child: Text(
//         _error!,
//         style: const TextStyle(color: Colors.red),
//       ),
//     );
//   }
// }
