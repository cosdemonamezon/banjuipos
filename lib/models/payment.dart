import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final int? id;
  final String? name;
  final String? icon;
  final String? type;
  bool select;

  Payment(
    this.id,
    this.name,
    this.icon,
    this.type,
    {this.select = false}
  );

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
