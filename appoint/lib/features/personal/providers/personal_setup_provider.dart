import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/personal_setup_repository.dart';

final personalSetupRepositoryProvider =
    Provider<PersonalSetupRepository>((ref) {
  return PersonalSetupRepository();
});

final hasCompletedPersonalSetupProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(personalSetupRepositoryProvider);
  return repo.getHasCompleted();
});







