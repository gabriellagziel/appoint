import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Widget that displays a simple QR-style placeholder and allows
/// sharing the referral link using share_plus.
class ShareInviteWidget extends StatelessWidget {
  final String referralLink;
  const ShareInviteWidget({super.key, required this.referralLink});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: CustomPaint(
            painter: _SimpleQrPainter(referralLink),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => Share.share(referralLink),
          icon: const Icon(Icons.share),
          label: const Text('Share'),
        ),
      ],
    );
  }
}

/// Very small placeholder QR painter based on hashing the data.
class _SimpleQrPainter extends CustomPainter {
  final String data;
  _SimpleQrPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    const modules = 21;
    final moduleSize = size.width / modules;
    final paint = Paint()..color = Colors.black;
    final hash = data.codeUnits.fold<int>(0, (p, c) => p + c);
    for (var x = 0; x < modules; x++) {
      for (var y = 0; y < modules; y++) {
        final index = x * modules + y;
        if (((hash >> (index % 32)) & 1) == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
                x * moduleSize, y * moduleSize, moduleSize, moduleSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
