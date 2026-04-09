import 'package:bloom_task/data/section_provider.dart';
import 'package:bloom_task/models/section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/collection.dart';

class CollectionDetailBottomSheet extends ConsumerWidget {
  final Collection collection;

  const CollectionDetailBottomSheet({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch sections for THIS collection using the family provider
    final sectionsAsync = ref.watch(sectionsProvider(collection.id));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collection.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${collection.sectionCount} sections • ${collection.isPremium ? 'Premium' : 'Free'}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (collection.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Sections List with Riverpod state handling
          Flexible(
            child: sectionsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    color: Color(0xFF4169E1),
                    strokeWidth: 2,
                  ),
                ),
              ),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Unable to load sections',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              data: (sections) {
                if (sections.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No sections available',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  );
                }
                // Sort by order field for correct display
                final sorted = List<Section>.from(sections)
                  ..sort((a, b) => a.order.compareTo(b.order));

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72, endIndent: 16),
                  itemBuilder: (context, index) {
                    final section = sorted[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        section.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        '${section.contentCount} lessons',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      trailing: const Icon(
                        Icons.play_circle_outline,
                        color: Color(0xFF4169E1),
                        size: 24,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening: ${section.title}'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF4169E1),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
