// Displays a single content item retrieved from Firestore.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/content_provider.dart';

/// Shows details for a single content item.
class ContentDetailScreen extends ConsumerWidget {
  final String contentId;

  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(contentByIdProvider(contentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Content Detail')),
      body: contentAsync.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Content not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imageUrl != null) Image.network(item.imageUrl!),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (item.description != null) Text(item.description!),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
