import '../../../../core/network/api_failure.dart';

sealed class ForgotPasswordState {
  const ForgotPasswordState();
}

final class ForgotPasswordIdle extends ForgotPasswordState {
  const ForgotPasswordIdle();
}

final class ForgotPasswordSubmitting extends ForgotPasswordState {
  const ForgotPasswordSubmitting();
}

final class ForgotPasswordFailed extends ForgotPasswordState {
  const ForgotPasswordFailed(this.failure);

  final ApiFailure failure;
}

/// Same answer whether or not the email exists (BR-03).
final class ForgotPasswordSent extends ForgotPasswordState {
  const ForgotPasswordSent({required this.email, required this.resendInSeconds});

  final String email;
  final int resendInSeconds;
}
