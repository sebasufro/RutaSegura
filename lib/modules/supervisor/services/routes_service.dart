import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/env_config.dart';
import '/modules/global/services/auth_service.dart';
import '../models/route_model.dart';

class RouteService {
  static String get _baseUrl => EnvConfig.baseUrl;

  Future<List<RouteModel>> fetchRoutes() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/routes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => RouteModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load routes (status ${response.statusCode})');
  }

  Future<RouteModel> createRoute(RouteModel route) async {
    final token = await AuthService.getToken();
    final body = route.toJson()..['status'] = 'PUBLISHED';
    final response = await http.post(
      Uri.parse('$_baseUrl/routes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return RouteModel.fromJson(data);
    }

    throw Exception('Failed to create route (status ${response.statusCode})');
  }

  Future<void> updateRoute(RouteModel route) async {
    final token = await AuthService.getToken();
    final body = route.toJson()..['status'] = 'PUBLISHED';
    final response = await http.patch(
      Uri.parse('$_baseUrl/routes/${route.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update route (status ${response.statusCode})');
    }
  }

  Future<void> deleteRoute(String routeId) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/routes/$routeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete route (status ${response.statusCode})');
    }
  }

  Future<void> finishRoute(String routeId) async {
    final token = await AuthService.getToken();
    final response = await http.patch(
      Uri.parse('$_baseUrl/routes/$routeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': 'FINISHED'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to finish route (status ${response.statusCode})');
    }
  }
}
