// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      json['id'] as int?,
      json['destination'] as String?,
      json['encoding'] as String?,
      json['fieldname'] as String?,
      json['filename'] as String?,
      json['mimetype'] as String?,
      json['originalname'] as String?,
      json['path'] as String?,
      json['provider'] as String?,
      json['size'] as int?,
      json['pathUrl'] as String?,
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
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
