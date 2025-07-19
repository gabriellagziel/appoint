import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/map_access_provider.dart';

/// Widget that transparently enforces free-tier Google-Maps limits.
///
/// If the user is allowed to view the map for the given [appointmentId] the
/// underlying [GoogleMap] will be rendered; otherwise a locked placeholder is
/// displayed that encourages the user to upgrade.
class RestrictedGoogleMap extends ConsumerWidget {
  const RestrictedGoogleMap({
    super.key,
    required this.appointmentId,
    required this.initialCameraPosition,
    this.markers = const {},
    this.onMapCreated,
    this.myLocationEnabled = false,
    this.zoomControlsEnabled,
    this.scrollGesturesEnabled,
    this.zoomGesturesEnabled,
    this.rotateGesturesEnabled,
    this.tiltGesturesEnabled,
    this.onTap,
  });

  /// The appointment identifier – used for enforcing the *once per appointment*
  /// constraint. If `null`, no restriction will be applied and the map is
  /// always shown (useful for flows that are not bound to a particular
  /// appointment).
  final String appointmentId;

  // Google-map properties that we forward.
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;
  final ValueChanged<GoogleMapController>? onMapCreated;
  final bool myLocationEnabled;

  // Optional behaviour flags (only the subset required by existing usages).
  final bool? zoomControlsEnabled;
  final bool? scrollGesturesEnabled;
  final bool? zoomGesturesEnabled;
  final bool? rotateGesturesEnabled;
  final bool? tiltGesturesEnabled;
  final void Function(LatLng)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(mapAccessProvider(appointmentId));

    return access.when(
      data: (allowed) {
        if (allowed) {
          return GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            onMapCreated: onMapCreated,
            myLocationEnabled: myLocationEnabled,
            zoomControlsEnabled: zoomControlsEnabled ?? true,
            scrollGesturesEnabled: scrollGesturesEnabled ?? true,
            zoomGesturesEnabled: zoomGesturesEnabled ?? true,
            rotateGesturesEnabled: rotateGesturesEnabled ?? true,
            tiltGesturesEnabled: tiltGesturesEnabled ?? true,
            onTap: onTap,
          );
        }
        return _LockedMapPlaceholder();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _LockedMapPlaceholder(),
    );
  }
}

/// Simple placeholder displayed when the map is locked for free users.
class _LockedMapPlaceholder extends StatelessWidget {
  const _LockedMapPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'Map access is limited to premium users',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the subscription / upgrade screen.
                  // You may have an existing route – adjust as necessary.
                  Navigator.of(context).pushNamed('/subscription');
                },
                child: const Text('Upgrade to Premium'),
              ),
            ],
          ),
        ),
      );
}