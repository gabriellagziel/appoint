import 'package:flutter/material.dart';
import 'package:appoint/config/theme.dart';

class SectionDivider extends StatelessWidget {
  final String? label;
  const SectionDivider({final Key? key, this.label}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
        ],
        const Divider(color: AppTheme.secondaryColor),
      ],
    );
  }
}
