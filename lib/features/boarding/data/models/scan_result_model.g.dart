// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResultModel _$ScanResultModelFromJson(Map<String, dynamic> json) => ScanResultModel(
  bookingId: json['booking_id'] as String,
  seats: (json['seats'] as num).toInt(),
  passengerName: json['passenger_name'] as String,
  stopName: json['stop_name'] as String,
  vehiclePlateNumber: json['vehicle_plate_number'] as String,
  alreadyBoarded: json['already_boarded'] as bool,
);
