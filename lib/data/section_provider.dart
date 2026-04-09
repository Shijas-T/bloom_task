import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/section.dart';
import '../data/collection_cache_service.dart';

// Mock Firestore fetch for sections
Future<List<Section>> mockFetchSections(String collectionId) async {
  await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
  return [
    Section(
      id: 's1',
      collectionId: collectionId,
      title: 'Getting Started',
      order: 0,
      contentCount: 3,
    ),
    Section(
      id: 's2',
      collectionId: collectionId,
      title: 'Core Concepts',
      order: 1,
      contentCount: 5,
    ),
    Section(
      id: 's3',
      collectionId: collectionId,
      title: 'Advanced Patterns',
      order: 2,
      contentCount: 4,
    ),
  ];
}

class SectionsNotifier extends FamilyAsyncNotifier<List<Section>, String> {
  late final CollectionCacheService _cache;
  late String _collectionId;

  @override
  Future<List<Section>> build(String collectionId) async {
    _collectionId = collectionId;
    _cache = CollectionCacheService();
    await _cache.init();

    // 1. Emit cached sections immediately if available
    final cached = await _cache.getSections(collectionId);
    if (cached != null) {
      state = AsyncData(cached);
    } else {
      state = const AsyncLoading();
    }

    // 2. Background refresh
    unawaited(_fetchAndCache());
    return cached ?? [];
  }

  Future<void> _fetchAndCache() async {
    try {
      final freshData = await mockFetchSections(_collectionId);
      await _cache.saveSections(_collectionId, freshData);
      state = AsyncData(freshData);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // 3. Public refresh method
  Future<void> refresh() async {
    state = const AsyncLoading();
    await _fetchAndCache();
  }
}

// Family provider: one instance per collectionId
final sectionsProvider =
    AsyncNotifierProvider.family<SectionsNotifier, List<Section>, String>(
      SectionsNotifier.new,
    );
