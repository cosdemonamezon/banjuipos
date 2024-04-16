// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'licenseplates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicensePlates _$LicensePlatesFromJson(Map<String, dynamic> json) =>
    LicensePlates(
      json['id'] as int?,
      json['licensePlate'] as String?,
      select: json['select'] as bool? ?? false,
    );

Map<String, dynamic> _$LicensePlatesToJson(LicensePlates instance) =>
    <String, dynamic>{
      'id': instance.id,
      'licensePlate': instance.licensePlate,
      'select': instance.select,
    };
