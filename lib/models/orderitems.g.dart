// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderitems.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItems _$OrderItemsFromJson(Map<String, dynamic> json) => OrderItems(
      json['productId'] as int?,
      json['quantity'] as int,
      (json['price'] as num).toDouble(),
      (json['total'] as num).toDouble(),
      json['attributes'] as List<dynamic>,
      json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      json['dequantity'] as int,
    );

Map<String, dynamic> _$OrderItemsToJson(OrderItems instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'dequantity': instance.dequantity,
      'price': instance.price,
      'total': instance.total,
      'attributes': instance.attributes,
      'product': instance.product,
    };
