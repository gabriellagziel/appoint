import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../selection/providers/selection_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/maps_service.dart';
import '../../services/location_service.dart';
import '../../providers/branch_provider.dart';

class BookingRequestScreen extends ConsumerStatefulWidget {
  const BookingRequestScreen({super.key});

  @override
  ConsumerState<BookingRequestScreen> createState() =>
      _BookingRequestScreenState();
}

class _BookingRequestScreenState extends ConsumerState<BookingRequestScreen> {
  late GoogleMapController _mapController;
  final LocationService _locationService = LocationService();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final branches = await ref.read(branchesProvider.future);
    setState(() {
      _markers = branches
          .map((b) => Marker(
                markerId: MarkerId(b.id),
                position: LatLng(b.latitude, b.longitude),
                infoWindow: InfoWindow(title: b.name),
              ))
          .toSet();
    });

    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      _mapController.moveCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
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
      body: GoogleMap(
        initialCameraPosition: MapsService.initialPosition,
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
      ),
    );
  }
}
