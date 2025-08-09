import 'package:flutter/material.dart';
import '../../../services/maps/map_search_service.dart';

class OsmMapPreview extends StatelessWidget {
  final Location? location;
  final double height;
  final bool showMarker;
  final bool interactive;

  const OsmMapPreview({
    super.key,
    this.location,
    this.height = 200,
    this.showMarker = true,
    this.interactive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                'No location selected',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          // Placeholder map background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: const Center(
              child: Icon(
                Icons.map,
                size: 48,
                color: Colors.grey,
              ),
            ),
          ),
          // Location marker
          if (showMarker)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          // Location info overlay
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                location!.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
