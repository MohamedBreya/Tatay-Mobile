// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) => AppConfigModel(
  paymentAccountNumber: json['payment_account_number'] as String,
  supportPhone: json['support_phone'] as String,
  paymentHoldMinutes: (json['payment_hold_minutes'] as num).toInt(),
  waitlistOfferMinutes: (json['waitlist_offer_minutes'] as num).toInt(),
  bookingCloseMinutes: (json['booking_close_minutes'] as num).toInt(),
  maxSeatsPerBooking: (json['max_seats_per_booking'] as num).toInt(),
  boardingWaitMinutes: (json['boarding_wait_minutes'] as num).toInt(),
  scanWindowMinutes: (json['scan_window_minutes'] as num).toInt(),
  refundHours: (json['refund_hours'] as num).toInt(),
  policies: PoliciesModel.fromJson(json['policies'] as Map<String, dynamic>),
);

PoliciesModel _$PoliciesModelFromJson(Map<String, dynamic> json) => PoliciesModel(
  noCancellation: json['no_cancellation'] as String,
  boardingWait: json['boarding_wait'] as String,
  noShow: json['no_show'] as String,
);
