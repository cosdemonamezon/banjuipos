// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customerbank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerBank _$CustomerBankFromJson(Map<String, dynamic> json) => CustomerBank(
      json['id'] as int?,
      json['accountName'] as String?,
      json['accountNumber'] as String?,
      json['bank'] as String?,
      select: json['select'] as bool? ?? false,
    );

Map<String, dynamic> _$CustomerBankToJson(CustomerBank instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'bank': instance.bank,
      'select': instance.select,
    };
