import 'package:json_annotation/json_annotation.dart';

part 'unit.g.dart';

@JsonSerializable()
class Unit {
  final int? id;
  final String? code;
  final String? name;

  Unit(
    this.id,
    this.code,
    this.name,
  );

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}
