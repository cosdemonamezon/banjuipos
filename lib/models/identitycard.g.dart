// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identitycard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityCard _$IdentityCardFromJson(Map<String, dynamic> json) => IdentityCard(
      json['id'] as int?,
      json['fieldname'] as String?,
      json['originalname'] as String?,
      json['encoding'] as String?,
      json['mimetype'] as String?,
      json['destination'] as String?,
      json['filename'] as String?,
      json['path'] as String?,
      json['pathUrl'] as String?,
      json['provider'] as String?,
      json['size'] as int?,
    );

Map<String, dynamic> _$IdentityCardToJson(IdentityCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fieldname': instance.fieldname,
      'originalname': instance.originalname,
      'encoding': instance.encoding,
      'mimetype': instance.mimetype,
      'destination': instance.destination,
      'filename': instance.filename,
      'path': instance.path,
      'size': instance.size,
      'provider': instance.provider,
      'pathUrl': instance.pathUrl,
    };
