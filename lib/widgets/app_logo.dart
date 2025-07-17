import 'package:flutter/material.dart';
import 'dart:math';

/// APP-OINT Logo Widget
/// Displays the official APP-OINT logo with customizable size and styling
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 64,
    this.showText = true,
    this.textStyle,
    this.logoOnly = false,
  });

  final double size;
  final bool showText;
  final TextStyle? textStyle;
  final bool logoOnly;

  @override
  Widget build(BuildContext context) {
    if (logoOnly) {
      return _buildLogoOnly();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogoOnly(),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'APP-OINT',
            style: textStyle ?? 
              TextStyle(
                fontSize: size * 0.3,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
          ),
          const SizedBox(height: 4),
          Text(
            'Time Organized',
            style: textStyle?.copyWith(fontSize: size * 0.15) ??
              TextStyle(
                fontSize: size * 0.15,
                color: Colors.grey[600],
              ),
          ),
          Text(
            'Set SendDone',
            style: textStyle?.copyWith(fontSize: size * 0.15) ??
              TextStyle(
                fontSize: size * 0.15,
                color: Colors.grey[600],
              ),
          ),
        ],
      ],
    );
  }

  Widget _buildLogoOnly() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: AppLogoPainter(),
        size: Size(size, size),
      ),
    );
  }
}

/// Custom painter for the APP-OINT logo
class AppLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw 8tylized figures in a circle
    final colors = [
      const Color(0xFFFF8C00), // Orange
      const Color(0xFFFFB366), // Peach
      const Color(0xFF20B2AA), // Teal
      const Color(0xFF8A2BE2), // Purple
      const Color(0xFF4B0082), // Dark Purple
      const Color(0xFF4169E1), // Blue
      const Color(0xFF32CD32), // Green
      const Color(0xFFFFD700), // Yellow
    ];

    for (int i = 0; i < 8; i++) {
      final angle = i * (2 * pi / 8);
      final figureCenter = Offset(
        center.dx + (radius * cos(angle)),
        center.dy + (radius * sin(angle)),
      );

      _drawFigure(canvas, figureCenter, radius * 0.15, colors[i]);
    }

    // Draw center connection point
    final centerPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.05, centerPaint);
  }

  void _drawFigure(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw a simple stylized figure (inverted V shape)
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx - size * 0.5, center.dy + size * 0.3);
    path.lineTo(center.dx + size * 0.5, center.dy + size * 0.3);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}