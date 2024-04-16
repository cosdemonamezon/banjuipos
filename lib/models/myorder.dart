import 'package:banjuipos/models/meta.dart';
import 'package:banjuipos/models/order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'myorder.g.dart';

@JsonSerializable()
class MyOrder {
  final List<Order>? data;
  final Meta? meta;

  MyOrder(
    this.data,
    this.meta,
  );

  factory MyOrder.fromJson(Map<String, dynamic> json) => _$MyOrderFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrderToJson(this);
}
