// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selectproduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectProduct _$SelectProductFromJson(Map<String, dynamic> json) =>
    SelectProduct(
      Product.fromJson(json['product'] as Map<String, dynamic>),
      json['sumText'] as String?,
      json['downText'] as String?,
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      newQty: (json['newQty'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$SelectProductToJson(SelectProduct instance) =>
    <String, dynamic>{
      'product': instance.product,
      'qty': instance.qty,
      'newQty': instance.newQty,
      'sumText': instance.sumText,
      'downText': instance.downText,
    };
