import 'package:json_annotation/json_annotation.dart';

part 'customerbank.g.dart';

@JsonSerializable()
class CustomerBank {
  final int? id;
  final String? accountName;
  final String? accountNumber;
  final String? bank;
  bool select;

  CustomerBank(this.id, this.accountName, this.accountNumber, this.bank,{this.select = false});

  factory CustomerBank.fromJson(Map<String, dynamic> json) => _$CustomerBankFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerBankToJson(this);
}
