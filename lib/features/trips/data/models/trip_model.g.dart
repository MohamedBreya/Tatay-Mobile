// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
  id: json['id'] as String,
  lineId: json['line_id'] as String,
  direction: $enumDecode(_$DirectionEnumMap, json['direction'], unknownValue: Direction.unknown),
  departureAt: DateTime.parse(json['departure_at'] as String),
  arrivalPoint: json['arrival_point'] as String,
  stops: (json['stops'] as List<dynamic>).map((e) => StopModel.fromJson(e as Map<String, dynamic>)).toList(),
  seatPrice: (json['seat_price'] as num).toInt(),
  seatCount: (json['seat_count'] as num).toInt(),
  availableSeats: (json['available_seats'] as num).toInt(),
  availability: $enumDecode(_$AvailabilityEnumMap, json['availability'], unknownValue: Availability.unknown),
  minPassengers: (json['min_passengers'] as num).toInt(),
  isConfirmed: json['is_confirmed'] as bool,
  myBookingId: json['my_booking_id'] as String?,
  myWaitlistEntryId: json['my_waitlist_entry_id'] as String?,
  myWaitlistStatus: $enumDecodeNullable(
    _$WaitlistStatusEnumMap,
    json['my_waitlist_status'],
    unknownValue: WaitlistStatus.unknown,
  ),
  lineName: json['line_name'] as String?,
  vehicleType: json['vehicle_type'] as String?,
  vehiclePlateNumber: json['vehicle_plate_number'] as String?,
  bookingClosesAt: json['booking_closes_at'] == null ? null : DateTime.parse(json['booking_closes_at'] as String),
);

const _$DirectionEnumMap = {
  Direction.outbound: 'outbound',
  Direction.returnTrip: 'return',
  Direction.unknown: 'unknown',
};

const _$AvailabilityEnumMap = {
  Availability.available: 'available',
  Availability.full: 'full',
  Availability.closed: 'closed',
  Availability.unknown: 'unknown',
};

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
