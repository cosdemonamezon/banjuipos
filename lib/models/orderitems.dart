import 'package:banjuipos/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orderitems.g.dart';

@JsonSerializable()
class OrderItems {
  final int? productId;
  final int? quantity;
  int? dequantity;
  final double? price;  
  final double? total;
  final List? attributes;
  final String? uptext;
  final String? downtext;
  Product? product;

  OrderItems(
    this.productId,
    this.quantity,
    this.price,
    this.total,
    this.attributes,
    this.product,
    this.dequantity,
    this.downtext,
    this.uptext
  );

  factory OrderItems.fromJson(Map<String, dynamic> json) => _$OrderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}
