import '../../../../core/mock/mock_api_error.dart';
import '../../../../core/mock/mock_database.dart';
import '../models/scan_request.dart';
import '../models/scan_result_model.dart';
import 'boarding_data_source.dart';

/// Mirrors the BR-40 checks in order: QR valid, booking today, vehicle, window, payment.
class BoardingMockDataSource implements BoardingDataSource {
  BoardingMockDataSource(this._db);

  final MockDatabase _db;

  @override
  Future<ScanResultModel> scan(String idempotencyKey, ScanRequest body) async {
    await _db.behavior.latency();
    final qr = body.qrToken.trim();
    if (!_db.trips.any((t) => t['_qr'] == qr)) {
      throw MockApiError.server(400, 'QR_INVALID', 'الكود ده مش بتاعنا.');
    }
    final now = _db.now();
    final today = _db.bookings.where((b) => b['_user_id'] == _db.currentUserId).where((b) {
      final trip = _db.tripById(b['_trip_id'] as String)!;
      final departure = MockDatabase.parse(trip['departure_at']);
      return trip['_status'] == 'confirmed' &&
          departure.difference(now).inHours.abs() < 12 &&
          {'confirmed', 'boarded', 'pending_review'}.contains(b['status']);
    }).toList();
    if (today.isEmpty) throw MockApiError.server(404, 'NO_BOOKING', 'معندكش حجز مؤكد النهارده.');

    bool inWindow(Map<String, dynamic> b) => now.difference(_stopTime(b)).inMinutes.abs() <= 15;
    String qrOf(Map<String, dynamic> b) => _db.tripById(b['_trip_id'] as String)!['_qr'] as String;
    final booking = today.where((b) => inWindow(b) && qrOf(b) == qr).firstOrNull;
    if (booking == null) {
      final elsewhere = today.where(inWindow).firstOrNull;
      if (elsewhere != null) {
        final plate = _db.tripById(elsewhere['_trip_id'] as String)!['vehicle_plate_number'];
        throw MockApiError.server(409, 'WRONG_VEHICLE', 'دي مش عربيتك. عربيتك رقمها $plate.');
      }
      throw MockApiError.server(409, 'OUTSIDE_WINDOW', 'لسه بدري أو الوقت عدى على ميعاد نقطتك.');
    }
    final trip = _db.tripById(booking['_trip_id'] as String)!;
    final stop = _db.stopOf(trip, booking['_stop_id'] as String);
    if (booking['status'] == 'pending_review') {
      throw MockApiError.server(409, 'PAYMENT_NOT_CONFIRMED', 'دفعك لسه في المراجعة. كلّم الأدمن.');
    }
    final already = booking['status'] == 'boarded';
    booking
      ..['status'] = 'boarded'
      ..['boarded_at'] = booking['boarded_at'] ?? MockDatabase.iso(now)
      ..['boarding_method'] = booking['boarding_method'] ?? 'qr';
    final user = _db.userById(_db.currentUserId)!;
    return ScanResultModel(
      bookingId: booking['id'] as String,
      seats: booking['seats'] as int,
      passengerName: user['name'] as String,
      stopName: stop['name'] as String,
      vehiclePlateNumber: trip['vehicle_plate_number'] as String,
      alreadyBoarded: already,
    );
  }

  DateTime _stopTime(Map<String, dynamic> booking) {
    final trip = _db.tripById(booking['_trip_id'] as String)!;
    return MockDatabase.parse(_db.stopOf(trip, booking['_stop_id'] as String)['scheduled_at']);
  }
}
