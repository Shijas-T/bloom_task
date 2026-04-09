import 'package:bloom_task/models/collection.dart';
import 'package:flutter/material.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback onTap;

  const CollectionCard({
    super.key,
    required this.collection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Modern soft shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          splashColor: const Color(0xFF6366F1).withOpacity(0.05),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildCoverImage(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row with Title and Badge
                      Text(
                        collection.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B), // Slate-800
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              collection.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (collection.isPremium) _buildPremiumTag(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          collection.coverImageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPremiumTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF), // Indigo-50
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'PREMIUM',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Color(0xFF4F46E5), // Indigo-600
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Using a custom "Capsule" for the count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Icon(
                Icons.layers_outlined,
                size: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 6),
              Text(
                '${collection.sectionCount} Sections',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Color(0xFFCBD5E1),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() => Container(
    width: 80,
    height: 80,
    color: const Color(0xFFF1F5F9),
    child: const Icon(Icons.image_outlined, color: Color(0xFF94A3B8)),
  );
}
