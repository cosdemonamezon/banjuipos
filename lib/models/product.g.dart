// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['id'] as int,
      json['code'] as String?,
      json['name'] as String?,
      json['image'] == null
          ? null
          : Images.fromJson(json['image'] as Map<String, dynamic>),
      json['stqty'] as int?,
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      (json['price'] as num?)?.toDouble(),
      (json['newWeighQty'] as num?)?.toDouble(),
      qty: json['qty'] as int? ?? 1,
      priceQTY: (json['priceQTY'] as num?)?.toDouble() ?? 0,
      weighQty: (json['weighQty'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'newWeighQty': instance.newWeighQty,
      'category': instance.category,
      'unit': instance.unit,
      'stqty': instance.stqty,
      'priceQTY': instance.priceQTY,
      'qty': instance.qty,
      'weighQty': instance.weighQty,
    };
