import 'package:json_annotation/json_annotation.dart';

part 'branch.g.dart';

@JsonSerializable()
class Branch {
  final int? id;
  final String? code;
  final String? name;
  final String? address;

  Branch(
    this.id,
    this.code,
    this.name,
    this.address
  );

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

  Map<String, dynamic> toJson() => _$BranchToJson(this);
}
