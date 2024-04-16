// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myorder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOrder _$MyOrderFromJson(Map<String, dynamic> json) => MyOrder(
      (json['data'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyOrderToJson(MyOrder instance) => <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };
