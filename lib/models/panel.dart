import 'package:banjuipos/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'panel.g.dart';

@JsonSerializable()
class Panel {
  final int? id;
  final String? name;
  final List<Product>? products;

  Panel(this.id, this.name, this.products);

  factory Panel.fromJson(Map<String, dynamic> json) => _$PanelFromJson(json);

  Map<String, dynamic> toJson() => _$PanelToJson(this);
}
