import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/trips_repository.dart';
import 'return_suggestions_state.dart';

/// Return trips on the same day, suggested after an outbound booking (not linked to it).
class ReturnSuggestionsCubit extends Cubit<ReturnSuggestionsState> {
  ReturnSuggestionsCubit(this._repository) : super(const ReturnSuggestionsLoading());

  final TripsRepository _repository;

  Future<void> load(String outboundTripId) async {
    final result = await _repository.getReturnSuggestions(outboundTripId);
    emit(
      ReturnSuggestionsLoaded(switch (result) {
        Success(:final data) => data.where((t) => t.myBookingId == null).toList(),
        Failure() => const [],
      }),
    );
  }
}
