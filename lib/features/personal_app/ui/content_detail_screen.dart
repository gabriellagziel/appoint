// Displays a single content item retrieved from Firestore.
// import 'package:appoint/providers/content_provider.dart'; // Unused
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows details for a single content item.
class ContentDetailScreen extends ConsumerWidget {

  const ContentDetailScreen({required this.contentId, super.key});
  final String contentId;

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    contentAsync = ref.watch(contentByIdProvider(contentId));

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
        error: (e, final _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
