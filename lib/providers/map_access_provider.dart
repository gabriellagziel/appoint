import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/map_access_service.dart';

/// Riverpod provider that exposes whether the **current user** may view the
/// Google Map for a particular appointment. It will also record the view (and
/// increment counters) when access is granted.
final mapAccessProvider = FutureProvider.family<bool, String>((ref, appointmentId) async {
  final service = MapAccessService();
  return service.canViewAndRecord(appointmentId);
});

/// Usage status provider (no mutations)
final mapUsageStatusProvider = FutureProvider.family<MapUsageStatus, String>((ref, appointmentId) async {
  final service = MapAccessService();
  return service.getUsageStatus(appointmentId);
});