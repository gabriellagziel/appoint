import 'package:flutter/material.dart';
import '../../../../models/group_invite_link.dart';
import '../../../../services/sharing/share_service.dart';

class ShareTargetButtons extends StatelessWidget {
  final GroupInviteLink link;
  final void Function(String src)? onPlatformTap;
  final void Function()? onCopyLink;

  const ShareTargetButtons({
    super.key,
    required this.link,
    this.onPlatformTap,
    this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    final platforms = ShareService.getSupportedPlatforms();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share to any group:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Copy link button
            _buildPlatformButton(
              context,
              'copy',
              'Copy Link',
              '📋',
              onTap: () {
                onCopyLink?.call();
                ShareService.shareInviteLink(link);
              },
            ),
            // Platform buttons
            ...platforms.map((platform) => _buildPlatformButton(
                  context,
                  platform,
                  ShareService.getPlatformDisplayName(platform),
                  ShareService.getPlatformIcon(platform),
                  onTap: () {
                    onPlatformTap?.call(platform);
                    ShareService.shareInviteLink(link, src: platform);
                  },
                )),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Paste this link into any group chat: WhatsApp, Telegram, iMessage, Messenger, Instagram DMs, Facebook Groups, Discord, Signal.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildPlatformButton(
    BuildContext context,
    String platform,
    String label,
    String icon, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
