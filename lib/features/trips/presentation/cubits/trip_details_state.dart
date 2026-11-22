import '../../../../core/network/api_failure.dart';
import '../../../../core/state/action_status.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../waitlist/data/models/waitlist_entry_model.dart';
import '../../data/models/trip_model.dart';

sealed class TripDetailsState {
  const TripDetailsState();
}

final class TripDetailsLoading extends TripDetailsState {
  const TripDetailsLoading();
}

final class TripDetailsError extends TripDetailsState {
  const TripDetailsError(this.failure);

  final ApiFailure failure;
}

final class TripDetailsLoaded extends TripDetailsState {
  const TripDetailsLoaded({
    required this.trip,
    this.stopId,
    this.seats = 1,
    this.agreed = false,
    this.submit = const ActionIdle(),
    this.booking,
    this.waitlistEntry,
  });

  final TripModel trip;
  final String? stopId;
  final int seats;

  /// The passenger ticked "I read the terms" (no cancellation, 5-minute wait, no-show).
  final bool agreed;
  final ActionStatus submit;

  /// Set once, right after booking: the screen moves to payment.
  final BookingModel? booking;

  /// Set once, right after joining the waitlist.
  final WaitlistEntryModel? waitlistEntry;

  /// Price shown before booking. The amount to pay comes from the server's booking.
  int get total => trip.seatPrice * seats;

  bool get canSubmit => stopId != null && agreed && submit is! ActionInProgress;

  TripDetailsLoaded copyWith({
    TripModel? trip,
    String? stopId,
    int? seats,
    bool? agreed,
    ActionStatus? submit,
    BookingModel? booking,
    WaitlistEntryModel? waitlistEntry,
  }) => TripDetailsLoaded(
    trip: trip ?? this.trip,
    stopId: stopId ?? this.stopId,
    seats: seats ?? this.seats,
    agreed: agreed ?? this.agreed,
    submit: submit ?? this.submit,
    booking: booking,
    waitlistEntry: waitlistEntry,
  );
}
