import '../../../../core/network/api_failure.dart';
import '../../../../core/utils/app_format.dart';
import '../../data/models/trip_model.dart';

sealed class TripsState {
  const TripsState();
}

final class TripsLoading extends TripsState {
  const TripsLoading();
}

final class TripsLoaded extends TripsState {
  const TripsLoaded(this.trips);

  final List<TripModel> trips;

  /// Trips grouped by Cairo calendar day, in departure order.
  Map<DateTime, List<TripModel>> get byDay {
    final groups = <DateTime, List<TripModel>>{};
    for (final trip in trips) {
      groups.putIfAbsent(AppFormat.cairoDay(trip.departureAt), () => []).add(trip);
    }
    return groups;
  }
}

final class TripsError extends TripsState {
  const TripsError(this.failure);

  final ApiFailure failure;
}
