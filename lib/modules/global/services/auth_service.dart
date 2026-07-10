import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_store.dart';

/// Servicio de autenticación para iniciar sesión, registrar usuarios y manejar la sesión local.
class AuthService {
static const String _baseUrl = 'http://localhost:3000';
  static const String _tokenKey = 'jwt_token';
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';

  /// Envía las credenciales al backend y guarda el token y rol si la autenticación es válida.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, data['token']);
      await prefs.setString(_roleKey, data['rol']);
      await prefs.setString(_userIdKey, data['id_user'].toString());
      AuthStore.token = data['token'];
      return {'success': true, 'role': data['rol']};
    }

    final errorMsg = data['error'] ?? 'Correo o contraseña incorrectos';
    return {'success': false, 'message': errorMsg};
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }


  /// Registra un nuevo usuario en el backend y devuelve el mensaje de error cuando el servidor lo rechaza.
  Future<Map<String, dynamic>> signIn(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/signIn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'data': data['data']};
    }

    String errorMsg;
    if (data['message'] is List) {
      errorMsg = (data['message'] as List).join(', ');
    } else {
      errorMsg = data['message']?.toString() ?? 'No se pudo completar el registro';
    }
    return {'success': false, 'message': errorMsg, 'errors': data['errors']};
  }


static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_userIdKey);
    AuthStore.token = null;
  }
}
