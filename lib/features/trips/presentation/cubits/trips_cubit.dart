import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/models/trip_enums.dart';
import '../../data/repositories/trips_repository.dart';
import 'trips_state.dart';

/// One per tab (outbound / return).
class TripsCubit extends Cubit<TripsState> {
  TripsCubit(this._repository, this.direction) : super(const TripsLoading());

  final TripsRepository _repository;
  final Direction direction;

  Future<void> load() async {
    emit(const TripsLoading());
    await refresh();
  }

  /// Keeps the current list visible while refreshing (pull to refresh).
  Future<void> refresh() async {
    final result = await _repository.listTrips(direction);
    switch (result) {
      case Success(:final data):
        emit(TripsLoaded(data.items));
      case Failure(:final failure):
        if (state is! TripsLoaded) emit(TripsError(failure));
    }
  }
}
