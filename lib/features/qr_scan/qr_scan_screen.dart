import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../app/app_routes.dart';

import '../../providers/session_provider.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with SingleTickerProviderStateMixin {
  bool _scanned = false;
  bool _autoCloseTriggered = false;
  String? _error;

  late final MobileScannerController _cameraController;
  late final AnimationController _scanLineController;

  // --------------------------
  // INIT
  // --------------------------
  @override
  void initState() {
    super.initState();

    debugPrint("QR Scanner initialized");

    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  // --------------------------
  // MACHINE ID PARSER (SAFE)
  // --------------------------
  String _parseMachineId(String raw) {
    final matches = RegExp(r'(\d{8,14})').allMatches(raw).toList();
    if (matches.isEmpty) return "";
    return matches.last.group(0)!;
  }

  // --------------------------
  // QR DETECT HANDLER (FIXED)
  // --------------------------
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_scanned) {
      debugPrint("Duplicate QR ignored");
      return;
    }

    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue;

    debugPrint("Raw QR value: $rawValue");

    if (rawValue == null || rawValue.isEmpty) {
      setState(() => _error = "Invalid QR code");
      return;
    }

    final machineId = _parseMachineId(rawValue);

    if (machineId.isEmpty) {
      debugPrint("Invalid machineId parsed");
      setState(() => _error = "Invalid machine QR code");
      return;
    }

    // LOCK SCAN + STOP CAMERA (DO NOT REMOVE WIDGET)
    setState(() => _scanned = true);
    await _cameraController.stop();
    debugPrint("Camera stopped");

    debugPrint("Final machineId sent to backend: $machineId");
    debugPrint("Starting session API call");

    try {
      await context.read<SessionProvider>().startSession(machineId);

      final session = context.read<SessionProvider>().activeSession;
      if (session != null) {
        debugPrint("Session started: ${session.sessionId}");
      }
    } catch (e) {
      debugPrint("Failed to start session: $e");

      setState(() {
        _error = "Failed to start session";
        _scanned = false;
      });

      await _cameraController.start();
    }
  }

  // --------------------------
  // BUILD
  // --------------------------
  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();

    if (session.activeSession != null) {
      _triggerAutoClose(session);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          // CAMERA ALWAYS MOUNTED (CRITICAL)
          MobileScanner(
            controller: _cameraController,
            fit: BoxFit.cover,
            onDetect: _onDetect,
          ),

          // Hide camera feed after scan (prevents black screen)
          if (_scanned)
            Container(color: Colors.black),

          // Overlay UI
          if (!_scanned)
            _buildScannerOverlay(),

          // Loading
          if (session.isLoading)
            const Center(child: CircularProgressIndicator()),

          // Error
          if (_error != null)
            _buildMessage(
              icon: Icons.error_outline,
              color: Colors.red,
              title: "Error",
              message: _error!,
            ),

          // Success
          if (session.activeSession != null)
            _buildSuccess(session),
        ],
      ),
    );
  }

  void _triggerAutoClose(SessionProvider session) {
    if (_autoCloseTriggered) return;
    _autoCloseTriggered = true;

    debugPrint("Auto-close scheduled (3 seconds)");

    Future.delayed(const Duration(seconds: 5), () async {
      if (!mounted) return;

      debugPrint("Closing QR screen safely");

      session.clearSession();

      // IMPORTANT: fully replace route
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
            (route) => false,
      );
    });
  }


  // --------------------------
  // SCANNER OVERLAY UI
  // --------------------------
  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        Container(color: Colors.black.withOpacity(0.55)),

        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal, width: 3),
            ),
          ),
        ),

        Center(
          child: SizedBox(
            width: 260,
            height: 260,
            child: AnimatedBuilder(
              animation: _scanLineController,
              builder: (_, __) {
                return Align(
                  alignment: Alignment(
                    0,
                    -1 + 2 * _scanLineController.value,
                  ),
                  child: Container(
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                );
              },
            ),
          ),
        ),

        const Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                "Align QR code inside the frame",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                "Scanning will start automatically",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------
  // SUCCESS UI
  // --------------------------
  Widget _buildSuccess(SessionProvider session) {
    final s = session.activeSession!;

    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  size: 80, color: Colors.teal),
              const SizedBox(height: 16),
              const Text(
                "Session Started",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text("Machine ID: ${s.machineId}"),
              const SizedBox(height: 6),
              Text(
                "Session ID:\n${s.sessionId}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------
  // ERROR UI
  // --------------------------
  Widget _buildMessage({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _error = null;
                    _scanned = false;
                  });
                  await _cameraController.start();
                },
                child: const Text("Try Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:provider/provider.dart';
//
// import '../../providers/session_provider.dart';
//
// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});
//
//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }
//
// class _QrScanScreenState extends State<QrScanScreen>
//     with SingleTickerProviderStateMixin {
//   bool _scanned = false;
//   bool _autoCloseTriggered = false;
//   String? _error;
//
//   late final MobileScannerController _cameraController;
//   late final AnimationController _scanLineController;
//
//   // --------------------------
//   // INIT
//   // --------------------------
//   @override
//   void initState() {
//     super.initState();
//
//     debugPrint("QR Scanner initialized");
//
//     _cameraController = MobileScannerController(
//       detectionSpeed: DetectionSpeed.noDuplicates,
//       facing: CameraFacing.back,
//     );
//
//     _scanLineController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _scanLineController.dispose();
//     super.dispose();
//   }
//
//   // --------------------------
//   // MACHINE ID PARSER (SAFE)
//   // --------------------------
//   String _parseMachineId(String raw) {
//     final matches = RegExp(r'(\d{8,14})').allMatches(raw).toList();
//     if (matches.isEmpty) return "";
//     return matches.last.group(0)!;
//   }
//
//   // --------------------------
//   // QR DETECT HANDLER (FIXED)
//   // --------------------------
//   Future<void> _onDetect(BarcodeCapture capture) async {
//     if (_scanned) {
//       debugPrint("Duplicate QR ignored");
//       return;
//     }
//
//     final barcode = capture.barcodes.first;
//     final rawValue = barcode.rawValue;
//
//     debugPrint("Raw QR value: $rawValue");
//
//     if (rawValue == null || rawValue.isEmpty) {
//       setState(() => _error = "Invalid QR code");
//       return;
//     }
//
//     final machineId = _parseMachineId(rawValue);
//
//     if (machineId.isEmpty) {
//       debugPrint("Invalid machineId parsed");
//       setState(() => _error = "Invalid machine QR code");
//       return;
//     }
//
//     // LOCK SCAN + STOP CAMERA (DO NOT REMOVE WIDGET)
//     setState(() => _scanned = true);
//     await _cameraController.stop();
//     debugPrint("Camera stopped");
//
//     debugPrint("Final machineId sent to backend: $machineId");
//     debugPrint("Starting session API call");
//
//     try {
//       await context.read<SessionProvider>().startSession(machineId);
//
//       final session = context.read<SessionProvider>().activeSession;
//       if (session != null) {
//         debugPrint("Session started: ${session.sessionId}");
//       }
//     } catch (e) {
//       debugPrint("Failed to start session: $e");
//
//       setState(() {
//         _error = "Failed to start session";
//         _scanned = false;
//       });
//
//       await _cameraController.start();
//     }
//   }
//
//   // --------------------------
//   // BUILD
//   // --------------------------
//   @override
//   Widget build(BuildContext context) {
//     final session = context.watch<SessionProvider>();
//
//     if (session.activeSession != null) {
//       _triggerAutoClose(session);
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan QR"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Stack(
//         children: [
//           // CAMERA ALWAYS MOUNTED (CRITICAL)
//           MobileScanner(
//             controller: _cameraController,
//             fit: BoxFit.cover,
//             onDetect: _onDetect,
//           ),
//
//           // Hide camera feed after scan (prevents black screen)
//           if (_scanned)
//             Container(color: Colors.black),
//
//           // Overlay UI
//           if (!_scanned)
//             _buildScannerOverlay(),
//
//           // Loading
//           if (session.isLoading)
//             const Center(child: CircularProgressIndicator()),
//
//           // Error
//           if (_error != null)
//             _buildMessage(
//               icon: Icons.error_outline,
//               color: Colors.red,
//               title: "Error",
//               message: _error!,
//             ),
//
//           // Success
//           if (session.activeSession != null)
//             _buildSuccess(session),
//         ],
//       ),
//     );
//   }
//
//   // --------------------------
//   // AUTO CLOSE AFTER SUCCESS
//   // --------------------------
//   void _triggerAutoClose(SessionProvider session) {
//     if (_autoCloseTriggered) return;
//     _autoCloseTriggered = true;
//
//     debugPrint("⏳ Auto-close scheduled (3 seconds)");
//
//     Future.delayed(const Duration(seconds: 30), () {
//       if (!mounted) return;
//
//       session.clearSession();
//       Navigator.pop(context);
//     });
//   }
//
//   // --------------------------
//   // SCANNER OVERLAY UI
//   // --------------------------
//   Widget _buildScannerOverlay() {
//     return Stack(
//       children: [
//         Container(color: Colors.black.withOpacity(0.55)),
//
//         Center(
//           child: Container(
//             width: 260,
//             height: 260,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.teal, width: 3),
//             ),
//           ),
//         ),
//
//         Center(
//           child: SizedBox(
//             width: 260,
//             height: 260,
//             child: AnimatedBuilder(
//               animation: _scanLineController,
//               builder: (_, __) {
//                 return Align(
//                   alignment: Alignment(
//                     0,
//                     -1 + 2 * _scanLineController.value,
//                   ),
//                   child: Container(
//                     height: 2,
//                     color: Colors.tealAccent,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//
//         const Positioned(
//           bottom: 80,
//           left: 0,
//           right: 0,
//           child: Column(
//             children: [
//               Text(
//                 "Align QR code inside the frame",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 6),
//               Text(
//                 "Scanning will start automatically",
//                 style: TextStyle(color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // --------------------------
//   // SUCCESS UI
//   // --------------------------
//   Widget _buildSuccess(SessionProvider session) {
//     final s = session.activeSession!;
//
//     return Center(
//       child: Card(
//         margin: const EdgeInsets.all(24),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.check_circle,
//                   size: 80, color: Colors.teal),
//               const SizedBox(height: 16),
//               const Text(
//                 "Session Started",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               Text("Machine ID: ${s.machineId}"),
//               const SizedBox(height: 6),
//               Text(
//                 "Session ID:\n${s.sessionId}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --------------------------
//   // ERROR UI
//   // --------------------------
//   Widget _buildMessage({
//     required IconData icon,
//     required Color color,
//     required String title,
//     required String message,
//   }) {
//     return Center(
//       child: Card(
//         margin: const EdgeInsets.all(24),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 80, color: color),
//               const SizedBox(height: 16),
//               Text(
//                 title,
//                 style: const TextStyle(
//                     fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               Text(message, textAlign: TextAlign.center),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () async {
//                   setState(() {
//                     _error = null;
//                     _scanned = false;
//                   });
//                   await _cameraController.start();
//                 },
//                 child: const Text("Try Again"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
