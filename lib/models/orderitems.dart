import 'package:banjuipos/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orderitems.g.dart';

@JsonSerializable()
class OrderItems {
  final int? productId;
  final int quantity;
  final double price;  
  final double total;
  final List attributes;
  Product? product;

  OrderItems(
    this.productId,
    this.quantity,
    this.price,
    this.total,
    this.attributes,
    this.product
  );

  factory OrderItems.fromJson(Map<String, dynamic> json) => _$OrderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}
