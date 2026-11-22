/// Error codes from the API contract (`components.schemas.ErrorCode`).
/// Clients branch on these, never on the message. Unknown codes map to [unknown].
enum ApiErrorCode {
  validationError('VALIDATION_ERROR'),
  duplicatePhone('DUPLICATE_PHONE'),
  duplicateEmail('DUPLICATE_EMAIL'),
  otpInvalid('OTP_INVALID'),
  otpExpired('OTP_EXPIRED'),
  otpTooMany('OTP_TOO_MANY'),
  invalidCredentials('INVALID_CREDENTIALS'),
  accountDisabled('ACCOUNT_DISABLED'),
  unauthenticated('UNAUTHENTICATED'),
  emailNotVerified('EMAIL_NOT_VERIFIED'),
  forbidden('FORBIDDEN'),
  notFound('NOT_FOUND'),
  invalidState('INVALID_STATE'),
  bookingClosed('BOOKING_CLOSED'),
  bookingUnavailable('BOOKING_UNAVAILABLE'),
  notEnoughSeats('NOT_ENOUGH_SEATS'),
  seatsAvailable('SEATS_AVAILABLE'),
  alreadyBooked('ALREADY_BOOKED'),
  alreadyWaitlisted('ALREADY_WAITLISTED'),
  holdExpired('HOLD_EXPIRED'),
  offerExpired('OFFER_EXPIRED'),
  qrInvalid('QR_INVALID'),
  noBooking('NO_BOOKING'),
  wrongVehicle('WRONG_VEHICLE'),
  outsideWindow('OUTSIDE_WINDOW'),
  paymentNotConfirmed('PAYMENT_NOT_CONFIRMED'),
  idempotencyKeyReused('IDEMPOTENCY_KEY_REUSED'),
  requestInProgress('REQUEST_IN_PROGRESS'),
  payloadTooLarge('PAYLOAD_TOO_LARGE'),
  rateLimited('RATE_LIMITED'),
  internalError('INTERNAL_ERROR'),
  unknown('UNKNOWN');

  const ApiErrorCode(this.wire);

  final String wire;

  static ApiErrorCode fromWire(String? value) =>
      values.firstWhere((c) => c.wire == value, orElse: () => ApiErrorCode.unknown);
}
