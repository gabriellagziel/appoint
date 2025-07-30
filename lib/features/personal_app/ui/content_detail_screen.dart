import 'package:flutter/material.dart';
import '../../../utils/localized_date_formatter.dart';

/// TODO: Implement detailed content view
class ContentDetailScreen extends StatelessWidget {
  final String contentId;

  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: const Text('Content Detail')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Content ID: $contentId'),
            const SizedBox(height: 8),
            Text(
              LocalizedDateFormatter.formatFullDate(
                DateTime.now(),
                locale: locale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
