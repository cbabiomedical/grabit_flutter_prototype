import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class RealApiService {
  static const String baseUrl = "http://138.201.99.178:6500/core/api/v1/beacon";

  // -----------------------------
  // REGISTER
  // -----------------------------
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String deviceId,
    required String pushToken,
    required String platform,
  }) async {
    final url = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "deviceId": deviceId,
        "platform": platform,
        "pushToken": pushToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Register failed: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // -----------------------------
  // LOGIN
  // -----------------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String deviceId,
    required String pushToken,
    required String platform,
  }) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "deviceId": deviceId,
        "platform": platform,
        "pushToken": pushToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Login failed: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // -----------------------------
  // GET PROFILE
  // -----------------------------
  Future<Map<String, dynamic>> getProfile({
    required String userId,
    required String authToken,
  }) async {
    final url = Uri.parse("$baseUrl/user/profile/$userId");

    final response = await http.get(
      url,
      headers: {
        "X-Auth-Token": authToken,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Get profile failed: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // -----------------------------
  // BEACON DETECTED
  // -----------------------------
  Future<void> sendBeaconDetected({
    required String userId,
    required String deviceId,
    required String beaconId,
    required int rssi,
    required String distanceBucket,
    required String authToken,
  }) async {
    final url = Uri.parse("$baseUrl/detected");

    // -----------------------------
    // 🔍 DEBUG: REQUEST LOGS
    // -----------------------------
    debugPrint("📡 Beacon API REQUEST");
    debugPrint("userId=$userId");
    debugPrint("deviceId=$deviceId");
    debugPrint("beaconId=$beaconId");
    debugPrint("rssi=$rssi");
    debugPrint("distanceBucket=$distanceBucket");
    debugPrint("authToken=${authToken.substring(0, 10)}...");

    final response = await http.post(
      url,
      headers: {
        "X-Auth-Token": authToken,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userId": userId,
        "deviceId": deviceId,
        "beaconId": beaconId,
        "rssi": rssi,
        "distanceBucket": distanceBucket,
      }),
    );

    // -----------------------------
    // 🔍 DEBUG: RESPONSE LOGS
    // -----------------------------
    debugPrint("📡 Beacon API RESPONSE ${response.statusCode}");
    debugPrint("📡 Body: ${response.body}");

    // if (response.statusCode != 200) {
    //   throw Exception("Beacon detected failed: ${response.body}");
    // }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint("Beacon API error ${response.statusCode}");
      debugPrint("Response body: ${response.body}");
      throw Exception("Beacon detected failed");
    }
  }

  Future<List<dynamic>> getActivePromotions({
    required String userId,
    required String authToken,
  }) async {
    final url = Uri.parse(
      "$baseUrl/promotions/active/$userId",
    );

    final response = await http.get(
      url,
      headers: {
        "X-Auth-Token": authToken,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load promotions: ${response.body}");
    }

    final decoded = jsonDecode(response.body);
    return decoded['promotions'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> startSession({
    required String userId,
    required String deviceId,
    required String machineId,
    required String authToken,
  }) async {
    final url = Uri.parse("$baseUrl/session/start");

    final response = await http.post(
      url,
      headers: {
        "X-Auth-Token": authToken,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userId": userId,
        "deviceId": deviceId,
        "machineId": machineId, // AS-IS
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Session start failed: ${response.body}");
    }

    return jsonDecode(response.body);
  }


}
