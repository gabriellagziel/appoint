import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class GeocodingResult {
  final double lat;
  final double lng;
  final String displayName;
  const GeocodingResult(
      {required this.lat, required this.lng, required this.displayName});
}

class GeocodingService {
  /// Try our Functions proxy first, then fallback to direct Nominatim.
  static Future<GeocodingResult?> geocode(String query) async {
    if (query.trim().isEmpty) return null;
    // 1) Functions proxy
    try {
      final proxy =
          ApiClient.uri('/api/places/autocomplete', query: {'q': query});
      final r = await http.get(proxy);
      if (r.statusCode == 200) {
        final parsed = json.decode(r.body) as Map<String, dynamic>;
        final preds = (parsed['predictions'] as List?) ?? [];
        if (preds.isNotEmpty) {
          final m = preds.first as Map<String, dynamic>;
          return GeocodingResult(
            lat: (m['lat'] as num).toDouble(),
            lng: (m['lng'] as num).toDouble(),
            displayName: m['description']?.toString() ?? query,
          );
        }
      }
    } catch (_) {}

    // 2) Fallback direct Nominatim
    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1');
      final resp = await http
          .get(uri, headers: {'User-Agent': 'App-Oint/1.0 (personal PWA)'});
      if (resp.statusCode != 200) return null;
      final data = json.decode(resp.body);
      if (data is List && data.isNotEmpty) {
        final m = data.first as Map<String, dynamic>;
        final lat = double.tryParse(m['lat']?.toString() ?? '');
        final lon = double.tryParse(m['lon']?.toString() ?? '');
        if (lat == null || lon == null) return null;
        return GeocodingResult(
          lat: lat,
          lng: lon,
          displayName: m['display_name']?.toString() ?? query,
        );
      }
    } catch (_) {}
    return null;
  }

  /// Get multiple predictions for autocomplete UI
  static Future<List<GeocodingResult>> fetchPredictions(String query) async {
    if (query.trim().isEmpty) return [];
    // 1) Functions proxy list
    try {
      final proxy =
          ApiClient.uri('/api/places/autocomplete', query: {'q': query});
      final r = await http.get(proxy);
      if (r.statusCode == 200) {
        final parsed = json.decode(r.body) as Map<String, dynamic>;
        final preds = (parsed['predictions'] as List?) ?? [];
        return preds.map((e) {
          final m = e as Map<String, dynamic>;
          return GeocodingResult(
            lat: (m['lat'] as num).toDouble(),
            lng: (m['lng'] as num).toDouble(),
            displayName: m['description']?.toString() ?? query,
          );
        }).toList();
      }
    } catch (_) {}

    // 2) fallback
    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5');
      final resp = await http
          .get(uri, headers: {'User-Agent': 'App-Oint/1.0 (personal PWA)'});
      if (resp.statusCode != 200) return [];
      final data = json.decode(resp.body);
      if (data is List && data.isNotEmpty) {
        return data.take(5).map<GeocodingResult>((raw) {
          final m = raw as Map<String, dynamic>;
          final lat = double.tryParse(m['lat']?.toString() ?? '');
          final lon = double.tryParse(m['lon']?.toString() ?? '');
          return GeocodingResult(
            lat: lat ?? 0,
            lng: lon ?? 0,
            displayName: m['display_name']?.toString() ?? query,
          );
        }).toList();
      }
    } catch (_) {}
    return [];
  }
}
