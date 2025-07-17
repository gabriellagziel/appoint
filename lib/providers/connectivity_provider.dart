import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/connectivity_service.dart';

/// A stream provider that broadcasts connectivity updates
final connectivityStatusProvider = StreamProvider<ConnectivityResult>((ref) {
  // Ensure the singleton is initialised
  final service = ConnectivityService.instance;
  return service.onStatusChange;
});

/// Derived provider that converts [ConnectivityResult] to a boolean flag.
final isOfflineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider).maybeWhen(
        data: (result) => result,
        orElse: () => ConnectivityResult.none,
      );
  return status == ConnectivityResult.none;
});