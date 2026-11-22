import 'mock_database.dart';

/// Realistic data for the mock backend: one line from the village to the city, a week of
/// trips, and a demo passenger whose bookings cover every status the app has to show.
///
/// Demo logins: `demo@tatay.app` (or `01012345678`) / `password123` (verified),
/// `new@tatay.app` / `password123` (not verified). The OTP is always `123456`.
/// Vehicle QR texts: `TATAY-VEH-1` (today's trip) and `TATAY-VEH-2`.
abstract final class MockSeed {
  static const _lineId = '0b9a7e10-0000-4000-8000-000000000001';
  static const _villageStops = ['قدام الجامع', 'المدرسة', 'الكوبري'];
  static const _cityStops = ['موقف المدينة', 'ميدان المحطة'];
  static const _vehicles = [
    {'plate': 'ن ق ل 1234', 'qr': 'TATAY-VEH-1', 'type': 'ميكروباص تويوتا هاي إس'},
    {'plate': 'م ص ر 5678', 'qr': 'TATAY-VEH-2', 'type': 'ميكروباص كينج لونج'},
  ];

  static void populate(MockDatabase db) {
    db.config.addAll({
      'payment_account_number': '01001234567',
      'support_phone': '01009876543',
      'payment_hold_minutes': 15,
      'waitlist_offer_minutes': 5,
      'booking_close_minutes': 60,
      'max_seats_per_booking': 2,
      'boarding_wait_minutes': 5,
      'scan_window_minutes': 15,
      'refund_hours': 48,
      'policies': {
        'no_cancellation': 'مفيش إلغاء للحجز بعد التأكيد.',
        'boarding_wait': 'العربية بتستنى 5 دقايق بس عند كل نقطة.',
        'no_show': 'اللي ميركبش في ميعاده ميستردش فلوسه.',
      },
    });
    final demo = _user(db, 'محمد أحمد', '01012345678', 'demo@tatay.app', verified: true);
    _user(db, 'سارة علي', '01198765432', 'new@tatay.app', verified: false);
    db.currentUserId = demo['id'] as String;
    if (db.behavior.isEmpty) return;

    final now = db.now();
    final cairoMidnight = DateTime.utc(
      now.add(const Duration(hours: 2)).year,
      now.add(const Duration(hours: 2)).month,
      now.add(const Duration(hours: 2)).day,
    ).subtract(const Duration(hours: 2));
    var index = 0;
    for (var day = 0; day < 7; day++) {
      final midnight = cairoMidnight.add(Duration(days: day));
      for (final (direction, hour, minute) in [
        ('outbound', 6, 30),
        ('outbound', 7, 30),
        ('return', 14, 30),
        ('return', 16, 30),
      ]) {
        final departure = midnight.add(Duration(hours: hour, minutes: minute));
        if (departure.subtract(const Duration(hours: 1)).isBefore(now)) {
          continue;
        }
        final full = index % 5 == 2;
        _trip(
          db,
          direction,
          departure,
          taken: full ? 14 : 3 + (index * 7) % 9,
          confirmed: day <= 1,
          vehicle: index % 2 + 1,
        );
        index++;
      }
    }
    _demoBookings(db, demo['id'] as String, now);
  }

  static void _demoBookings(MockDatabase db, String userId, DateTime now) {
    final live = _trip(db, 'outbound', now.add(const Duration(minutes: 5)), taken: 9, confirmed: true, vehicle: 1);
    _booking(db, userId, live, 'confirmed', seats: 1, paymentMethod: 'transfer');

    final upcoming = db.trips.where((t) => t['_status'] != 'completed' && t['_taken'] != 14).toList();
    if (upcoming.length > 3) {
      _booking(db, userId, upcoming[1], 'pending_review', seats: 2)['proof_uploaded_at'] = MockDatabase.iso(
        now.subtract(const Duration(minutes: 20)),
      );
      _booking(db, userId, upcoming[3], 'pending_payment', seats: 1)['hold_expires_at'] = MockDatabase.iso(
        now.add(const Duration(minutes: 12)),
      );
    }

    final full = db.trips.where((t) => t['_taken'] == 14).toList();
    if (full.length > 1) {
      _entry(db, userId, full[0], 'offered', seats: 1)['offer_expires_at'] = MockDatabase.iso(
        now.add(const Duration(minutes: 4, seconds: 30)),
      );
      _entry(db, userId, full[1], 'waiting', seats: 2)['_position'] = 3;
      db.addNotification('waitlist_offer', 'فيه كرسي فضي ليك', 'قدامك 5 دقايق تحجزه.', {
        'screen': 'waitlist_offer',
        'waitlist_entry_id': db.waitlist.first['id'],
        'trip_id': full[0]['id'],
      });
    }

    final cancelled = _trip(
      db,
      'outbound',
      now.subtract(const Duration(days: 1)),
      taken: 4,
      confirmed: true,
      vehicle: 2,
      status: 'cancelled',
    );
    _booking(db, userId, cancelled, 'refund_due', seats: 1, paymentMethod: 'transfer')
      ..['refund_amount'] = 5000
      ..['refund_due_at'] = MockDatabase.iso(now.add(const Duration(hours: 30)));
    final done = _trip(
      db,
      'return',
      now.subtract(const Duration(days: 3)),
      taken: 12,
      confirmed: true,
      vehicle: 1,
      status: 'completed',
    );
    _booking(db, userId, done, 'boarded', seats: 2, paymentMethod: 'transfer')
      ..['boarded_at'] = done['departure_at']
      ..['boarding_method'] = 'qr';
    final missed = _trip(
      db,
      'outbound',
      now.subtract(const Duration(days: 4)),
      taken: 10,
      confirmed: true,
      vehicle: 2,
      status: 'completed',
    );
    _booking(db, userId, missed, 'expired', seats: 1);

    db.addNotification('trip_cancelled', 'رحلتك اتلغت', 'آسفين. فلوسك (50 جنيه) هترجعلك خلال 48 ساعة.', {
      'screen': 'booking',
      'booking_id': db.bookings.firstWhere((b) => b['status'] == 'refund_due')['id'],
    });
    db.addNotification('booking_confirmed', 'حجزك اتأكد', 'امسح الكود اللي في العربية وانت راكب.', {
      'screen': 'booking',
      'booking_id': db.bookings.first['id'],
    });
    db.notifications.last['read_at'] = MockDatabase.iso(now.subtract(const Duration(hours: 5)));
  }

