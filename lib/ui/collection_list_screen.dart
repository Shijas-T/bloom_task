import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/collection_provider.dart';

class CollectionListScreen extends ConsumerWidget {
  const CollectionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(collectionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(collectionListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: collectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (collections) {
          if (collections.isEmpty) {
            return const Center(child: Text('No collections found.'));
          }
          return ListView.builder(
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];
              return ListTile(
                leading: Image.network(
                  collection.coverImageUrl,
                  width: 50,
                  height: 50,
                  errorBuilder: (_, _, _) => const Icon(Icons.image),
                ),
                title: Text(collection.title),
                subtitle: Text(
                  '${collection.sectionCount} sections | ${collection.isPremium ? 'Premium' : 'Free'}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
