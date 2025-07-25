import 'package:flutter/material.dart';
import 'package:appoint/constants/app_branding.dart';
import 'package:appoint/widgets/app_logo.dart';

/// Attribution widget that must appear on all business-branded screens
/// Displays "Powered by App-Oint" as required by branding guidelines
class AppAttribution extends StatelessWidget {
  const AppAttribution({
    super.key,
    this.size = AttributionSize.normal,
    this.alignment = Alignment.center,
    this.showLogo = true,
    this.textColor,
    this.backgroundColor,
  });

  final AttributionSize size;
  final Alignment alignment;
  final bool showLogo;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextColor = textColor ?? Colors.grey[600];
    final logoSize = _getLogoSize();
    final fontSize = _getFontSize();

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo) ...[
          AppLogo(size: logoSize, logoOnly: true),
          SizedBox(width: _getSpacing()),
        ],
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Powered by',
              style: TextStyle(
                fontSize: fontSize * 0.8,
                color: effectiveTextColor?.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'APP-OINT',
              style: TextStyle(
                fontSize: fontSize,
                color: effectiveTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );

    if (backgroundColor != null) {
      content = Container(
        padding: EdgeInsets.all(_getPadding()),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: content,
      );
    }

    return Align(
      alignment: alignment,
      child: content,
    );
  }

  double _getLogoSize() {
    switch (size) {
      case AttributionSize.small:
        return 16;
      case AttributionSize.normal:
        return 20;
      case AttributionSize.large:
        return 24;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AttributionSize.small:
        return 10;
      case AttributionSize.normal:
        return 12;
      case AttributionSize.large:
        return 14;
    }
  }

  double _getSpacing() {
    switch (size) {
      case AttributionSize.small:
        return 4;
      case AttributionSize.normal:
        return 6;
      case AttributionSize.large:
        return 8;
    }
  }

  double _getPadding() {
    switch (size) {
      case AttributionSize.small:
        return 4;
      case AttributionSize.normal:
        return 6;
      case AttributionSize.large:
        return 8;
    }
  }
}

/// Compact horizontal attribution for tight spaces
class AppAttributionCompact extends StatelessWidget {
  const AppAttributionCompact({
    super.key,
    this.textColor,
  });

  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? Colors.grey[600];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(size: 12, logoOnly: true),
        const SizedBox(width: 4),
        Text(
          'Powered by APP-OINT',
          style: TextStyle(
            fontSize: 10,
            color: effectiveTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Footer attribution for full-width layouts
class AppAttributionFooter extends StatelessWidget {
  const AppAttributionFooter({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.showBorder = true,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? Colors.grey[50];
    final effectiveTextColor = textColor ?? Colors.grey[600];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: showBorder
            ? Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              )
            : null,
      ),
      child: AppAttribution(
        size: AttributionSize.normal,
        alignment: Alignment.center,
        textColor: effectiveTextColor,
      ),
    );
  }
}

/// Attribution sizes
enum AttributionSize {
  small,
  normal,
  large,
}