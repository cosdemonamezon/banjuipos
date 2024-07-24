import 'package:banjuipos/models/category.dart';
import 'package:banjuipos/models/image.dart';
import 'package:banjuipos/models/unit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String? code;
  final String? name;
  final Images? image;
  final double? price;
  double? newWeighQty;
  final Category? category;
  final Unit? unit;
  int? stqty;
  double priceQTY;
  int qty;
  double weighQty;

  Product(
    this.id,
    this.code,
    this.name,
    this.image,
    this.stqty,
    this.category,
    this.unit,    
    this.price,
    this.newWeighQty, {
    this.qty = 1,
    this.priceQTY = 0,
    this.weighQty = 0
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
