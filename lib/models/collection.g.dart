// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Collection _$CollectionFromJson(Map<String, dynamic> json) => _Collection(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  coverImageUrl: json['coverImageUrl'] as String,
  creatorId: json['creatorId'] as String,
  isPremium: json['isPremium'] as bool? ?? false,
  sectionCount: (json['sectionCount'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CollectionToJson(_Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'coverImageUrl': instance.coverImageUrl,
      'creatorId': instance.creatorId,
      'isPremium': instance.isPremium,
      'sectionCount': instance.sectionCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
