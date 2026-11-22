import '../../../../core/mock/mock_api_error.dart';
import '../../../../core/mock/mock_database.dart';
import '../../../../core/network/paged_model.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../models/join_waitlist_request.dart';
import '../models/waitlist_entry_model.dart';
import 'waitlist_data_source.dart';

class WaitlistMockDataSource implements WaitlistDataSource {
  WaitlistMockDataSource(this._db);

  final MockDatabase _db;

  @override
  Future<WaitlistEntryModel> joinWaitlist(String tripId, String idempotencyKey, JoinWaitlistRequest body) async {
    await _db.behavior.latency();
    final trip = _db.tripById(tripId);
    if (trip == null) {
      throw MockApiError.server(404, 'NOT_FOUND', 'الرحلة دي مش موجودة.');
    }
    final view = _db.tripJson(trip);
    if (view['availability'] == 'closed') {
      throw MockApiError.server(409, 'BOOKING_CLOSED', 'الحجز اتقفل.');
    }
    if (view['my_booking_id'] != null) {
      throw MockApiError.server(409, 'ALREADY_BOOKED', 'إنت حاجز في الرحلة دي.');
    }
    if (view['my_waitlist_entry_id'] != null) {
      throw MockApiError.server(409, 'ALREADY_WAITLISTED', 'إنت في قايمة الانتظار بالفعل.');
    }
    final free = view['available_seats'] as int;
    if (free >= body.seats) {
      throw MockApiError.server(
        409,
        'SEATS_AVAILABLE',
        'فيه كراسي متاحة، تقدر تحجز على طول.',
        details: {'available_seats': free},
      );
    }
    final entry = <String, dynamic>{
      'id': _db.newId(),
      'seats': body.seats,
      'status': 'waiting',
      'joined_at': MockDatabase.iso(_db.now()),
      'offered_at': null,
      'offer_expires_at': null,
      'booking_id': null,
      '_trip_id': tripId,
      '_stop_id': body.stopId,
      '_user_id': _db.currentUserId,
    };
    _db.waitlist.add(entry);
    return WaitlistEntryModel.fromJson(_db.entryJson(entry));
  }

  @override
  Future<PagedModel<WaitlistEntryModel>> listMyWaitlist({int? page, int? perPage}) async {
    await _db.behavior.latency();
    _db.tick();
    final mine = _db.waitlist.where((w) => w['_user_id'] == _db.currentUserId).toList()
      ..sort((a, b) => _rank(a).compareTo(_rank(b)));
    final items = mine.map((w) => WaitlistEntryModel.fromJson(_db.entryJson(w))).toList();
    return PagedModel(items: items, page: page ?? 1, perPage: perPage ?? 20, total: items.length);
  }

  @override
  Future<WaitlistEntryModel> getEntry(String entryId) async {
    await _db.behavior.latency();
    _db.tick();
    return WaitlistEntryModel.fromJson(_db.entryJson(_mine(entryId)));
  }

  @override
  Future<void> leave(String entryId) async {
    await _db.behavior.latency();
    final entry = _mine(entryId);
    if (entry['status'] != 'waiting' && entry['status'] != 'offered') {
      throw MockApiError.server(409, 'INVALID_STATE', 'إنت مش في قايمة الانتظار دلوقتي.');
    }
    entry['status'] = 'left';
  }

  @override
  Future<BookingModel> accept(String entryId, String idempotencyKey) async {
    await _db.behavior.latency();
    _db.tick();
    final entry = _mine(entryId);
    if (entry['status'] == 'accepted') {
      return BookingModel.fromJson(_db.bookingJson(_db.bookingById(entry['booking_id'] as String)!));
    }
    if (entry['status'] != 'offered') {
      throw MockApiError.server(409, 'OFFER_EXPIRED', 'العرض انتهى.');
    }
    final trip = _db.tripById(entry['_trip_id'] as String)!;
    final booking = <String, dynamic>{
      'id': _db.newId(),
      'source': 'waitlist',
      'seats': entry['seats'],
      'amount': (trip['seat_price'] as int) * (entry['seats'] as int),
      'status': 'pending_payment',
      'created_at': MockDatabase.iso(_db.now()),
      'hold_expires_at': MockDatabase.iso(_db.now().add(const Duration(minutes: 15))),
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
      '_stop_id': entry['_stop_id'],
      '_user_id': _db.currentUserId,
    };
    _db.bookings.add(booking);
    entry
      ..['status'] = 'accepted'
      ..['booking_id'] = booking['id'];
    return BookingModel.fromJson(_db.bookingJson(booking));
  }

  @override
  Future<WaitlistEntryModel> decline(String entryId) async {
    await _db.behavior.latency();
    _db.tick();
    final entry = _mine(entryId);
    if (entry['status'] != 'offered') {
      throw MockApiError.server(409, 'OFFER_EXPIRED', 'العرض انتهى.');
    }
    entry['status'] = 'declined';
    return WaitlistEntryModel.fromJson(_db.entryJson(entry));
  }

  int _rank(Map<String, dynamic> w) => switch (w['status']) {
    'offered' => 0,
    'waiting' => 1,
    _ => 2,
  };

  Map<String, dynamic> _mine(String id) {
    final entry = _db.entryById(id);
    if (entry == null || entry['_user_id'] != _db.currentUserId) {
      throw MockApiError.server(404, 'NOT_FOUND', 'التسجيل ده مش موجود.');
    }
    return entry;
  }
}
