import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  final int? itemsPerPage;
  final int? totalItems;
  final int? currentPage;
  final int? totalPages;

  Meta(
    this.itemsPerPage,
    this.totalItems,
    this.currentPage,
    this.totalPages,
  );

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
