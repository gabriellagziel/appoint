import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/map_access_provider.dart';
import '../services/map_access_service.dart';

/// Widget that transparently enforces free-tier Google-Maps limits.
///
/// It shows:
///   • A warning modal when the user is *about* to consume one of their 5 free
///     views (with the option to upgrade).
///   • A locked modal when the limit has been reached or the appointment has
///     already been viewed.
///   • For premium users the map renders normally with no prompts.
class RestrictedGoogleMap extends ConsumerStatefulWidget {
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
  ConsumerState<RestrictedGoogleMap> createState() => _RestrictedGoogleMapState();
}

class _RestrictedGoogleMapState extends ConsumerState<RestrictedGoogleMap> {
  bool _allowed = false;
  bool _dialogHandled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkUsage();
  }

  Future<void> _checkUsage() async {
    final usageAsync = ref.watch(mapUsageStatusProvider(widget.appointmentId));

    usageAsync.whenData((usage) async {
      if (usage.isPremium) {
        setState(() => _allowed = true);
        return;
      }

      if (_dialogHandled) return; // Already handled in this lifecycle.

      if (usage.alreadyViewed || usage.currentCount >= usage.limit) {
        _dialogHandled = true;
        await _showLockedDialog();
        // Map remains locked.
      } else {
        _dialogHandled = true;
        await _showWarningDialog(usage.currentCount + 1, usage.limit);
      }
    });
  }

  Future<void> _showWarningDialog(int nextCount, int limit) async {
    // Localization will be inserted via l10n in a follow-up – currently using hard-coded fallback.
    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Continue Using Maps?'), // TODO: localize
        content: Text('You\'ve used free access for ${nextCount - 1} of 5 meetings.\nTo keep using Google Maps after this, you\'ll need to upgrade to Premium.'), // TODO: localize
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Upgrade to Premium'), // TODO: localize
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Continue (Meeting $nextCount/$limit)'), // TODO: localize
          ),
        ],
      ),
    );

    if (proceed == true) {
      // Record view and update allowed flag.
      final success = await ref.read(mapAccessProvider(widget.appointmentId).future);
      setState(() => _allowed = success);
    } else {
      // Navigate to upgrade screen
      if (mounted) Navigator.of(context).pushNamed('/subscription');
    }
  }

  Future<void> _showLockedDialog() async {
    // Localization placeholder
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Map Access Locked'), // TODO: localize
        content: const Text('You\'ve reached your limit of 5 meetings with free map access.\nUpgrade now to continue using Google Maps.'), // TODO: localize
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed('/subscription');
            },
            child: const Text('Upgrade to Premium'), // TODO: localize
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Back to meeting'), // TODO: localize
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_allowed) {
      return GoogleMap(
        initialCameraPosition: widget.initialCameraPosition,
        markers: widget.markers,
        onMapCreated: widget.onMapCreated,
        myLocationEnabled: widget.myLocationEnabled,
        zoomControlsEnabled: widget.zoomControlsEnabled ?? true,
        scrollGesturesEnabled: widget.scrollGesturesEnabled ?? true,
        zoomGesturesEnabled: widget.zoomGesturesEnabled ?? true,
        rotateGesturesEnabled: widget.rotateGesturesEnabled ?? true,
        tiltGesturesEnabled: widget.tiltGesturesEnabled ?? true,
        onTap: widget.onTap,
      );
    }
    return const _LockedMapPlaceholder();
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
              // Hardcoded fallback; ideally localization should cover.
              const Text('Map access is limited to premium users', textAlign: TextAlign.center),
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