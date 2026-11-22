import 'dart:async';
import 'dart:io';

import '../../../../core/mock/mock_api_error.dart';
import '../../../../core/mock/mock_database.dart';
import '../../../../core/network/paged_model.dart';
import '../models/booking_model.dart';
import '../models/create_booking_request.dart';
import 'bookings_data_source.dart';

class BookingsMockDataSource implements BookingsDataSource {
  BookingsMockDataSource(this._db);

  final MockDatabase _db;

  /// Idempotency-Key -> booking id, like the server's replay table.
  final Map<String, String> _replays = {};

  static const _activeTripStatuses = {'scheduled', 'confirmed'};

  @override
  Future<BookingModel> createBooking(String idempotencyKey, CreateBookingRequest body) async {
    await _db.behavior.latency();
    _db.tick();
    final replay = _replays[idempotencyKey];
    if (replay != null) {
      return BookingModel.fromJson(_db.bookingJson(_db.bookingById(replay)!));
    }

    final trip = _db.tripById(body.tripId);
    if (trip == null) {
      throw MockApiError.server(404, 'NOT_FOUND', 'الرحلة دي مش موجودة.');
    }
    if (_db.bookingClosed(trip)) {
      throw MockApiError.server(409, 'BOOKING_CLOSED', 'الحجز في الرحلة دي اتقفل.');
    }
    final mine = _db.tripJson(trip)['my_booking_id'];
    if (mine != null) {
      throw MockApiError.server(409, 'ALREADY_BOOKED', 'إنت حاجز في الرحلة دي بالفعل.');
    }
    final free = _db.availableSeats(trip);
    if (free < body.seats) {
      throw MockApiError.server(
        409,
        'NOT_ENOUGH_SEATS',
        'مفيش كراسي كفاية. تقدر تسجل في قايمة الانتظار.',
        details: {'available_seats': free, 'can_join_waitlist': true},
      );
    }
    final booking = <String, dynamic>{
      'id': _db.newId(),
      'source': 'app',
      'seats': body.seats,
      'amount': (trip['seat_price'] as int) * body.seats,
      'status': 'pending_payment',
      'created_at': MockDatabase.iso(_db.now()),
      'hold_expires_at': MockDatabase.iso(_db.now().add(Duration(minutes: _db.config['payment_hold_minutes'] as int))),
      'payment_method': null,
      'proof_uploaded_at': null,
      'reject_reason': null,
      'boarded_at': null,
      'boarding_method': null,
      'scan_window_opens_at': null,
      'scan_window_closes_at': null,
      'refund_amount': null,
      'refund_due_at': null,
      'refunded_at': null,
      'refund_reference': null,
      '_trip_id': trip['id'],
      '_stop_id': body.stopId,
      '_user_id': _db.currentUserId,
    };
    _db.bookings.add(booking);
    _replays[idempotencyKey] = booking['id'] as String;
    return BookingModel.fromJson(_db.bookingJson(booking));
  }

  @override
  Future<PagedModel<BookingModel>> listMyBookings({String? scope, int? page, int? perPage}) async {
    await _db.behavior.latency();
    _db.tick();
    final p = page ?? 1;
    final size = perPage ?? 20;
    final wantActive = (scope ?? 'active') == 'active';
    final all = _db.bookings.where((b) => b['_user_id'] == _db.currentUserId).where((b) {
      final trip = _db.tripById(b['_trip_id'] as String)!;
      final active =
          _activeTripStatuses.contains(trip['_status']) && MockDatabase.holdingStatuses.contains(b['status']);
      return active == wantActive;
    }).toList()..sort((a, b) => _departure(a).compareTo(_departure(b)) * (wantActive ? 1 : -1));
    final items = all.skip((p - 1) * size).take(size).map((b) => BookingModel.fromJson(_db.bookingJson(b))).toList();
    return PagedModel(items: items, page: p, perPage: size, total: all.length);
  }

  @override
  Future<BookingModel> getBooking(String bookingId) async {
    await _db.behavior.latency();
    _db.tick();
    return BookingModel.fromJson(_db.bookingJson(_mine(bookingId)));
  }

  @override
  Future<BookingModel> uploadPaymentProof(String bookingId, String idempotencyKey, File image) async {
    await _db.behavior.latency();
    final booking = _mine(bookingId);
    if (_replays[idempotencyKey] == bookingId) {
      return BookingModel.fromJson(_db.bookingJson(booking));
    }
    if (booking['status'] != 'pending_payment') {
      throw MockApiError.server(409, 'INVALID_STATE', 'حالة الحجز اتغيرت.');
    }
    if (_db.now().isAfter(MockDatabase.parse(booking['hold_expires_at']))) {
      throw MockApiError.server(409, 'HOLD_EXPIRED', 'مهلة الدفع خلصت.');
    }
    booking
      ..['status'] = 'pending_review'
      ..['payment_method'] = 'transfer'
      ..['proof_uploaded_at'] = MockDatabase.iso(_db.now());
    _replays[idempotencyKey] = bookingId;
    _simulateAdminApproval(booking);
    return BookingModel.fromJson(_db.bookingJson(booking));
  }

  /// The admin "approves" 20 seconds later, so the confirmed state and N1 can be seen.
  void _simulateAdminApproval(Map<String, dynamic> booking) {
    Timer(const Duration(seconds: 20), () {
      if (booking['status'] != 'pending_review') return;
      final trip = _db.tripById(booking['_trip_id'] as String)!;
      final at = MockDatabase.parse(_db.stopOf(trip, booking['_stop_id'] as String)['scheduled_at']);
      booking
        ..['status'] = 'confirmed'
        ..['scan_window_opens_at'] = MockDatabase.iso(at.subtract(const Duration(minutes: 15)))
        ..['scan_window_closes_at'] = MockDatabase.iso(at.add(const Duration(minutes: 15)));
      _db.addNotification('booking_confirmed', 'حجزك اتأكد', 'امسح الكود اللي في العربية وانت راكب.', {
        'screen': 'booking',
        'booking_id': booking['id'],
      });
    });
  }

  Map<String, dynamic> _mine(String id) {
    final booking = _db.bookingById(id);
    if (booking == null || booking['_user_id'] != _db.currentUserId) {
      throw MockApiError.server(404, 'NOT_FOUND', 'الحجز ده مش موجود.');
    }
    return booking;
  }

  String _departure(Map<String, dynamic> b) => _db.tripById(b['_trip_id'] as String)!['departure_at'] as String;
}
