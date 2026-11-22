import 'dart:async';

/// App-wide signal that the session ended (refresh token rejected).
/// The SessionCubit listens and sends the user back to login.
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  Stream<void> get onExpired => _expired.stream;

  void notifyExpired() => _expired.add(null);

  Future<void> dispose() => _expired.close();
}
