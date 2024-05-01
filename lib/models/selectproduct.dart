import 'package:banjuipos/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selectproduct.g.dart';

@JsonSerializable()
class SelectProduct {
  Product product;
  double qty;
  double newQty;
  String? sumText;
  String? downText;


  SelectProduct(
    this.product,
    this.sumText,
    this.downText,
    {this.qty = 0, this.newQty = 0}
  );

  factory SelectProduct.fromJson(Map<String, dynamic> json) => _$SelectProductFromJson(json);

  Map<String, dynamic> toJson() => _$SelectProductToJson(this);
}
