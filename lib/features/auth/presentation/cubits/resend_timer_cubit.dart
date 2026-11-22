import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_code.dart';
import '../../../../core/network/api_failure.dart';
import '../../../../core/network/result.dart';
import '../../data/models/auth_requests.dart';
import '../../data/repositories/auth_repository.dart';
import 'resend_timer_state.dart';

/// Drives the OTP resend cooldown from the server's `resend_available_in_seconds`
/// (or `retry_after_seconds` when rate limited).
class ResendTimerCubit extends Cubit<ResendTimerState> {
  ResendTimerCubit(this._auth, {required this.email, required this.purpose}) : super(const ResendReady());

  final AuthRepository _auth;
  final String email;
  final OtpPurpose purpose;
  Timer? _timer;

  void startCountdown(int seconds) {
    _timer?.cancel();
    if (seconds <= 0) return emit(const ResendReady());
    var left = seconds;
    emit(ResendCountingDown(left));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      left--;
      if (left <= 0) {
        timer.cancel();
        emit(const ResendReady());
      } else {
        emit(ResendCountingDown(left));
      }
    });
  }

  /// Returns true when a new code was sent.
  Future<bool> resend() async {
    if (state is! ResendReady) return false;
    emit(const ResendSending());
    final result = await _auth.resendOtp(email: email, purpose: purpose);
    switch (result) {
      case Success(:final data):
        startCountdown(data.resendAvailableInSeconds);
        return true;
      case Failure(failure: final ServerFailure f) when f.code == ApiErrorCode.otpTooMany:
        startCountdown(f.detailInt('retry_after_seconds') ?? 60);
        return false;
      case Failure(:final failure):
        emit(ResendReady(failure: failure));
        return false;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
