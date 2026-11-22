import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_code.dart';
import '../../../../core/network/api_failure.dart';
import '../../../../core/network/result.dart';
import '../../../../core/state/action_status.dart';
import '../../../trips/data/models/trip_enums.dart';
import '../../data/models/waitlist_entry_model.dart';
import '../../data/repositories/waitlist_repository.dart';
import 'waitlist_offer_state.dart';

/// The N10 screen. The push is only a hint: the entry is always fetched fresh.
class WaitlistOfferCubit extends Cubit<WaitlistOfferState> {
  WaitlistOfferCubit(this._repository, {required this.entryId}) : super(const WaitlistOfferLoading());

  final WaitlistRepository _repository;
  final String entryId;
  Timer? _ticker;

  Future<void> load() async {
    if (state is! WaitlistOfferOpen) emit(const WaitlistOfferLoading());
    final result = await _repository.getEntry(entryId);
    switch (result) {
      case Success(:final data):
        _show(data);
      case Failure(:final failure):
        if (state is! WaitlistOfferOpen) emit(WaitlistOfferError(failure));
    }
  }

  Future<void> accept() => _act((open) async {
    final result = await _repository.accept(entryId);
    return switch (result) {
      Success(:final data) => WaitlistOfferAccepted(data),
      Failure(failure: ServerFailure(code: ApiErrorCode.offerExpired)) => const WaitlistOfferClosed(),
      Failure(:final failure) => open.copyWith(action: ActionFailed(failure)),
    };
  });

  Future<void> decline() => _act((open) async {
    final result = await _repository.decline(entryId);
    return switch (result) {
      Success() => const WaitlistOfferDeclined(),
      Failure(failure: ServerFailure(code: ApiErrorCode.offerExpired)) => const WaitlistOfferClosed(),
      Failure(:final failure) => open.copyWith(action: ActionFailed(failure)),
    };
  });

  Future<void> _act(Future<WaitlistOfferState> Function(WaitlistOfferOpen open) action) async {
    final current = state;
    if (current is! WaitlistOfferOpen || current.action is ActionInProgress) return;
    emit(current.copyWith(action: const ActionInProgress()));
    final next = await action(current);
    if (next is! WaitlistOfferOpen) _stopTicker();
    emit(next is WaitlistOfferOpen ? next.copyWith(secondsLeft: _secondsLeftNow()) : next);
  }

  void _show(WaitlistEntryModel entry) {
    _stopTicker();
    final seconds = entry.offerSecondsLeft ?? 0;
    if (entry.status != WaitlistStatus.offered || seconds <= 0) {
      return emit(WaitlistOfferClosed(bookingId: entry.bookingId));
    }
    emit(WaitlistOfferOpen(entry: entry, secondsLeft: seconds));
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is! WaitlistOfferOpen) return _stopTicker();
      if (current.secondsLeft > 1) return emit(current.copyWith(secondsLeft: current.secondsLeft - 1));
      _stopTicker();
      unawaited(load());
    });
  }

  int _secondsLeftNow() => switch (state) {
    WaitlistOfferOpen(:final secondsLeft) => secondsLeft,
    _ => 0,
  };

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
