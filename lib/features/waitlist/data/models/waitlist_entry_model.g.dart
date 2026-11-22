// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waitlist_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitlistEntryModel _$WaitlistEntryModelFromJson(Map<String, dynamic> json) => WaitlistEntryModel(
  id: json['id'] as String,
  trip: TripRefModel.fromJson(json['trip'] as Map<String, dynamic>),
  stop: StopModel.fromJson(json['stop'] as Map<String, dynamic>),
  seats: (json['seats'] as num).toInt(),
  status: $enumDecode(_$WaitlistStatusEnumMap, json['status'], unknownValue: WaitlistStatus.unknown),
  joinedAt: DateTime.parse(json['joined_at'] as String),
  position: (json['position'] as num?)?.toInt(),
  offeredAt: json['offered_at'] == null ? null : DateTime.parse(json['offered_at'] as String),
  offerExpiresAt: json['offer_expires_at'] == null ? null : DateTime.parse(json['offer_expires_at'] as String),
  offerSecondsLeft: (json['offer_seconds_left'] as num?)?.toInt(),
  offerAmount: (json['offer_amount'] as num?)?.toInt(),
  bookingId: json['booking_id'] as String?,
);

const _$WaitlistStatusEnumMap = {
  WaitlistStatus.waiting: 'waiting',
  WaitlistStatus.offered: 'offered',
  WaitlistStatus.accepted: 'accepted',
  WaitlistStatus.declined: 'declined',
  WaitlistStatus.expired: 'expired',
  WaitlistStatus.left: 'left',
  WaitlistStatus.closed: 'closed',
  WaitlistStatus.unknown: 'unknown',
};
