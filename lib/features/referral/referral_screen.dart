import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/referral_provider.dart';
import 'share_invite_widget.dart';

/// Simple screen that displays a referral link using [ShareInviteWidget].
class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final referralLinkAsync = ref.watch(referralLinkProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Referral')),
      body: Center(
        child: referralLinkAsync.when(
          data: (link) {
            if (link == null) {
              return Text(l10n.errorLoadingInvites);
            }
            return ShareInviteWidget(referralLink: link);
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => Text(l10n.errorLoadingInvites),
        ),
      ),
    );
  }
}
