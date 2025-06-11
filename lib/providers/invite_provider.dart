import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invite.dart';
import '../services/invite_service.dart';
import 'auth_provider.dart';

final inviteServiceProvider = Provider<InviteService>((ref) => InviteService());

final myInvitesStreamProvider = StreamProvider<List<Invite>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty();
      }
      return ref.read(inviteServiceProvider).watchMyInvites();
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
