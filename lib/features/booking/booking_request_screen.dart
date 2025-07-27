import 'dart:core' show DateTime, Duration;

import 'package:appoint/features/selection/providers/selection_provider.dart';
import 'package:appoint/providers/branch_provider.dart';
import 'package:appoint/services/location_service.dart';
import 'package:appoint/services/maps_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingRequestScreen extends ConsumerStatefulWidget {
  const BookingRequestScreen({super.key});

  @override
  ConsumerState<BookingRequestScreen> createState() =>
      _BookingRequestScreenState();
}

class _BookingRequestScreenState extends ConsumerState<BookingRequestScreen> {
  GoogleMapController? _mapController;
  LocationService _locationService = LocationService();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    try {
      final branches = await ref.read(branchesProvider.future);
      setState(() {
        _markers = branches
            .map((b) => Marker(
                  markerId: MarkerId(b.id),
                  position: LatLng(b.latitude, b.longitude),
                  infoWindow: InfoWindow(title: b.name),
                ),)
            .toSet();
      });

      if (!kIsWeb) {
        final position = await _locationService.getCurrentLocation();
        if (position != null && _mapController != null) {
          _mapController!.moveCamera(CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),),);
        }
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error loading initial data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(staffSelectionProvider);
    ref.watch(serviceSelectionProvider);
    ref.watch(selectedSlotProvider);
    ref.watch(serviceDurationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: kIsWeb ? _buildWebFallback() : _buildMap(),
    );
  }

  Widget _buildMap() => GoogleMap(
      initialCameraPosition: MapsService.initialPosition,
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
    );

  Widget _buildWebFallback() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Map selection is not available on web',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please use the mobile app for location selection',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
}
