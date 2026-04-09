import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

@freezed
abstract class Collection with _$Collection {
  const factory Collection({
    required String id,
    required String title,
    required String description,
    required String coverImageUrl,
    required String creatorId,
    @Default(false) bool isPremium,
    @Default(0) int sectionCount,
    required DateTime createdAt,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}
