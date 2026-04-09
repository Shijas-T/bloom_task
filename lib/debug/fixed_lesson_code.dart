import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// dummy classes for the task
class LessonModel {
  final String id;
  LessonModel({required this.id});
  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      LessonModel(id: json['id']);
  Map<String, dynamic> toJson() => {'id': id};
}

class LessonCacheService {
  Future<void> init() async {
    /* see fixes */
  }
  Future<void> saveLesson(LessonModel l) async {}
  Future<LessonModel?> getLesson(String id) async => null;
  Future<void> clearAll() async {}
}

class LessonFirestoreService {
  Future<List<LessonModel>> fetchLessons() async => [];
}

class ImageCacheService {
  Future<String?> resolveThumbnail(String id) async => null;
}

class LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final String? thumbnail;
  const LessonTile({super.key, required this.lesson, this.thumbnail});
  @override
  Widget build(BuildContext context) => const SizedBox();
}

// --- FIXED CODE ---

class LessonCacheServiceFixed {
  late Box _box;

  Future<void> init() async {
    // FIX 1: Changed to getApplicationSupportDirectory() as required.
    // CONSEQUENCE: Using getApplicationDocumentsDirectory() violates iOS backup guidelines
    // and can lead to unexpected cache clearing. The support directory is intended for non-user-facing app data.
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox('lessons');
  }

  Future<void> saveLesson(LessonModel lesson) async {
    await _box.put(lesson.id, lesson.toJson());
  }

  Future<LessonModel?> getLesson(String id) async {
    final data = _box.get(id);
    // FIX 2: Added null check and safe type casting.
    // CONSEQUENCE: Without this, a cache miss returns null, and calling fromJson(null)
    // throws a runtime NoSuchMethodError or TypeError, crashing the app.
    if (data == null) return null;
    return LessonModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}

class LessonNotifierFixed extends AsyncNotifier<List<LessonModel>> {
  @override
  Future<List<LessonModel>> build() async {
    final cache = LessonCacheServiceFixed();
    await cache.init();
    return _fetchAndCache(cache);
  }

  Future<List<LessonModel>> _fetchAndCache(
    LessonCacheServiceFixed cache,
  ) async {
    final lessons = await LessonFirestoreService().fetchLessons();
    if (lessons.isNotEmpty) {
      await cache.saveLesson(lessons.first);
    }
    return lessons;
  }
}

// FIX 3: Wrapped FutureBuilder in a separate StatefulWidget to prevent redundant calls.
// CONSEQUENCE: Creating a new Future inside ListView.builder's itemBuilder causes it to
// execute on every widget rebuild (e.g., during scrolling). This triggers repeated network/cache
// calls, causing severe jank, memory leaks, and wasted bandwidth.
class LessonListWidgetFixed extends StatelessWidget {
  const LessonListWidgetFixed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final lessonsAsync = ref.watch(
          AsyncNotifierProvider<LessonNotifierFixed, List<LessonModel>>(
            LessonNotifierFixed.new,
          ),
        );
        return lessonsAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (lessons) {
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return _ThumbnailLoader(lesson: lesson);
              },
            );
          },
        );
      },
    );
  }
}

class _ThumbnailLoader extends StatefulWidget {
  final LessonModel lesson;
  const _ThumbnailLoader({required this.lesson});

  @override
  State<_ThumbnailLoader> createState() => _ThumbnailLoaderState();
}

class _ThumbnailLoaderState extends State<_ThumbnailLoader> {
  late final Future<String?> _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    // Future is created once in initState, preventing rebuild loops
    _thumbnailFuture = ImageCacheService().resolveThumbnail(widget.lesson.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        return LessonTile(lesson: widget.lesson, thumbnail: snapshot.data);
      },
    );
  }
}

void listenToLessonsFixed(String courseId) {
  FirebaseFirestore.instance
      .collection('lessons')
      .where('courseId', isEqualTo: courseId)
      .snapshots()
      .listen((snapshot) {
        final lessons = snapshot.docs.map((doc) {
          final data = doc.data();
          // FIX 4: Created a mutable copy of the Firestore map before modifying.
          // CONSEQUENCE: Firestore's doc.data() returns an unmodifiable map in modern SDKs.
          // Direct assignment throws an UnsupportedError (UnmodifiableMapException) at runtime.
          final mutableData = Map<String, dynamic>.from(data);
          mutableData['id'] = doc.id;
          return LessonModel.fromJson(mutableData);
        }).toList();
        print(lessons);
      });
}
