// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Section _$SectionFromJson(Map<String, dynamic> json) => _Section(
  id: json['id'] as String,
  collectionId: json['collectionId'] as String,
  title: json['title'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  contentCount: (json['contentCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SectionToJson(_Section instance) => <String, dynamic>{
  'id': instance.id,
  'collectionId': instance.collectionId,
  'title': instance.title,
  'order': instance.order,
  'contentCount': instance.contentCount,
};
