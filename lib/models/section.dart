import 'package:freezed_annotation/freezed_annotation.dart';

part 'section.freezed.dart';
part 'section.g.dart';

@freezed
abstract class Section with _$Section {
  const factory Section({
    required String id,
    required String collectionId,
    required String title,
    @Default(0) int order,
    @Default(0) int contentCount,
  }) = _Section;

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}
