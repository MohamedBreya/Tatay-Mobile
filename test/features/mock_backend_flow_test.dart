import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tatay_transport/core/mock/mock_behavior.dart';
import 'package:tatay_transport/core/mock/mock_database.dart';
import 'package:tatay_transport/core/network/api_error_code.dart';
import 'package:tatay_transport/core/network/api_failure.dart';
import 'package:tatay_transport/core/network/api_failure_mapper.dart';
import 'package:tatay_transport/core/network/result.dart';
import 'package:tatay_transport/features/boarding/data/datasources/boarding_mock_data_source.dart';
import 'package:tatay_transport/features/boarding/data/repositories/boarding_repository.dart';
import 'package:tatay_transport/features/bookings/data/datasources/bookings_mock_data_source.dart';
import 'package:tatay_transport/features/bookings/data/models/booking_enums.dart';
import 'package:tatay_transport/features/bookings/data/repositories/bookings_repository.dart';
import 'package:tatay_transport/features/trips/data/datasources/trips_mock_data_source.dart';
import 'package:tatay_transport/features/trips/data/models/trip_enums.dart';
import 'package:tatay_transport/features/trips/data/repositories/trips_repository.dart';
import 'package:tatay_transport/features/waitlist/data/datasources/waitlist_mock_data_source.dart';
import 'package:tatay_transport/features/waitlist/data/repositories/waitlist_repository.dart';

/// Runs the repositories against the mock backend: checks the JSON round trip through
/// the real models and that the mock keeps seats, bookings and waitlist consistent.
void main() {
  late MockDatabase db;
  late TripsRepository trips;
  late BookingsRepository bookings;
  late BookingsMockDataSource bookingsSource;
  late WaitlistRepository waitlist;

  setUp(() {
    db = MockDatabase(MockBehavior(scenario: 'instant'));
    trips = TripsRepository(TripsMockDataSource(db));
    bookingsSource = BookingsMockDataSource(db);
    bookings = BookingsRepository(bookingsSource);
    waitlist = WaitlistRepository(WaitlistMockDataSource(db));
  });

  T ok<T>(Result<T> r) => (r as Success<T>).data;

  test('booking takes seats, shows on the trip, and appears in My bookings', () async {
    final trip = ok(await trips.listTrips(Direction.outbound)).items
        .firstWhere((t) => t.availability == Availability.available && t.myBookingId == null);
    final booking = ok(await bookings.createBooking(tripId: trip.id, stopId: trip.stops.first.id, seats: 2));

    expect(booking.status, BookingStatus.pendingPayment);
    expect(booking.amount, trip.seatPrice * 2);
    expect(booking.secondsLeft, inInclusiveRange(890, 900));
    expect(booking.payment?.accountNumber, isNotEmpty);

    final after = ok(await trips.getTrip(trip.id));
    expect(after.availableSeats, trip.availableSeats - 2);
    expect(after.myBookingId, booking.id);

    final active = ok(await bookings.listMyBookings(BookingScope.active)).items;
    expect(active.map((b) => b.id), contains(booking.id));
  });

  test('a second booking on the same trip is ALREADY_BOOKED', () async {
    final trip = ok(await trips.listTrips(Direction.outbound)).items
        .firstWhere((t) => t.availability == Availability.available && t.myBookingId == null);
    await bookings.createBooking(tripId: trip.id, stopId: trip.stops.first.id, seats: 1);
    final again = await bookings.createBooking(tripId: trip.id, stopId: trip.stops.first.id, seats: 1);
    expect(((again as Failure).failure as ServerFailure).code, ApiErrorCode.alreadyBooked);
  });

  test('full trip: booking fails with can_join_waitlist, joining the waitlist works', () async {
    final full = ok(await trips.listTrips(Direction.outbound)).items
        .firstWhere((t) => t.availability == Availability.full && t.myWaitlistEntryId == null);
    final booking = await bookings.createBooking(tripId: full.id, stopId: full.stops.first.id, seats: 1);
    final failure = (booking as Failure).failure as ServerFailure;
    expect(failure.code, ApiErrorCode.notEnoughSeats);
    expect(failure.detailBool('can_join_waitlist'), isTrue);

    final entry = ok(await waitlist.join(tripId: full.id, stopId: full.stops.first.id, seats: 1));
    expect(entry.position, 1);
    expect(ok(await trips.getTrip(full.id)).hasActiveWaitlist, isTrue);
  });

  test('upload after the hold ran out is HOLD_EXPIRED (T3)', () async {
    final pending = db.bookings.firstWhere((b) => b['status'] == 'pending_payment');
    pending['hold_expires_at'] = MockDatabase.iso(DateTime.now().toUtc().subtract(const Duration(seconds: 1)));
    final error = await bookingsSource
        .uploadPaymentProof(pending['id'] as String, 'k1', File('x'))
        .then<Object?>((_) => null, onError: (Object e) => e);
    expect((ApiFailureMapper.map(error!) as ServerFailure).code, ApiErrorCode.holdExpired);
    // tick() at read time also expires it, like the J1 job.
    final read = ok(await bookings.getBooking(pending['id'] as String));
    expect(read.status, BookingStatus.expired);
  });

  test('scan rules: wrong QR, wrong vehicle, success, then already boarded (T8)', () async {
    final boarding = BoardingRepository(BoardingMockDataSource(db));
    Future<ApiErrorCode?> codeOf(String qr) async => switch (await boarding.scan(qr)) {
      Failure(failure: ServerFailure(:final code)) => code,
      _ => null,
    };
    expect(await codeOf('NOT-OURS'), ApiErrorCode.qrInvalid);
    expect(await codeOf('TATAY-VEH-2'), ApiErrorCode.wrongVehicle);

    final first = ok(await boarding.scan('TATAY-VEH-1'));
    expect(first.alreadyBoarded, isFalse);
    final second = ok(await boarding.scan('TATAY-VEH-1'));
    expect(second.alreadyBoarded, isTrue);
  });

  test('accepting a waitlist offer creates a pending_payment booking', () async {
    final offered = ok(await waitlist.listMine()).items.firstWhere((e) => e.status == WaitlistStatus.offered);
    expect(offered.offerSecondsLeft, greaterThan(0));
    final booking = ok(await waitlist.accept(offered.id));
    expect(booking.status, BookingStatus.pendingPayment);
    expect(booking.source, BookingSource.waitlist);
    final declineAgain = await waitlist.decline(offered.id);
    expect(((declineAgain as Failure).failure as ServerFailure).code, ApiErrorCode.offerExpired);
  });
}
