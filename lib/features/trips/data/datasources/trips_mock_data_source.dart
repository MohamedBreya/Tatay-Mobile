import '../../../../core/mock/mock_api_error.dart';
import '../../../../core/mock/mock_database.dart';
import '../../../../core/network/paged_model.dart';
import '../models/trip_list_model.dart';
import '../models/trip_model.dart';
import 'trips_data_source.dart';

class TripsMockDataSource implements TripsDataSource {
  TripsMockDataSource(this._db);

  final MockDatabase _db;

  @override
  Future<PagedModel<TripModel>> listTrips({
    String? direction,
    String? from,
    String? to,
    int? page,
    int? perPage,
  }) async {
    await _db.behavior.latency();
    _db.tick();
    final p = page ?? 1;
    final size = perPage ?? 20;
    final all = _bookable().where((t) => direction == null || t['direction'] == direction).toList()
      ..sort((a, b) => (a['departure_at'] as String).compareTo(b['departure_at'] as String));
    final items = all.skip((p - 1) * size).take(size).map((t) => TripModel.fromJson(_db.tripJson(t))).toList();
    return PagedModel(items: items, page: p, perPage: size, total: all.length);
  }

  @override
  Future<TripModel> getTrip(String tripId) async {
    await _db.behavior.latency();
    _db.tick();
    final trip = _db.tripById(tripId);
    if (trip == null) {
      throw MockApiError.server(404, 'NOT_FOUND', 'الرحلة دي مش موجودة.');
    }
    return TripModel.fromJson(_db.tripJson(trip));
  }

  @override
  Future<TripListModel> getReturnSuggestions(String tripId) async {
    await _db.behavior.latency();
    final outbound = _db.tripById(tripId);
    if (outbound == null) {
      throw MockApiError.server(404, 'NOT_FOUND', 'الرحلة دي مش موجودة.');
    }
    final day = (outbound['departure_at'] as String).substring(0, 10);
    final items = _bookable()
        .where((t) => t['direction'] == 'return' && (t['departure_at'] as String).startsWith(day))
        .map((t) => TripModel.fromJson(_db.tripJson(t)))
        .toList();
    return TripListModel(items: items);
  }

  /// Scheduled and confirmed trips that have not left yet.
  Iterable<Map<String, dynamic>> _bookable() => _db.trips.where(
    (t) =>
        (t['_status'] == 'scheduled' || t['_status'] == 'confirmed') &&
        MockDatabase.parse(t['departure_at']).isAfter(_db.now()),
  );
}
