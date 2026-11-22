import '../../../../core/network/api_failure.dart';
import '../../../../core/state/action_status.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../data/models/waitlist_entry_model.dart';

sealed class WaitlistOfferState {
  const WaitlistOfferState();
}

final class WaitlistOfferLoading extends WaitlistOfferState {
  const WaitlistOfferLoading();
}

final class WaitlistOfferError extends WaitlistOfferState {
  const WaitlistOfferError(this.failure);

  final ApiFailure failure;
}

/// An open offer: book within `offer_seconds_left` or let it go.
final class WaitlistOfferOpen extends WaitlistOfferState {
  const WaitlistOfferOpen({required this.entry, required this.secondsLeft, this.action = const ActionIdle()});

  final WaitlistEntryModel entry;
  final int secondsLeft;
  final ActionStatus action;

  WaitlistOfferOpen copyWith({int? secondsLeft, ActionStatus? action}) =>
      WaitlistOfferOpen(entry: entry, secondsLeft: secondsLeft ?? this.secondsLeft, action: action ?? this.action);
}

/// Accepted: a `pending_payment` booking exists, go pay.
final class WaitlistOfferAccepted extends WaitlistOfferState {
  const WaitlistOfferAccepted(this.booking);

  final BookingModel booking;
}

final class WaitlistOfferDeclined extends WaitlistOfferState {
  const WaitlistOfferDeclined();
}

/// The offer timed out, or the entry is not offered any more (any other status).
final class WaitlistOfferClosed extends WaitlistOfferState {
  const WaitlistOfferClosed({this.bookingId});

  /// When the passenger already accepted from another screen.
  final String? bookingId;
}
