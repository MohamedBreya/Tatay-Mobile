import '../../../../core/network/api_failure.dart';
import '../../data/models/booking_model.dart';

sealed class BookingDetailsState {
  const BookingDetailsState();
}

final class BookingDetailsLoading extends BookingDetailsState {
  const BookingDetailsLoading();
}

final class BookingDetailsError extends BookingDetailsState {
  const BookingDetailsError(this.failure);

  final ApiFailure failure;
}

final class BookingDetailsLoaded extends BookingDetailsState {
  const BookingDetailsLoaded({required this.booking, required this.loadedAt, required this.now});

  final BookingModel booking;

  /// When the server answered; `seconds_left` counts from here, not from the phone clock.
  final DateTime loadedAt;

  /// Ticks so the countdown and the scan-window button stay current.
  final DateTime now;

  int? get secondsLeft {
    final left = booking.secondsLeft;
    if (left == null) return null;
    final remaining = left - now.difference(loadedAt).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }

  bool get canScan => booking.canScanAt(now.toUtc());
}
