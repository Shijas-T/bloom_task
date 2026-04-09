import 'dart:async';
import 'package:bloom_task/models/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'collection_cache_service.dart';

// Mock Firestore fetch
Future<List<Collection>> mockFetchCollections() async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    Collection(
      id: '1',
      title: 'Flutter Fundamentals',
      description: 'Core concepts',
      coverImageUrl: 'https://picsum.photos/seed/dart/400/200',
      creatorId: 'c1',
      isPremium: false,
      sectionCount: 4,
      createdAt: DateTime(2024, 1, 15),
    ),
    Collection(
      id: '2',
      title: 'Advanced State Management',
      description: 'Riverpod & BLoC',
      coverImageUrl: 'https://picsum.photos/seed/flutter/400/200',
      creatorId: 'c1',
      isPremium: true,
      sectionCount: 6,
      createdAt: DateTime(2024, 2, 20),
    ),
  ];
}

class CollectionListNotifier extends AsyncNotifier<List<Collection>> {
  late final CollectionCacheService _cache;

  @override
  Future<List<Collection>> build() async {
    _cache = CollectionCacheService();
    await _cache.init();

    // 1. Emit cached data immediately if available
    final cached = _cache.getCollections();
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
      final freshData = await mockFetchCollections();
      await _cache.saveCollections(freshData);
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

final collectionListProvider =
    AsyncNotifierProvider<CollectionListNotifier, List<Collection>>(
      CollectionListNotifier.new,
    );
