import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/bookings_repository.dart';
import 'booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  BookingDetailsCubit(this._repository, {required this.bookingId}) : super(const BookingDetailsLoading());

  final BookingsRepository _repository;
  final String bookingId;
  Timer? _ticker;

  Future<void> load() async {
    if (state is! BookingDetailsLoaded) emit(const BookingDetailsLoading());
    final result = await _repository.getBooking(bookingId);
    switch (result) {
      case Success(:final data):
        final now = DateTime.now();
        emit(BookingDetailsLoaded(booking: data, loadedAt: now, now: now));
        _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
      case Failure(:final failure):
        if (state is! BookingDetailsLoaded) emit(BookingDetailsError(failure));
    }
  }

  void _tick() {
    final current = state;
    if (current is! BookingDetailsLoaded) return;
    final next = BookingDetailsLoaded(booking: current.booking, loadedAt: current.loadedAt, now: DateTime.now());
    emit(next);
    // The hold just ran out: the server decides what the booking became.
    if (current.secondsLeft != null && current.secondsLeft! > 0 && next.secondsLeft == 0) {
      unawaited(load());
    }
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
