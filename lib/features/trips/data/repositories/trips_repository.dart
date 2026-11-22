import '../../../../core/network/paged_model.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/safe_call.dart';
import '../datasources/trips_data_source.dart';
import '../models/trip_enums.dart';
import '../models/trip_model.dart';

class TripsRepository {
  TripsRepository(this._source);

  final TripsDataSource _source;

  static const pageSize = 50;

  /// Bookable trips for the coming 7 days in one direction.
  Future<Result<PagedModel<TripModel>>> listTrips(Direction direction, {int page = 1}) {
    final now = DateTime.now().toUtc();
    return safeCall(
      () => _source.listTrips(
        direction: direction == Direction.returnTrip ? 'return' : 'outbound',
        from: now.toIso8601String(),
        to: now.add(const Duration(days: 7)).toIso8601String(),
        page: page,
        perPage: pageSize,
      ),
    );
  }

  Future<Result<TripModel>> getTrip(String tripId) => safeCall(() => _source.getTrip(tripId));

  Future<Result<List<TripModel>>> getReturnSuggestions(String outboundTripId) =>
      safeCall(() async => (await _source.getReturnSuggestions(outboundTripId)).items);
}
