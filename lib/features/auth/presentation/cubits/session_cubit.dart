import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_failure.dart';
import '../../../../core/network/result.dart';
import '../../../../core/session/session_events.dart';
import '../../../account/data/repositories/account_repository.dart';
import '../../../notifications/data/repositories/push_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._auth, this._account, this._push, SessionEvents events) : super(const SessionUnknown()) {
    _expiredSub = events.onExpired.listen((_) => _signOutLocally(expired: true));
  }

  final AuthRepository _auth;
  final AccountRepository _account;
  final PushRepository _push;
  late final StreamSubscription<void> _expiredSub;

  /// Opens with the cached user right away (weak connections), then refreshes `/me`.
  Future<void> restore() async {
    final cached = await _auth.cachedUser();
    if (cached == null) return emit(const SessionUnauthenticated());
    _emitFor(cached);
    final result = await _account.getMe();
    switch (result) {
      case Success(:final data):
        _emitFor(data);
      case Failure(failure: SessionExpiredFailure()):
        _signOutLocally(expired: true);
      case Failure():
        break; // Offline: keep the cached user.
    }
  }

  void signedIn(UserModel user) => _emitFor(user);

  Future<void> logout() async {
    final deviceToken = await _push.currentToken();
    await _auth.logout(deviceToken: deviceToken);
    emit(const SessionUnauthenticated());
  }

  void _emitFor(UserModel user) {
    if (!user.emailVerified) return emit(SessionUnverified(user));
    final wasAuthenticated = state is SessionAuthenticated;
    emit(SessionAuthenticated(user));
    if (!wasAuthenticated) unawaited(_push.registerDevice());
  }

  void _signOutLocally({required bool expired}) {
    if (state is SessionUnauthenticated) return;
    emit(SessionUnauthenticated(expired: expired));
  }

  @override
  Future<void> close() async {
    await _expiredSub.cancel();
    return super.close();
  }
}
