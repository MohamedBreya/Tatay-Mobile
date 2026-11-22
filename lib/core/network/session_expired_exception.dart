/// Thrown when the refresh token is rejected. The user must log in again.
class SessionExpiredException implements Exception {
  const SessionExpiredException();
}
