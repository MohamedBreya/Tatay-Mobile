import 'package:json_annotation/json_annotation.dart';

import 'stop_model.dart';
import 'trip_enums.dart';

part 'trip_model.g.dart';

/// `TripSummary`, plus the optional `TripDetail` fields (null in list responses).
@JsonSerializable(createToJson: false)
class TripModel {
  const TripModel({
    required this.id,
    required this.lineId,
    required this.direction,
    required this.departureAt,
    required this.arrivalPoint,
    required this.stops,
    required this.seatPrice,
    required this.seatCount,
    required this.availableSeats,
    required this.availability,
    required this.minPassengers,
    required this.isConfirmed,
    this.myBookingId,
    this.myWaitlistEntryId,
    this.myWaitlistStatus,
    this.lineName,
    this.vehicleType,
    this.vehiclePlateNumber,
    this.bookingClosesAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => _$TripModelFromJson(json);

  final String id;
  final String lineId;
  @JsonKey(unknownEnumValue: Direction.unknown)
  final Direction direction;
  final DateTime departureAt;
  final String arrivalPoint;
  final List<StopModel> stops;

  /// Piasters.
  final int seatPrice;
  final int seatCount;
  final int availableSeats;
  @JsonKey(unknownEnumValue: Availability.unknown)
  final Availability availability;
  final int minPassengers;
  final bool isConfirmed;
  final String? myBookingId;
  final String? myWaitlistEntryId;
  @JsonKey(unknownEnumValue: WaitlistStatus.unknown)
  final WaitlistStatus? myWaitlistStatus;

  // TripDetail only
  final String? lineName;
  final String? vehicleType;
  final String? vehiclePlateNumber;
  final DateTime? bookingClosesAt;

  /// The passenger is still in the queue or holds an offer.
  bool get hasActiveWaitlist =>
      myWaitlistEntryId != null &&
      (myWaitlistStatus == WaitlistStatus.waiting || myWaitlistStatus == WaitlistStatus.offered);

  List<StopModel> get boardableStops => stops.where((s) => !s.notOperated).toList();
}
