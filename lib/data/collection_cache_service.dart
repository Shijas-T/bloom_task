import 'package:bloom_task/models/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class CollectionCacheService {
  static const String _boxName = 'collections_cache';
  static const String _collectionsKey = 'collections_list';
  late Box _box;

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox(_boxName);
  }

  Future<void> saveCollections(List<Collection> collections) async {
    final data = collections.map((e) => e.toJson()).toList();
    await _box.put(_collectionsKey, data);
  }

  List<Collection>? getCollections() {
    final data = _box.get(_collectionsKey);
    if (data == null) return null;
    try {
      if (data is List) {
        return (data)
            .map(
              (e) => Collection.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      }
      return null;
    } catch (_) {
      return null; // Graceful cache miss handling
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
