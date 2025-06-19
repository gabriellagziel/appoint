import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';
import 'services/booking_service.dart';
import '../../providers/auth_provider.dart';
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
  bool _isSubmitting = false;
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

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(authProvider).currentUser;
      final userId = user?.uid ?? '';
      if (userId.isEmpty) throw Exception('User not logged in');

      final staffId = ref.read(staffSelectionProvider);
      final serviceId = ref.read(serviceSelectionProvider);
      final serviceName = ref.read(serviceNameProvider);
      final dateTime = ref.read(selectedSlotProvider);
      final duration = ref.read(serviceDurationProvider);

      if (staffId == null ||
          serviceId == null ||
          dateTime == null ||
          duration == null) {
        throw Exception('Missing required booking information');
      }

      final booking = Booking(
        id: '', // Will be set by Firestore
        userId: userId,
        staffId: staffId,
        serviceId: serviceId,
        serviceName: serviceName ?? 'Unknown Service',
        dateTime: dateTime,
        duration: duration,
        notes: null,
        createdAt: DateTime.now(),
      );

      await ref.read(bookingServiceProvider).submitBooking(booking);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed')),
      );
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint('Error during booking: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm booking')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffId = ref.watch(staffSelectionProvider);
    final serviceId = ref.watch(serviceSelectionProvider);
    final dateTime = ref.watch(selectedSlotProvider);
    final duration = ref.watch(serviceDurationProvider);

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