  static Map<String, dynamic> _user(
    MockDatabase db,
    String name,
    String phone,
    String email, {
    required bool verified,
  }) {
    final user = {
      'id': db.newId(),
      'role': 'passenger',
      'name': name,
      'phone': phone,
      'email': email,
      'email_verified': verified,
      'created_at': MockDatabase.iso(db.now()),
      '_password': 'password123',
    };
    db.users.add(user);
    return user;
  }

  static Map<String, dynamic> _trip(
    MockDatabase db,
    String direction,
    DateTime departure, {
    required int taken,
    required bool confirmed,
    required int vehicle,
    String? status,
  }) {
    final names = direction == 'outbound' ? _villageStops : _cityStops;
    final v = _vehicles[vehicle - 1];
    final trip = <String, dynamic>{
      'id': db.newId(),
      'line_id': _lineId,
      'direction': direction,
      'departure_at': MockDatabase.iso(departure),
      'arrival_point': direction == 'outbound' ? 'موقف المدينة' : 'القرية - قدام الجامع',
      'stops': [
        for (var i = 0; i < names.length; i++)
          {
            'id': db.newId(),
            'sequence': i + 1,
            'name': names[i],
            'not_operated': false,
            'scheduled_at': MockDatabase.iso(departure.add(Duration(minutes: i * 10))),
          },
      ],
      'seat_price': 5000,
      'seat_count': 14,
      'min_passengers': 8,
      'is_confirmed': confirmed,
      'line_name': 'القرية - المدينة',
      'vehicle_type': v['type'],
      'vehicle_plate_number': v['plate'],
      'booking_closes_at': MockDatabase.iso(departure.subtract(const Duration(hours: 1))),
      '_status': status ?? (confirmed ? 'confirmed' : 'scheduled'),
      '_taken': taken,
      '_qr': v['qr'],
    };
    db.trips.add(trip);
    return trip;
  }

  static Map<String, dynamic> _booking(
    MockDatabase db,
    String userId,
    Map<String, dynamic> trip,
    String status, {
    required int seats,
    String? paymentMethod,
  }) {
    final stop = (trip['stops'] as List).first as Map<String, dynamic>;
    final at = DateTime.parse(stop['scheduled_at'] as String);
    final booking = <String, dynamic>{
      'id': db.newId(),
      'source': 'app',
      'seats': seats,
      'amount': (trip['seat_price'] as int) * seats,
      'status': status,
      'created_at': MockDatabase.iso(db.now().subtract(const Duration(hours: 2))),
      'hold_expires_at': null,
      'payment_method': paymentMethod,
      'proof_uploaded_at': null,
      'reject_reason': null,
      'boarded_at': null,
      'boarding_method': null,
      'scan_window_opens_at': MockDatabase.iso(at.subtract(const Duration(minutes: 15))),
      'scan_window_closes_at': MockDatabase.iso(at.add(const Duration(minutes: 15))),
      'refund_amount': null,
      'refund_due_at': null,
      'refunded_at': null,
      'refund_reference': null,
      '_trip_id': trip['id'],
      '_stop_id': stop['id'],
      '_user_id': userId,
    };
    db.bookings.add(booking);
    return booking;
  }

  static Map<String, dynamic> _entry(
    MockDatabase db,
    String userId,
    Map<String, dynamic> trip,
    String status, {
    required int seats,
  }) {
    final entry = <String, dynamic>{
      'id': db.newId(),
      'seats': seats,
      'status': status,
      'joined_at': MockDatabase.iso(db.now()),
      'offered_at': status == 'offered' ? MockDatabase.iso(db.now()) : null,
      'offer_expires_at': null,
      'booking_id': null,
      '_trip_id': trip['id'],
      '_stop_id': ((trip['stops'] as List).first as Map)['id'],
      '_user_id': userId,
    };
    db.waitlist.add(entry);
    return entry;
  }
}
