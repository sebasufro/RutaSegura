import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class RoutesService {
  static const String _baseUrl = 'http://200.13.4.209:3000';

  Future<List<Map<String, dynamic>>> getMyEnrollments() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$_baseUrl/api/volunteer/routes/my-enrollments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final enrollments = data['enrollments'] as List;
      return enrollments.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<bool> enroll(String routeId) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/api/volunteer/enroll/$routeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'enrollment_date': DateTime.now().toIso8601String(),
        'activity_type': 'VOLUNTARIO',
        'confirmation_status': 'PENDIENTE',
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> unenroll(String routeId) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('$_baseUrl/api/volunteer/enroll/$routeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getAvailableRoutes() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$_baseUrl/api/volunteer/routes/available'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final routes = data['routes'] as List;
      return routes.map((r) => Map<String, dynamic>.from(r)).toList();
    }
    return [];
  }
}
