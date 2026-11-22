import '../../../../core/network/paged_model.dart';
import '../models/trip_list_model.dart';
import '../models/trip_model.dart';

abstract interface class TripsDataSource {
  /// [direction] is the wire value: `outbound` or `return`.
  Future<PagedModel<TripModel>> listTrips({String? direction, String? from, String? to, int? page, int? perPage});

  Future<TripModel> getTrip(String tripId);

  Future<TripListModel> getReturnSuggestions(String tripId);
}
