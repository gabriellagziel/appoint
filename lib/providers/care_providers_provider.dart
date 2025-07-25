import 'package:appoint/models/care_provider.dart';
import 'package:appoint/services/care_provider_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final careProviderServiceProvider =
    Provider<CareProviderService>((ref) => CareProviderService());

class CareProvidersNotifier
    extends StateNotifier<AsyncValue<List<CareProvider>>> {
  CareProvidersNotifier(this._service) : super(const AsyncValue.loading()) {
    load();
  }
  final CareProviderService _service;

  Future<void> load() async {
    try {
      final data = await _service.fetchProviders();
      final state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> add(CareProvider provider) async {
    await _service.addProvider(provider);
    await load();
  }

  Future<void> update(CareProvider provider) async {
    await _service.updateProvider(provider);
    await load();
  }

  Future<void> delete(String id) async {
    await _service.deleteProvider(id);
    await load();
  }
}

final careProvidersProvider = StateNotifierProvider<CareProvidersNotifier,
    AsyncValue<List<CareProvider>>>(
  (ref) => CareProvidersNotifier(ref.read(careProviderServiceProvider)),
);
