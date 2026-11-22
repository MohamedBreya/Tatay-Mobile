import '../../data/models/trip_model.dart';

sealed class ReturnSuggestionsState {
  const ReturnSuggestionsState();
}

final class ReturnSuggestionsLoading extends ReturnSuggestionsState {
  const ReturnSuggestionsLoading();
}

/// Empty list or a failure both mean "show nothing": suggestions are optional.
final class ReturnSuggestionsLoaded extends ReturnSuggestionsState {
  const ReturnSuggestionsLoaded(this.trips);

  final List<TripModel> trips;
}
