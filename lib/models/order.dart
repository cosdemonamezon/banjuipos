import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/licenseplates.dart';
import 'package:banjuipos/models/orderitems.dart';
import 'package:banjuipos/models/payment.dart';
import 'package:banjuipos/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? orderNo;
  final DateTime? orderDate;
  final String? orderStatus;
  final double? total;
  final double? discount;
  final double? grandTotal;
  List<OrderItems>? orderItems;
  User? user;
  LicensePlates? licensePlate;
  Customer? customer;
  Payment? paymentMethod;

  Order(
    this.createdAt,
    this.deletedAt,
    this.discount,
    this.grandTotal,
    this.id,
    this.orderDate,
    this.orderNo,
    this.orderStatus,
    this.total,
    this.updatedAt,
    this.orderItems,
    this.user,
    this.licensePlate,
    this.customer,
    this.paymentMethod
  );

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
