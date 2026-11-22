import 'package:uuid/uuid.dart';

import 'mock_behavior.dart';
import 'mock_seed.dart';

/// One in-memory "backend" shared by every MockDataSource, so a booking made on the
/// trip screen shows up in My bookings, takes seats from the trip, and so on.
///
/// Records are kept in the contract JSON shape. Keys starting with `_` are private
/// server-side fields that never leave the mock.
class MockDatabase {
  MockDatabase(this.behavior) {
    MockSeed.populate(this);
  }

  final MockBehavior behavior;
  final _uuid = const Uuid();

  final List<Map<String, dynamic>> users = [];
  final List<Map<String, dynamic>> trips = [];
  final List<Map<String, dynamic>> bookings = [];
  final List<Map<String, dynamic>> waitlist = [];
  final List<Map<String, dynamic>> notifications = [];
  final Map<String, dynamic> config = {};
  String? currentUserId;

  static const holdingStatuses = {'pending_payment', 'pending_review', 'confirmed', 'boarded'};
  static const otpCode = '123456';

  DateTime now() => DateTime.now().toUtc();
  String newId() => _uuid.v4();
  static String iso(DateTime t) => t.toUtc().toIso8601String();
  static DateTime parse(Object? v) => DateTime.parse(v! as String);

  Map<String, dynamic>? userById(String? id) => users.where((u) => u['id'] == id).firstOrNull;
  Map<String, dynamic>? tripById(String id) => trips.where((t) => t['id'] == id).firstOrNull;
  Map<String, dynamic>? bookingById(String id) => bookings.where((b) => b['id'] == id).firstOrNull;
  Map<String, dynamic>? entryById(String id) => waitlist.where((w) => w['id'] == id).firstOrNull;

  Map<String, dynamic> publicUser(Map<String, dynamic> user) =>
      Map.of(user)..removeWhere((key, _) => key.startsWith('_'));

  /// Seats nobody holds: other passengers, my holding bookings and open offers are taken.
  int availableSeats(Map<String, dynamic> trip) {
    final mine = bookings
        .where((b) => b['_trip_id'] == trip['id'] && holdingStatuses.contains(b['status']))
        .fold<int>(0, (sum, b) => sum + (b['seats'] as int));
    final offered = waitlist
        .where((w) => w['_trip_id'] == trip['id'] && w['status'] == 'offered')
        .fold<int>(0, (sum, w) => sum + (w['seats'] as int));
    final free = (trip['seat_count'] as int) - (trip['_taken'] as int) - mine - offered;
    return free < 0 ? 0 : free;
  }

  bool bookingClosed(Map<String, dynamic> trip) => now().isAfter(parse(trip['booking_closes_at']));

  Map<String, dynamic> tripJson(Map<String, dynamic> trip) {
    final free = availableSeats(trip);
    final myBooking = bookings
        .where((b) => b['_trip_id'] == trip['id'] && b['_user_id'] == currentUserId)
        .where((b) => holdingStatuses.contains(b['status']))
        .firstOrNull;
    final myEntry = waitlist
        .where((w) => w['_trip_id'] == trip['id'] && w['_user_id'] == currentUserId)
        .where((w) => w['status'] == 'waiting' || w['status'] == 'offered')
        .firstOrNull;
    return Map.of(trip)
      ..removeWhere((key, _) => key.startsWith('_'))
      ..['available_seats'] = free
      ..['availability'] = bookingClosed(trip) ? 'closed' : (free > 0 ? 'available' : 'full')
      ..['my_booking_id'] = myBooking?['id']
      ..['my_waitlist_entry_id'] = myEntry?['id']
      ..['my_waitlist_status'] = myEntry?['status'];
  }

  Map<String, dynamic> tripRef(Map<String, dynamic> trip) => {
    'id': trip['id'],
    'direction': trip['direction'],
    'departure_at': trip['departure_at'],
    'arrival_point': trip['arrival_point'],
    'status': trip['_status'],
    'vehicle_plate_number': trip['vehicle_plate_number'],
  };

  Map<String, dynamic> stopOf(Map<String, dynamic> trip, String stopId) =>
      (trip['stops'] as List).cast<Map<String, dynamic>>().firstWhere((s) => s['id'] == stopId);

  Map<String, dynamic> bookingJson(Map<String, dynamic> booking) {
    final trip = tripById(booking['_trip_id'] as String)!;
    final pending = booking['status'] == 'pending_payment';
    final secondsLeft = pending ? parse(booking['hold_expires_at']).difference(now()).inSeconds : null;
    return Map.of(booking)
      ..removeWhere((key, _) => key.startsWith('_'))
      ..['trip'] = tripRef(trip)
      ..['stop'] = stopOf(trip, booking['_stop_id'] as String)
      ..['seconds_left'] = secondsLeft == null ? null : (secondsLeft < 0 ? 0 : secondsLeft)
      ..['payment'] = pending
          ? {'method': 'transfer', 'account_number': config['payment_account_number'], 'amount': booking['amount']}
          : null;
  }

  Map<String, dynamic> entryJson(Map<String, dynamic> entry) {
    final trip = tripById(entry['_trip_id'] as String)!;
    final offered = entry['status'] == 'offered';
    final waiting = waitlist.where((w) => w['_trip_id'] == entry['_trip_id'] && w['status'] == 'waiting').toList();
    final secondsLeft = offered ? parse(entry['offer_expires_at']).difference(now()).inSeconds : null;
    return Map.of(entry)
      ..removeWhere((key, _) => key.startsWith('_'))
      ..['trip'] = tripRef(trip)
      ..['stop'] = stopOf(trip, entry['_stop_id'] as String)
      ..['position'] = entry['status'] == 'waiting' ? (entry['_position'] ?? waiting.indexOf(entry) + 1) : null
      ..['offer_seconds_left'] = secondsLeft == null ? null : (secondsLeft < 0 ? 0 : secondsLeft)
      ..['offer_amount'] = offered ? (trip['seat_price'] as int) * (entry['seats'] as int) : null;
  }

  /// What the backend's scheduled jobs would have done by now (J1 expiry, J2 offer expiry).
  void tick() {
    final t = now();
    for (final b in bookings.where((b) => b['status'] == 'pending_payment')) {
      if (t.isAfter(parse(b['hold_expires_at']))) {
        b['status'] = 'expired';
        addNotification(
          'booking_expired',
          'مهلة الدفع خلصت',
          'الحجز اتلغى والكرسي رجع متاح. تقدر تحجز تاني لو لسه فيه مكان.',
          {'screen': 'trip', 'trip_id': b['_trip_id']},
        );
      }
    }
    for (final w in waitlist.where((w) => w['status'] == 'offered')) {
      if (t.isAfter(parse(w['offer_expires_at']))) w['status'] = 'expired';
    }
  }

  void addNotification(String type, String title, String body, Map<String, dynamic> target) {
    notifications.insert(0, {
      'id': newId(),
      'type': type,
      'title': title,
      'body': body,
      'target': target,
      'sent_at': iso(now()),
      'read_at': null,
    });
  }
}
