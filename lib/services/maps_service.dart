import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsService {
  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );
}
