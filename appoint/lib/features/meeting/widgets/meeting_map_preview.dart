import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../models/location.dart';

class MeetingMapPreview extends StatelessWidget {
  final Location location;
  final double height;
  final bool showAttribution;

  const MeetingMapPreview({
    super.key,
    required this.location,
    this.height = 200,
    this.showAttribution = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(location.latitude, location.longitude),
                initialZoom: 15,
                 // Static preview
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.appoint.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(location.latitude, location.longitude),
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (location.name != null)
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    location.name!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            if (showAttribution)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    '© OpenStreetMap contributors',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
