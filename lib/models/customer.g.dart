// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      json['id'] as int?,
      json['code'] as String?,
      json['name'] as String?,
      json['address'] as String?,
      json['licensePlate'] as String?,
      json['phoneNumber'] as String?,
      json['tax'] as String?,
      json['identityCard'] == null
          ? null
          : IdentityCard.fromJson(json['identityCard'] as Map<String, dynamic>),
      (json['licensePlates'] as List<dynamic>?)
          ?.map((e) => LicensePlates.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['customerBanks'] as List<dynamic>?)
          ?.map((e) => CustomerBank.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['level'] == null
          ? null
          : Level.fromJson(json['level'] as Map<String, dynamic>),
      json['point_balance'] as int?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'tax': instance.tax,
      'licensePlate': instance.licensePlate,
      'phoneNumber': instance.phoneNumber,
      'identityCard': instance.identityCard,
      'point_balance': instance.point_balance,
      'licensePlates': instance.licensePlates,
      'customerBanks': instance.customerBanks,
      'level': instance.level,
    };
