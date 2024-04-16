import 'package:json_annotation/json_annotation.dart';

part 'identitycard.g.dart';

@JsonSerializable()
class IdentityCard {
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

  IdentityCard(
    this.id,
    this.fieldname,
    this.originalname,
    this.encoding,
    this.mimetype,
    this.destination,
    this.filename,
    this.path,
    this.pathUrl,
    this.provider,
    this.size
  );

  factory IdentityCard.fromJson(Map<String, dynamic> json) => _$IdentityCardFromJson(json);

  Map<String, dynamic> toJson() => _$IdentityCardToJson(this);
}
