import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/remote_config_service.dart';

// Remote Config Provider
final remoteConfigProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService();
});

// Feature flag providers
final familyUiEnabledProvider = Provider<bool>((ref) {
  final remoteConfig = ref.watch(remoteConfigProvider);
  return remoteConfig.isFamilyUiEnabled;
});

final familyCalendarEnabledProvider = Provider<bool>((ref) {
  final remoteConfig = ref.watch(remoteConfigProvider);
  return remoteConfig.isFamilyCalendarEnabled;
});

final REDACTED_TOKEN = Provider<bool>((ref) {
  final remoteConfig = ref.watch(remoteConfigProvider);
  return remoteConfig.REDACTED_TOKEN;
});

// Combined family features provider
final REDACTED_TOKEN = Provider<bool>((ref) {
  final remoteConfig = ref.watch(remoteConfigProvider);
  return remoteConfig.areFamilyFeaturesEnabled;
});

// Remote Config refresh provider
final remoteConfigRefreshProvider = FutureProvider<void>((ref) async {
  final remoteConfig = ref.read(remoteConfigProvider);
  await remoteConfig.forceRefresh();
});
