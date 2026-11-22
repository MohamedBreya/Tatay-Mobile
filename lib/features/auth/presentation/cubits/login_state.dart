import '../../../../core/network/api_failure.dart';
import '../../data/models/user_model.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginIdle extends LoginState {
  const LoginIdle();
}

final class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

final class LoginFailed extends LoginState {
  const LoginFailed(this.failure);

  final ApiFailure failure;
}

final class LoginSucceeded extends LoginState {
  const LoginSucceeded(this.user);

  final UserModel user;
}
