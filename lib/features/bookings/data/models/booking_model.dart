import 'package:json_annotation/json_annotation.dart';

import '../../../trips/data/models/stop_model.dart';
import '../../../trips/data/models/trip_ref_model.dart';
import 'booking_enums.dart';

part 'booking_model.g.dart';

@JsonSerializable(createToJson: false)
class BookingModel {
  const BookingModel({
    required this.id,
    required this.trip,
    required this.stop,
    required this.source,
    required this.seats,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.holdExpiresAt,
    this.secondsLeft,
    this.payment,
    this.paymentMethod,
    this.proofUploadedAt,
    this.rejectReason,
    this.boardedAt,
    this.boardingMethod,
    this.scanWindowOpensAt,
    this.scanWindowClosesAt,
    this.refundAmount,
    this.refundDueAt,
    this.refundedAt,
    this.refundReference,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  final String id;
  final TripRefModel trip;
  final StopModel stop;
  @JsonKey(unknownEnumValue: BookingSource.unknown)
  final BookingSource source;
  final int seats;

  /// Piasters.
  final int amount;
  @JsonKey(unknownEnumValue: BookingStatus.unknown)
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? holdExpiresAt;

  /// Only for `pending_payment`. Drives the countdown, never the phone clock.
  final int? secondsLeft;
  final PaymentInstructionsModel? payment;
  final String? paymentMethod;
  final DateTime? proofUploadedAt;
  final String? rejectReason;
  final DateTime? boardedAt;
  final String? boardingMethod;
  final DateTime? scanWindowOpensAt;
  final DateTime? scanWindowClosesAt;
  final int? refundAmount;
  final DateTime? refundDueAt;
  final DateTime? refundedAt;
  final String? refundReference;

  /// The "scan the code" button shows only inside the server-given window.
  bool canScanAt(DateTime now) {
    final opens = scanWindowOpensAt;
    final closes = scanWindowClosesAt;
    if (status != BookingStatus.confirmed || opens == null || closes == null) {
      return false;
    }
    return !now.isBefore(opens) && !now.isAfter(closes);
  }
}

@JsonSerializable(createToJson: false)
class PaymentInstructionsModel {
  const PaymentInstructionsModel({required this.method, required this.accountNumber, required this.amount});

  factory PaymentInstructionsModel.fromJson(Map<String, dynamic> json) => _$PaymentInstructionsModelFromJson(json);

  final String method;
  final String accountNumber;
  final int amount;
}
