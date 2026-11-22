// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_ref_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripRefModel _$TripRefModelFromJson(Map<String, dynamic> json) => TripRefModel(
  id: json['id'] as String,
  direction: $enumDecode(_$DirectionEnumMap, json['direction'], unknownValue: Direction.unknown),
  departureAt: DateTime.parse(json['departure_at'] as String),
  arrivalPoint: json['arrival_point'] as String,
  status: $enumDecode(_$TripStatusEnumMap, json['status'], unknownValue: TripStatus.unknown),
  vehiclePlateNumber: json['vehicle_plate_number'] as String?,
);

const _$DirectionEnumMap = {
  Direction.outbound: 'outbound',
  Direction.returnTrip: 'return',
  Direction.unknown: 'unknown',
};

const _$TripStatusEnumMap = {
  TripStatus.scheduled: 'scheduled',
  TripStatus.confirmed: 'confirmed',
  TripStatus.completed: 'completed',
  TripStatus.cancelled: 'cancelled',
  TripStatus.notOperated: 'not_operated',
  TripStatus.unknown: 'unknown',
};
