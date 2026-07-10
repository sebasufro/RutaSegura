import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/env_config.dart';
import 'auth_service.dart';

class ProfileService {
  static String get _baseUrl => EnvConfig.baseUrl;

  Future<Map<String, dynamic>?> getProfile() async {
    final token = await AuthService.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
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
      Uri.parse('$_baseUrl/profile'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'phone_number': phoneNumber}),
    );
    return response.statusCode == 200;
  }

  // ── Contactos de emergencia ──────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getContacts() async {
    final token = await AuthService.getToken();
    if (token == null) return [];
    final response = await http.get(
      Uri.parse('$_baseUrl/volunteer/emergency-contact'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>?> createContact(String name, String number) async {
    final token = await AuthService.getToken();
    if (token == null) return null;
    final response = await http.post(
      Uri.parse('$_baseUrl/volunteer/emergency-contact'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'contact_name': name, 'contact_number': number}),
    );
    if (response.statusCode == 201) return Map<String, dynamic>.from(jsonDecode(response.body));
    return null;
  }

  Future<bool> updateContact(String id, String name, String number) async {
    final token = await AuthService.getToken();
    if (token == null) return false;
    final response = await http.patch(
      Uri.parse('$_baseUrl/volunteer/emergency-contact/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'contact_name': name, 'contact_number': number}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteContact(String id) async {
    final token = await AuthService.getToken();
    if (token == null) return false;
    final response = await http.delete(
      Uri.parse('$_baseUrl/volunteer/emergency-contact/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  // ── Direcciones ──────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAddresses() async {
    final token = await AuthService.getToken();
    if (token == null) return [];
    final response = await http.get(
      Uri.parse('$_baseUrl/user/address'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>?> createAddress(String alias, String fullAddress) async {
    final token = await AuthService.getToken();
    if (token == null) return null;
    final response = await http.post(
      Uri.parse('$_baseUrl/user/address'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'alias': alias, 'full_address': fullAddress}),
    );
    if (response.statusCode == 201) return Map<String, dynamic>.from(jsonDecode(response.body));
    return null;
  }

  Future<bool> updateAddress(String id, String alias, String fullAddress) async {
    final token = await AuthService.getToken();
    if (token == null) return false;
    final response = await http.patch(
      Uri.parse('$_baseUrl/user/address/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'alias': alias, 'full_address': fullAddress}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteAddress(String id) async {
    final token = await AuthService.getToken();
    if (token == null) return false;
    final response = await http.delete(
      Uri.parse('$_baseUrl/user/address/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
