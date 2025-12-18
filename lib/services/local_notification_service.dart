import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app/app_routes.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'beacon_channel',
    'Beacon Notifications',
    description: 'Notifications triggered by nearby vending machines',
    importance: Importance.high,
  );

  /// INIT (call once in main)
  static Future<void> init() async {
    const androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == 'promotions') {
          navigatorKey.currentState
              ?.pushNamed(AppRoutes.promotions);
        }
      },
    );

    final androidPlugin =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  /// SHOW BEACON NOTIFICATION
  static Future<void> showBeaconNotification({
    required String beaconName,
    required String deviceId,
    required String machineName,
    required int rssi,
    required String distanceBucket,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final details = NotificationDetails(android: androidDetails);

    final message = '''
    We detected beacon $beaconName using your device $deviceId.
    Vending Machine: $machineName.
    RSSI: $rssi
    Distance Bucket: $distanceBucket
    ''';

    await _notifications.show(
      0,
      'GrabIt Machine Nearby',
      message,
      details,
      payload: 'promotions',
    );
  }
}

/// GLOBAL NAVIGATOR (required for notification tap navigation)
final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();
