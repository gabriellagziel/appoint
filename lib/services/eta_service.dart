import 'dart:convert';
import 'package:appoint/config/environment_config.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TravelMode { driving, walking, bicycling, transit }

class EtaService {
  // singleton
  EtaService._();
  static final EtaService _instance = EtaService._();
  factory EtaService() => _instance;

  Future<int?> getEtaMinutes({
    required LatLng origin,
    required LatLng dest,
    TravelMode mode = TravelMode.driving,
  }) async {
    final key = EnvironmentConfig.googleMapsApiKey;
    if (key.isEmpty) {
      throw Exception('Google Maps API key not configured');
    }

    final uri = Uri.https('maps.googleapis.com', '/maps/api/distancematrix/json', {
      'origins': '${origin.latitude},${origin.longitude}',
      'destinations': '${dest.latitude},${dest.longitude}',
      'departure_time': 'now',
      'mode': mode.name,
      'traffic_model': 'best_guess',
      'key': key,
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Distance Matrix API error ${res.statusCode}');
    }
    final data = jsonDecode(res.body);
    if (data['rows'] == null ||
        data['rows'][0]['elements'][0]['status'] != 'OK') {
      return null;
    }
    final element = data['rows'][0]['elements'][0];
    final seconds = element['duration_in_traffic']?['value'] ?? element['duration']['value'];
    return (seconds / 60).round();
  }
}