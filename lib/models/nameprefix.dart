import 'package:json_annotation/json_annotation.dart';

part 'nameprefix.g.dart';

@JsonSerializable()
class NamePrefix {
  final int? id;
  final String? name;

  NamePrefix(
    this.id,
    this.name,
  );

  factory NamePrefix.fromJson(Map<String, dynamic> json) => _$NamePrefixFromJson(json);

  Map<String, dynamic> toJson() => _$NamePrefixToJson(this);
}
