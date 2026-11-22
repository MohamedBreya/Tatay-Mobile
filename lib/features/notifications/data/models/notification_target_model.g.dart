// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_target_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationTargetModel _$NotificationTargetModelFromJson(Map<String, dynamic> json) => NotificationTargetModel(
  screen: $enumDecode(_$TargetScreenEnumMap, json['screen'], unknownValue: TargetScreen.unknown),
  bookingId: json['booking_id'] as String?,
  tripId: json['trip_id'] as String?,
  waitlistEntryId: json['waitlist_entry_id'] as String?,
);

const _$TargetScreenEnumMap = {
  TargetScreen.booking: 'booking',
  TargetScreen.trip: 'trip',
  TargetScreen.waitlistOffer: 'waitlist_offer',
  TargetScreen.unknown: 'unknown',
};
