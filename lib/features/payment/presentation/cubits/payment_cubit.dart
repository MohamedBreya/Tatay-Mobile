import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_code.dart';
import '../../../../core/network/api_failure.dart';
import '../../../../core/network/result.dart';
import '../../../../core/state/action_status.dart';
import '../../../bookings/data/models/booking_enums.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../bookings/data/repositories/bookings_repository.dart';
import '../../data/datasources/proof_image_data_source.dart';
import '../../data/repositories/payment_repository.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this._bookings, this._payment, {required this.bookingId}) : super(const PaymentLoading());

  final BookingsRepository _bookings;
  final PaymentRepository _payment;
  final String bookingId;
  Timer? _ticker;

  /// True while the picker is open or an upload runs: resume refreshes must not interfere.
  bool _busy = false;

  Future<void> load() async {
    if (state is! PaymentAwaiting) emit(const PaymentLoading());
    final result = await _bookings.getBooking(bookingId);
    switch (result) {
      case Success(:final data):
        _show(data);
      case Failure(:final failure):
        if (state is! PaymentAwaiting) emit(PaymentError(failure));
    }
  }

  /// The phone clock may be wrong: after the app was in the background, ask the server again.
  Future<void> onResumed() async {
    if (_busy || state is! PaymentAwaiting) return;
    await load();
  }

  Future<void> pickAndUpload(ProofImageOrigin origin) async {
    if (_busy || state is! PaymentAwaiting) return;
    _busy = true;
    try {
      final file = await _payment.pickProof(origin);
      final current = state;
      if (file == null || current is! PaymentAwaiting) return;
      emit(current.copyWith(upload: const ActionInProgress()));
      final result = await _payment.uploadProof(bookingId, file);
      switch (result) {
        case Success(:final data):
          _show(data);
        case Failure(failure: ServerFailure(code: ApiErrorCode.holdExpired)):
          _stopTicker();
          emit(const PaymentExpired());
        case Failure(failure: ServerFailure(code: ApiErrorCode.invalidState)):
          _busy = false;
          await load();
        case Failure(:final failure):
          final latest = state;
          if (latest is PaymentAwaiting) {
            emit(latest.copyWith(upload: ActionFailed(failure)));
          }
      }
    } finally {
      _busy = false;
    }
  }

  void _show(BookingModel booking) {
    _stopTicker();
    switch (booking.status) {
      case BookingStatus.pendingPayment:
        final seconds = booking.secondsLeft ?? 0;
        if (seconds <= 0) return emit(const PaymentExpired());
        emit(PaymentAwaiting(booking: booking, secondsLeft: seconds));
        _startTicker();
      case BookingStatus.pendingReview:
        emit(PaymentSubmitted(booking));
      case BookingStatus.expired:
        emit(const PaymentExpired());
      default:
        emit(PaymentNotPayable(booking));
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is! PaymentAwaiting) return _stopTicker();
      final next = current.secondsLeft - 1;
      if (next > 0) return emit(current.copyWith(secondsLeft: next));
      _stopTicker();
      // At zero, let the server decide: it may still accept a screenshot sent this second.
      if (!_busy) unawaited(load());
    });
  }

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
