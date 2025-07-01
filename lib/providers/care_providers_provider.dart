import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/care_provider.dart';
import 'package:appoint/services/care_provider_service.dart';

final careProviderServiceProvider =
    Provider<CareProviderService>((final ref) => CareProviderService());

class CareProvidersNotifier
    extends StateNotifier<AsyncValue<List<CareProvider>>> {
  final CareProviderService _service;
  CareProvidersNotifier(this._service) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final data = await _service.fetchProviders();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(final CareProvider provider) async {
    await _service.addProvider(provider);
    await load();
  }

  Future<void> update(final CareProvider provider) async {
    await _service.updateProvider(provider);
    await load();
  }

  Future<void> delete(final String id) async {
    await _service.deleteProvider(id);
    await load();
  }
}

final careProvidersProvider = StateNotifierProvider<CareProvidersNotifier,
    AsyncValue<List<CareProvider>>>(
  (final ref) => CareProvidersNotifier(ref.read(careProviderServiceProvider)),
);
