import 'dart:async';

class BeaconService {
  final StreamController<bool> _nearController =
  StreamController<bool>.broadcast();

  Stream<bool> get nearStream => _nearController.stream;

  Timer? _mockTimer;

  void startMockScanning() {
    _mockTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      final isNear = timer.tick % 2 == 0; // FAR → NEAR toggle
      _nearController.add(isNear);
    });
  }

  void stopScanning() {
    _mockTimer?.cancel();
    _mockTimer = null;
  }
}
