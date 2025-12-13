import 'dart:convert';
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
}
