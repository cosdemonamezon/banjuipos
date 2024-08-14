import 'package:banjuipos/models/customerbank.dart';
import 'package:banjuipos/models/identitycard.dart';
import 'package:banjuipos/models/level.dart';
import 'package:banjuipos/models/licenseplates.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final int? id;
  final String? code;
  final String? name;
  final String? address;
  final String? tax;
  String? licensePlate;
  final String? phoneNumber;
  final IdentityCard? identityCard;
  final int? point_balance;
  List<LicensePlates>? licensePlates;
  List<CustomerBank>? customerBanks;
  Level? level;

  Customer(
    this.id,
    this.code,
    this.name,
    this.address,
    this.licensePlate,
    this.phoneNumber,
    this.tax,
    this.identityCard,
    this.licensePlates,
    this.customerBanks,
    this.level,
    this.point_balance
  );

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
