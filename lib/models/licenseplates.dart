import 'package:json_annotation/json_annotation.dart';

part 'licenseplates.g.dart';

@JsonSerializable()
class LicensePlates {
  final int? id;
  final String? licensePlate;
  bool select;

  LicensePlates(this.id, this.licensePlate,{this.select = false});

  factory LicensePlates.fromJson(Map<String, dynamic> json) => _$LicensePlatesFromJson(json);

  Map<String, dynamic> toJson() => _$LicensePlatesToJson(this);
}
