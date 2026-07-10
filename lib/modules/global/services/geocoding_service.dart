import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  static final Map<String, String> _cache = {};

  static Future<String?> getComuna(double lat, double lng) async {
    final key = '${lat.toStringAsFixed(4)},${lng.toStringAsFixed(4)}';
    if (_cache.containsKey(key)) return _cache[key];

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=10&accept-language=es',
      );
      final response = await http.get(uri, headers: {'User-Agent': 'RutaSeguraApp/1.0'});
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final address = data['address'] as Map<String, dynamic>?;
      if (address == null) return null;

      final comuna = address['city'] ?? address['town'] ?? address['village'] ?? address['municipality'];
      if (comuna == null) return null;

      _cache[key] = comuna as String;
      return comuna;
    } catch (_) {
      return null;
    }
  }
}
