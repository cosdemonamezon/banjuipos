import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  final int? id;
  final String? fieldname;
  final String? originalname;
  final String? encoding;
  final String? mimetype;
  final String? destination;
  final String? filename;
  final String? path;
  final int? size;
  final String? provider;
  final String? pathUrl;

  Image(
    this.id,
    this.destination,
    this.encoding,
    this.fieldname,
    this.filename,
    this.mimetype,
    this.originalname,
    this.path,
    this.provider,
    this.size,
    this.pathUrl
  );

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
