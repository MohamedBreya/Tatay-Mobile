import 'package:tatay_transport/features/bookings/data/models/booking_model.dart';
import 'package:tatay_transport/features/trips/data/models/trip_model.dart';
import 'package:tatay_transport/features/waitlist/data/models/waitlist_entry_model.dart';

const _stop = {
  'id': 'stop-1',
  'sequence': 1,
  'name': 'قدام الجامع',
  'scheduled_at': '2026-11-23T04:30:00Z',
  'not_operated': false,
};

const _tripRef = {
  'id': 'trip-1',
  'direction': 'outbound',
  'departure_at': '2026-11-23T04:30:00Z',
  'arrival_point': 'موقف المدينة',
  'status': 'scheduled',
};

TripModel tripFixture({String availability = 'available', int available = 5, String? myBookingId}) =>
    TripModel.fromJson({
      'id': 'trip-1',
      'line_id': 'line-1',
      'direction': 'outbound',
      'departure_at': '2026-11-23T04:30:00Z',
      'arrival_point': 'موقف المدينة',
      'stops': [_stop],
      'seat_price': 5000,
      'seat_count': 14,
      'available_seats': available,
      'availability': availability,
      'min_passengers': 8,
      'is_confirmed': false,
      'my_booking_id': myBookingId,
    });

BookingModel bookingFixture({String status = 'pending_payment', int? secondsLeft = 900}) => BookingModel.fromJson({
  'id': 'booking-1',
  'trip': _tripRef,
  'stop': _stop,
  'source': 'app',
  'seats': 1,
  'amount': 5000,
  'status': status,
  'seconds_left': secondsLeft,
  'payment': status == 'pending_payment' ? {'method': 'transfer', 'account_number': '010', 'amount': 5000} : null,
  'created_at': '2026-11-21T10:00:00Z',
});

WaitlistEntryModel entryFixture({String status = 'offered', int? secondsLeft = 300}) => WaitlistEntryModel.fromJson({
  'id': 'entry-1',
  'trip': _tripRef,
  'stop': _stop,
  'seats': 1,
  'status': status,
  'joined_at': '2026-11-21T10:00:00Z',
  'offer_seconds_left': secondsLeft,
  'offer_amount': 5000,
});
