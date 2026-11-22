import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tatay_transport/core/mock/mock_api_error.dart';
import 'package:tatay_transport/core/network/api_failure_mapper.dart';
import 'package:tatay_transport/core/network/result.dart';
import 'package:tatay_transport/core/state/action_status.dart';
import 'package:tatay_transport/features/bookings/data/repositories/bookings_repository.dart';
import 'package:tatay_transport/features/trips/data/models/trip_enums.dart';
import 'package:tatay_transport/features/trips/data/repositories/trips_repository.dart';
import 'package:tatay_transport/features/trips/presentation/cubits/trip_details_cubit.dart';
import 'package:tatay_transport/features/trips/presentation/cubits/trip_details_state.dart';
import 'package:tatay_transport/features/waitlist/data/repositories/waitlist_repository.dart';

import '../helpers/fixtures.dart';

class _Trips extends Mock implements TripsRepository {}

class _Bookings extends Mock implements BookingsRepository {}

class _Waitlist extends Mock implements WaitlistRepository {}

void main() {
  late _Trips trips;
  late _Bookings bookings;

  setUp(() {
    trips = _Trips();
    bookings = _Bookings();
  });

  TripDetailsCubit build() => TripDetailsCubit(trips, bookings, _Waitlist(), tripId: 'trip-1', maxSeats: 2);

  blocTest<TripDetailsCubit, TripDetailsState>(
    'a single stop is preselected; booking needs the terms ticked',
    build: build,
    setUp: () => when(() => trips.getTrip('trip-1')).thenAnswer((_) async => Success(tripFixture())),
    act: (c) async {
      await c.load();
      await c.book(); // ignored: terms not accepted
    },
    verify: (c) {
      final s = c.state as TripDetailsLoaded;
      expect(s.stopId, 'stop-1');
      expect(s.canSubmit, isFalse);
      verifyNever(
        () => bookings.createBooking(
          tripId: any(named: 'tripId'),
          stopId: any(named: 'stopId'),
          seats: any(named: 'seats'),
        ),
      );
    },
  );

  blocTest<TripDetailsCubit, TripDetailsState>(
    'successful booking hands the booking to the screen (to open payment)',
    build: build,
    setUp: () {
      when(() => trips.getTrip('trip-1')).thenAnswer((_) async => Success(tripFixture()));
      when(() => bookings.createBooking(tripId: 'trip-1', stopId: 'stop-1', seats: 2))
          .thenAnswer((_) async => Success(bookingFixture()));
    },
    act: (c) async {
      await c.load();
      c
        ..setSeats(5) // clamped to max 2
        ..setAgreed(true);
      await c.book();
    },
    verify: (c) {
      final s = c.state as TripDetailsLoaded;
      expect(s.submit, isA<ActionSucceeded>());
      expect(s.booking?.id, 'booking-1');
    },
  );

  blocTest<TripDetailsCubit, TripDetailsState>(
    'NOT_ENOUGH_SEATS reloads the trip so the waitlist button shows',
    build: build,
    setUp: () {
      var calls = 0;
      when(() => trips.getTrip('trip-1')).thenAnswer(
        (_) async => Success(calls++ == 0 ? tripFixture() : tripFixture(availability: 'full', available: 0)),
      );
      when(() => bookings.createBooking(tripId: 'trip-1', stopId: 'stop-1', seats: 1)).thenAnswer(
        (_) async => Failure(ApiFailureMapper.map(MockApiError.server(409, 'NOT_ENOUGH_SEATS', 'مفيش كراسي'))),
      );
    },
    act: (c) async {
      await c.load();
      c.setAgreed(true);
      await c.book();
    },
    verify: (c) {
      final s = c.state as TripDetailsLoaded;
      expect(s.trip.availability, Availability.full);
      expect(s.submit, isA<ActionFailed>());
      expect(s.booking, isNull);
    },
  );
}
