import 'package:flutter/material.dart';
import '../widgets/map_widget.dart';
import '../services/navigation_service.dart';

class MapTestPage extends StatefulWidget {
  const MapTestPage({super.key});

  @override
  State<MapTestPage> createState() => _MapTestPageState();
}

class _MapTestPageState extends State<MapTestPage> {
  double latitude = 37.7749;
  double longitude = -122.4194;
  String address = '123 Main Street, San Francisco, CA';

  void _updateLocation(double lat, double lng, String addr) {
    setState(() {
      latitude = lat;
      longitude = lng;
      address = addr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap Widget Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'OpenStreetMap Widget Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Test the interactive OpenStreetMap widget implementation',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Map Widget
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interactive Map',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: MapWidget(
                        latitude: latitude,
                        longitude: longitude,
                        address: address,
                        height: 300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Locations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Locations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed:
                              () => _updateLocation(
                                40.7128,
                                -74.0060,
                                'New York City, NY',
                              ),
                          child: const Text('New York City'),
                        ),
                        ElevatedButton(
                          onPressed:
                              () => _updateLocation(
                                51.5074,
                                -0.1278,
                                'London, UK',
                              ),
                          child: const Text('London'),
                        ),
                        ElevatedButton(
                          onPressed:
                              () => _updateLocation(
                                35.6762,
                                139.6503,
                                'Tokyo, Japan',
                              ),
                          child: const Text('Tokyo'),
                        ),
                        ElevatedButton(
                          onPressed:
                              () => _updateLocation(
                                48.8566,
                                2.3522,
                                'Paris, France',
                              ),
                          child: const Text('Paris'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Navigation Test',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await NavigationService.openDirections(
                                  latitude: latitude,
                                  longitude: longitude,
                                  address: address,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.directions),
                            label: const Text('Get Directions'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await NavigationService.openLocation(
                                  latitude: latitude,
                                  longitude: longitude,
                                  address: address,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.location_on),
                            label: const Text('Open Location'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Implementation Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Implementation Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _DetailSection(
                      title: '✅ Features Implemented',
                      items: [
                        'Interactive OpenStreetMap with WebView',
                        'Dynamic coordinate updates',
                        'Custom markers with popups',
                        'Google Maps navigation integration',
                        'Loading states and error handling',
                        'Cross-platform compatibility',
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _DetailSection(
                      title: '💰 Cost Benefits',
                      items: [
                        'Zero API costs (OpenStreetMap is free)',
                        'No usage limits',
                        'No API keys required',
                        'Privacy-friendly (no tracking)',
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _DetailSection(
                      title: '🎯 Policy Compliance',
                      items: [
                        'Google Maps for navigation only',
                        'OpenStreetMap for display',
                        'Zero Google Maps API billing',
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _DetailSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
