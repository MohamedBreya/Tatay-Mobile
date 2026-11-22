import '../../../../core/network/api_failure.dart';
import '../../data/models/user_model.dart';

sealed class VerifyEmailState {
  const VerifyEmailState();
}

final class VerifyEmailIdle extends VerifyEmailState {
  const VerifyEmailIdle();
}

final class VerifyEmailSubmitting extends VerifyEmailState {
  const VerifyEmailSubmitting();
}

final class VerifyEmailFailed extends VerifyEmailState {
  const VerifyEmailFailed(this.failure);

  final ApiFailure failure;
}

final class VerifyEmailSucceeded extends VerifyEmailState {
  const VerifyEmailSucceeded(this.user);

  final UserModel user;
}
