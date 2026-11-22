import 'package:json_annotation/json_annotation.dart';

import '../../../trips/data/models/stop_model.dart';
import '../../../trips/data/models/trip_enums.dart';
import '../../../trips/data/models/trip_ref_model.dart';

part 'waitlist_entry_model.g.dart';

@JsonSerializable(createToJson: false)
class WaitlistEntryModel {
  const WaitlistEntryModel({
    required this.id,
    required this.trip,
    required this.stop,
    required this.seats,
    required this.status,
    required this.joinedAt,
    this.position,
    this.offeredAt,
    this.offerExpiresAt,
    this.offerSecondsLeft,
    this.offerAmount,
    this.bookingId,
  });

  factory WaitlistEntryModel.fromJson(Map<String, dynamic> json) => _$WaitlistEntryModelFromJson(json);

  final String id;
  final TripRefModel trip;
  final StopModel stop;
  final int seats;
  @JsonKey(unknownEnumValue: WaitlistStatus.unknown)
  final WaitlistStatus status;
  final DateTime joinedAt;

  /// 1-based among `waiting` entries.
  final int? position;
  final DateTime? offeredAt;
  final DateTime? offerExpiresAt;
  final int? offerSecondsLeft;
  final int? offerAmount;
  final String? bookingId;

  bool get isActive => status == WaitlistStatus.waiting || status == WaitlistStatus.offered;
}
