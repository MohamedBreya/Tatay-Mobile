import '../../../../core/network/api_failure.dart';
import '../../../../core/state/action_status.dart';
import '../../../bookings/data/models/booking_model.dart';

sealed class PaymentState {
  const PaymentState();
}

final class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

final class PaymentError extends PaymentState {
  const PaymentError(this.failure);

  final ApiFailure failure;
}

/// `pending_payment`: countdown running, waiting for the transfer screenshot.
final class PaymentAwaiting extends PaymentState {
  const PaymentAwaiting({required this.booking, required this.secondsLeft, this.upload = const ActionIdle()});

  final BookingModel booking;
  final int secondsLeft;
  final ActionStatus upload;

  PaymentAwaiting copyWith({int? secondsLeft, ActionStatus? upload}) =>
      PaymentAwaiting(booking: booking, secondsLeft: secondsLeft ?? this.secondsLeft, upload: upload ?? this.upload);
}

/// Screenshot received; the timer stopped and the seat is held until the admin reviews.
final class PaymentSubmitted extends PaymentState {
  const PaymentSubmitted(this.booking);

  final BookingModel booking;
}

/// The hold ran out before the screenshot was uploaded.
final class PaymentExpired extends PaymentState {
  const PaymentExpired();
}

/// Any other status (already confirmed, rejected...): nothing to pay here.
final class PaymentNotPayable extends PaymentState {
  const PaymentNotPayable(this.booking);

  final BookingModel booking;
}
