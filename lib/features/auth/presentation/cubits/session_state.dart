import '../../data/models/user_model.dart';

/// Who is using the app. The router redirects on every change.
sealed class SessionState {
  const SessionState();
}

/// Restoring the saved session at launch.
final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated({this.expired = false});

  /// True when the refresh token was rejected (show "log in again").
  final bool expired;
}

/// Logged in, but the email is not verified yet: only the OTP screen is reachable.
final class SessionUnverified extends SessionState {
  const SessionUnverified(this.user);

  final UserModel user;
}

final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated(this.user);

  final UserModel user;
}
