import 'dart:convert';
import 'package:http/http.dart' as http;
import '/modules/global/services/auth_store.dart';

class AddressService {
  static const String _baseUrl = 'http://200.13.4.209:3000/api';

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthStore.token ?? ''}',
    };
  }

  static Future<List<Map<String, dynamic>>> getAddresses() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/address'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List<dynamic>;
      return body.cast<Map<String, dynamic>>();
    }
    throw Exception('Error al cargar direcciones');
  }

  static Future<Map<String, dynamic>> createAddress(
      String alias, String fullAddress) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/address'),
      headers: _headers(),
      body: jsonEncode({'alias': alias, 'full_address': fullAddress}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Error al crear dirección');
  }

  static Future<void> updateAddress(
      String id, String alias, String fullAddress) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/user/address/$id'),
      headers: _headers(),
      body: jsonEncode({'alias': alias, 'full_address': fullAddress}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar dirección');
    }
  }

  static Future<void> deleteAddress(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/user/address/$id'),
      headers: _headers(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar dirección');
    }
  }
}
