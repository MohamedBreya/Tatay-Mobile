import 'package:json_annotation/json_annotation.dart';

enum BookingStatus {
  @JsonValue('pending_payment')
  pendingPayment,
  @JsonValue('pending_review')
  pendingReview,
  confirmed,
  expired,
  rejected,
  cancelled,
  boarded,
  @JsonValue('no_show')
  noShow,
  @JsonValue('refund_due')
  refundDue,
  refunded,
  unknown,
}

enum BookingSource { app, phone, waitlist, unknown }

/// `GET /bookings?scope=`.
enum BookingScope { active, past }
