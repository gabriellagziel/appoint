import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SectionDivider extends StatelessWidget {
  final String? label;
  const SectionDivider({Key? key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Divider(color: AppTheme.secondaryColor),
      ],
    );
  }
}
