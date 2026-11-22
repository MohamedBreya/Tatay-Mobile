// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  trip: TripRefModel.fromJson(json['trip'] as Map<String, dynamic>),
  stop: StopModel.fromJson(json['stop'] as Map<String, dynamic>),
  source: $enumDecode(_$BookingSourceEnumMap, json['source'], unknownValue: BookingSource.unknown),
  seats: (json['seats'] as num).toInt(),
  amount: (json['amount'] as num).toInt(),
  status: $enumDecode(_$BookingStatusEnumMap, json['status'], unknownValue: BookingStatus.unknown),
  createdAt: DateTime.parse(json['created_at'] as String),
  holdExpiresAt: json['hold_expires_at'] == null ? null : DateTime.parse(json['hold_expires_at'] as String),
  secondsLeft: (json['seconds_left'] as num?)?.toInt(),
  payment: json['payment'] == null ? null : PaymentInstructionsModel.fromJson(json['payment'] as Map<String, dynamic>),
  paymentMethod: json['payment_method'] as String?,
  proofUploadedAt: json['proof_uploaded_at'] == null ? null : DateTime.parse(json['proof_uploaded_at'] as String),
  rejectReason: json['reject_reason'] as String?,
  boardedAt: json['boarded_at'] == null ? null : DateTime.parse(json['boarded_at'] as String),
  boardingMethod: json['boarding_method'] as String?,
  scanWindowOpensAt: json['scan_window_opens_at'] == null
      ? null
      : DateTime.parse(json['scan_window_opens_at'] as String),
  scanWindowClosesAt: json['scan_window_closes_at'] == null
      ? null
      : DateTime.parse(json['scan_window_closes_at'] as String),
  refundAmount: (json['refund_amount'] as num?)?.toInt(),
  refundDueAt: json['refund_due_at'] == null ? null : DateTime.parse(json['refund_due_at'] as String),
  refundedAt: json['refunded_at'] == null ? null : DateTime.parse(json['refunded_at'] as String),
  refundReference: json['refund_reference'] as String?,
);

const _$BookingSourceEnumMap = {
  BookingSource.app: 'app',
  BookingSource.phone: 'phone',
  BookingSource.waitlist: 'waitlist',
  BookingSource.unknown: 'unknown',
};

const _$BookingStatusEnumMap = {
  BookingStatus.pendingPayment: 'pending_payment',
  BookingStatus.pendingReview: 'pending_review',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.expired: 'expired',
  BookingStatus.rejected: 'rejected',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.boarded: 'boarded',
  BookingStatus.noShow: 'no_show',
  BookingStatus.refundDue: 'refund_due',
  BookingStatus.refunded: 'refunded',
  BookingStatus.unknown: 'unknown',
};

PaymentInstructionsModel _$PaymentInstructionsModelFromJson(Map<String, dynamic> json) => PaymentInstructionsModel(
  method: json['method'] as String,
  accountNumber: json['account_number'] as String,
  amount: (json['amount'] as num).toInt(),
);
