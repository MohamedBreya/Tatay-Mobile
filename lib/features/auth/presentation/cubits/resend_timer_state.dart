import '../../../../core/network/api_failure.dart';

/// The "send the code again" button: counting down, ready, or sending.
sealed class ResendTimerState {
  const ResendTimerState();
}

final class ResendCountingDown extends ResendTimerState {
  const ResendCountingDown(this.secondsLeft);

  final int secondsLeft;
}

final class ResendReady extends ResendTimerState {
  const ResendReady({this.failure});

  /// Set when the last resend attempt failed.
  final ApiFailure? failure;
}

final class ResendSending extends ResendTimerState {
  const ResendSending();
}
