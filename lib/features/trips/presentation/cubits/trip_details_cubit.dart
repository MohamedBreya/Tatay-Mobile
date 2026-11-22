import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_code.dart';
import '../../../../core/network/api_failure.dart';
import '../../../../core/network/result.dart';
import '../../../../core/state/action_status.dart';
import '../../../bookings/data/repositories/bookings_repository.dart';
import '../../../waitlist/data/repositories/waitlist_repository.dart';
import '../../data/models/trip_enums.dart';
import '../../data/repositories/trips_repository.dart';
import 'trip_details_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  TripDetailsCubit(this._trips, this._bookings, this._waitlist, {required this.tripId, required this.maxSeats})
    : super(const TripDetailsLoading());

  final TripsRepository _trips;
  final BookingsRepository _bookings;
  final WaitlistRepository _waitlist;
  final String tripId;

  /// `max_seats_per_booking` from `/config` (2 by default).
  final int maxSeats;

  /// Errors after which the trip changed on the server and must be fetched again.
  static const _staleTripCodes = {
    ApiErrorCode.notEnoughSeats,
    ApiErrorCode.seatsAvailable,
    ApiErrorCode.bookingClosed,
    ApiErrorCode.alreadyBooked,
    ApiErrorCode.alreadyWaitlisted,
    ApiErrorCode.invalidState,
  };

  Future<void> load() async {
    emit(const TripDetailsLoading());
    final result = await _trips.getTrip(tripId);
    emit(switch (result) {
      Success(:final data) => TripDetailsLoaded(
        trip: data,
        stopId: data.boardableStops.length == 1 ? data.boardableStops.first.id : null,
      ),
      Failure(:final failure) => TripDetailsError(failure),
    });
  }

  void selectStop(String stopId) => _update((s) => s.copyWith(stopId: stopId, submit: const ActionIdle()));

  void setSeats(int seats) => _update((s) => s.copyWith(seats: seats.clamp(1, maxSeats), submit: const ActionIdle()));

  void setAgreed(bool agreed) => _update((s) => s.copyWith(agreed: agreed));

  Future<void> book() => _submit((s) async {
    final result = await _bookings.createBooking(tripId: tripId, stopId: s.stopId!, seats: s.seats);
    return switch (result) {
      Success(:final data) => s.copyWith(submit: const ActionSucceeded(), booking: data),
      Failure(:final failure) => await _failed(s, failure),
    };
  });

  Future<void> joinWaitlist() => _submit((s) async {
    final result = await _waitlist.join(tripId: tripId, stopId: s.stopId!, seats: s.seats);
    return switch (result) {
      Success(:final data) => s.copyWith(submit: const ActionSucceeded(), waitlistEntry: data),
      Failure(:final failure) => await _failed(s, failure),
    };
  });

  Future<void> _submit(Future<TripDetailsLoaded> Function(TripDetailsLoaded s) action) async {
    final current = state;
    if (current is! TripDetailsLoaded || !current.canSubmit) return;
    emit(current.copyWith(submit: const ActionInProgress()));
    emit(await action(current));
  }

  /// Shows the error and, when the trip changed (seats, closed, already booked),
  /// reloads it so the right button appears.
  Future<TripDetailsLoaded> _failed(TripDetailsLoaded s, ApiFailure failure) async {
    if (failure is ServerFailure && _staleTripCodes.contains(failure.code)) {
      final fresh = await _trips.getTrip(tripId);
      if (fresh case Success(:final data)) {
        final seats = data.availability == Availability.available && data.availableSeats < s.seats
            ? data.availableSeats.clamp(1, maxSeats)
            : s.seats;
        return s.copyWith(trip: data, seats: seats, submit: ActionFailed(failure));
      }
    }
    return s.copyWith(submit: ActionFailed(failure));
  }

  void _update(TripDetailsLoaded Function(TripDetailsLoaded s) change) {
    final current = state;
    if (current is TripDetailsLoaded) emit(change(current));
  }
}
