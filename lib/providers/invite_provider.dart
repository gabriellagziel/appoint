import 'package:appoint/models/invite.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/invite_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inviteServiceProvider =
    Provider<InviteService>((ref) => InviteService());

myInvitesStreamProvider = StreamProvider<List<Invite>>((final ref) {
  authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty();
      }
      return ref.read(inviteServiceProvider).watchMyInvites();
    },
    loading: () => const Stream.empty(),
    error: (_, final __) => const Stream.empty(),
  );
});
