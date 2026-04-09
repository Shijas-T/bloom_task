import 'package:bloom_task/models/collection.dart';
import 'package:bloom_task/ui/collection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/collection_provider.dart';
import 'collection_detail_bottom_sheet.dart';

class CollectionListScreen extends ConsumerWidget {
  const CollectionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(collectionListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC), // Soft light gray-blue
      appBar: AppBar(
        title: const Text(
          'Collections',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4169E1)),
            onPressed: () =>
                ref.read(collectionListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(collectionListProvider.notifier).refresh(),
        color: const Color(0xFF4169E1),
        child: collectionsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF4169E1)),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Unable to load collections',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  '$e',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          data: (collections) {
            if (collections.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'No collections yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final collection = collections[index];
                return CollectionCard(
                  collection: collection,
                  onTap: () => _showCollectionDetail(context, collection),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showCollectionDetail(BuildContext context, Collection collection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (context) => CollectionDetailBottomSheet(collection: collection),
    );
  }
}
