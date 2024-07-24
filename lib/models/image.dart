import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Images {
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

  Images(
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

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}
