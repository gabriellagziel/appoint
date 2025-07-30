// This screen fetches and paginates content items from Firestore.
import 'package:appoint/providers/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays a paginated list of content items.
class ContentLibraryScreen extends ConsumerStatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  ConsumerState<ContentLibraryScreen> createState() =>
      _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends ConsumerState<ContentLibraryScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      ref.read(contentPagingProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(contentPagingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Library'),
      ),
      body: contentAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No content available yet'));
          }
          return ListView.builder(
            controller: _controller,
            itemCount: items.length,
            itemBuilder: (context, final index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title),
                subtitle:
                    item.description != null ? Text(item.description!) : null,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/content/:id',
                    arguments: item.id,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
