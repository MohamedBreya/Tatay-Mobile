import '../network/api_failure.dart';

/// The status of a one-off user action (submit, upload, accept...).
sealed class ActionStatus {
  const ActionStatus();
}

final class ActionIdle extends ActionStatus {
  const ActionIdle();
}

final class ActionInProgress extends ActionStatus {
  const ActionInProgress();
}

final class ActionFailed extends ActionStatus {
  const ActionFailed(this.failure);

  final ApiFailure failure;
}

final class ActionSucceeded extends ActionStatus {
  const ActionSucceeded();
}
