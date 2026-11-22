import 'package:json_annotation/json_annotation.dart';

import 'trip_enums.dart';

part 'trip_ref_model.g.dart';

/// The short trip shape embedded in bookings and waitlist entries.
@JsonSerializable(createToJson: false)
class TripRefModel {
  const TripRefModel({
    required this.id,
    required this.direction,
    required this.departureAt,
    required this.arrivalPoint,
    required this.status,
    this.vehiclePlateNumber,
  });

  factory TripRefModel.fromJson(Map<String, dynamic> json) => _$TripRefModelFromJson(json);

  final String id;
  @JsonKey(unknownEnumValue: Direction.unknown)
  final Direction direction;
  final DateTime departureAt;
  final String arrivalPoint;
  @JsonKey(unknownEnumValue: TripStatus.unknown)
  final TripStatus status;
  final String? vehiclePlateNumber;
}
