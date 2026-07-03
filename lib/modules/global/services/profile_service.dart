import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ProfileService {
  static const String _baseUrl = 'http://200.13.4.209:3000';

  Future<Map<String, dynamic>?> getProfile() async {
    final token = await AuthService.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/api/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<bool> updatePhoneNumber(String phoneNumber) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.patch(
      Uri.parse('$_baseUrl/api/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'phone_number': phoneNumber}),
    );

    return response.statusCode == 200;
  }
}
