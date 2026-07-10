import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/env_config.dart';
import 'auth_service.dart';

class LocationService {
  static String get _baseUrl => EnvConfig.baseUrl;

  Future<bool> sendLocation(String routeId, double latitude, double longitude) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/volunteer/location'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id_route': routeId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> toggleSos(String routeId, bool sosActive) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.patch(
      Uri.parse('$_baseUrl/volunteer/location/sos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id_route': routeId, 'sos_active': sosActive}),
    );

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getRouteLocations(String routeId) async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$_baseUrl/volunteer/location/$routeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final locations = data['locations'] as List;
      return locations.map((l) => Map<String, dynamic>.from(l)).toList();
    }
    return [];
  }
}
