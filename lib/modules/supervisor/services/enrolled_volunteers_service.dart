import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/env_config.dart';
import '/modules/global/services/auth_store.dart';

class EnrolledVolunteersService {
  static String get _baseUrl => EnvConfig.baseUrl;

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthStore.token ?? ''}',
    };
  }

  static Future<List<Map<String, dynamic>>> findAll(String routeId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/routes/enrolled/$routeId'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List<dynamic>;
      return body.cast<Map<String, dynamic>>();
    }
    throw Exception('Error al cargar voluntarios inscritos');
  }

  static Future<Map<String, dynamic>> findOne(
      String routeId, String volunteerId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/routes/enrolled/$routeId/$volunteerId'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Error al cargar detalles del voluntario');
  }

  static Future<void> remove(String routeId, String volunteerId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/routes/enrolled/$routeId/$volunteerId'),
      headers: _headers(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar voluntario');
    }
  }
}
