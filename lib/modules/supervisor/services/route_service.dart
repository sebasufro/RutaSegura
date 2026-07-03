import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';

class RouteService {
  static const String _baseUrl = 'http://200.13.4.209:3000/api';
  final String? token;

  RouteService({this.token});

  Map<String, String> _headers() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<RouteModel>> fetchRoutes() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/routes'),
      headers: _headers(),
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
    final body = route.toJson()..['status'] = 'PUBLISHED';
    final response = await http.post(
      Uri.parse('$_baseUrl/routes'),
      headers: _headers(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return RouteModel.fromJson(data);
    }

    throw Exception('Failed to create route (status ${response.statusCode})');
  }

  Future<void> updateRoute(RouteModel route) async {
    final body = route.toJson()..['status'] = 'PUBLISHED';
    final response = await http.patch(
      Uri.parse('$_baseUrl/routes/${route.id}'),
      headers: _headers(),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update route (status ${response.statusCode})');
    }
  }

  Future<void> deleteRoute(String routeId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/routes/$routeId'),
      headers: _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete route (status ${response.statusCode})');
    }
  }

  Future<void> finishRoute(String routeId) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/routes/$routeId'),
      headers: _headers(),
      body: jsonEncode({'status': 'FINISHED'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to finish route (status ${response.statusCode})');
    }
  }
}
