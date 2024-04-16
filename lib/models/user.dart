import 'package:banjuipos/models/orderitems.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? username;
  final String? code;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final bool? isActive;

  User(
    this.code,
    this.createdAt,
    this.deletedAt,
    this.firstName,
    this.id,
    this.isActive,
    this.lastName,
    this.phoneNumber,
    this.updatedAt,
    this.username
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
