import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/invite.dart';
import 'package:appoint/services/invite_service.dart';
import 'package:appoint/providers/auth_provider.dart';

final inviteServiceProvider = Provider<InviteService>((final ref) => InviteService());

final myInvitesStreamProvider = StreamProvider<List<Invite>>((final ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (final user) {
      if (user == null) {
        return const Stream.empty();
      }
      return ref.read(inviteServiceProvider).watchMyInvites();
    },
    loading: () => const Stream.empty(),
    error: (final _, final __) => const Stream.empty(),
  );
});
