import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/models/booking_enums.dart';
import '../../data/repositories/bookings_repository.dart';
import 'my_bookings_state.dart';

/// One per tab (current / past), paged.
class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit(this._repository, this.scope) : super(const MyBookingsLoading());

  final BookingsRepository _repository;
  final BookingScope scope;

  Future<void> load() async {
    emit(const MyBookingsLoading());
    await refresh();
  }

  Future<void> refresh() async {
    final result = await _repository.listMyBookings(scope);
    switch (result) {
      case Success(:final data):
        emit(MyBookingsLoaded(items: data.items, page: 1, hasMore: data.hasMore));
      case Failure(:final failure):
        if (state is! MyBookingsLoaded) emit(MyBookingsError(failure));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MyBookingsLoaded || !current.hasMore || current.loadingMore) {
      return;
    }
    emit(current.copyWith(loadingMore: true));
    final result = await _repository.listMyBookings(scope, page: current.page + 1);
    emit(switch (result) {
      Success(:final data) => current.copyWith(
        items: [...current.items, ...data.items],
        page: current.page + 1,
        hasMore: data.hasMore,
        loadingMore: false,
      ),
      Failure() => current.copyWith(loadingMore: false),
    });
  }
}
