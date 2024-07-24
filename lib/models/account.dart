import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final String? accountName;
  final String? accountNumber;
  final String? bank;

  Account(
    this.accountName,
    this.accountNumber,
    this.bank,
  );

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
