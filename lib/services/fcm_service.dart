import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'real_api_service.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Request permission (iOS relevant, safe on Android)
  Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Listen for token refresh
  void listenTokenRefresh(Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen(onRefresh);
  }

  /// Foreground notifications
  void onForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("FCM Foreground message");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      debugPrint("Data: ${message.data}");
    });
  }

  /// When app opened from notification
  void onMessageOpenedApp(Function(RemoteMessage message) onOpen) {
    FirebaseMessaging.onMessageOpenedApp.listen(onOpen);
  }

  /// When app launched from terminated state
  Future<RemoteMessage?> getInitialMessage() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }
}
