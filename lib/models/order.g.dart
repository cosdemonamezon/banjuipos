// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      (json['discount'] as num?)?.toDouble(),
      (json['grandTotal'] as num?)?.toDouble(),
      json['id'] as int,
      json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
      json['orderNo'] as String?,
      json['orderStatus'] as String?,
      (json['total'] as num?)?.toDouble(),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItems.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['licensePlate'] == null
          ? null
          : LicensePlates.fromJson(
              json['licensePlate'] as Map<String, dynamic>),
      json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      (json['orderPayments'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'orderNo': instance.orderNo,
      'orderDate': instance.orderDate?.toIso8601String(),
      'orderStatus': instance.orderStatus,
      'total': instance.total,
      'discount': instance.discount,
      'grandTotal': instance.grandTotal,
      'orderItems': instance.orderItems,
      'user': instance.user,
      'licensePlate': instance.licensePlate,
      'customer': instance.customer,
      'orderPayments': instance.orderPayments,
    };
