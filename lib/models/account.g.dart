// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['accountName'] as String?,
      json['accountNumber'] as String?,
      json['bank'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'bank': instance.bank,
    };
