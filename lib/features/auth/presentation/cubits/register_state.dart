import '../../../../core/network/api_failure.dart';

sealed class RegisterState {
  const RegisterState();
}

final class RegisterIdle extends RegisterState {
  const RegisterIdle();
}

final class RegisterSubmitting extends RegisterState {
  const RegisterSubmitting();
}

final class RegisterFailed extends RegisterState {
  const RegisterFailed(this.failure);

  final ApiFailure failure;
}

/// The account exists but is not active until the emailed OTP is entered.
final class RegisterSucceeded extends RegisterState {
  const RegisterSucceeded({required this.email, required this.resendInSeconds});

  final String email;
  final int resendInSeconds;
}
