import 'dart:convert';
import 'package:http/http.dart' as http;
import '/modules/global/services/auth_store.dart';

class ProfileService {
  static const String _baseUrl = 'http://200.13.4.209:3000/api';

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthStore.token ?? ''}',
    };
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['data'] as Map<String, dynamic>;
    }
    throw Exception('Error al cargar perfil');
  }

  static Future<void> updateProfile(Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : null;
      final msg = body?['message'] ?? 'Error al actualizar perfil';
      throw Exception(msg);
    }
  }
}
