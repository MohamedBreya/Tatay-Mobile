import 'dart:async';

import '../../../account/data/repositories/account_repository.dart';
import '../datasources/push_data_source.dart';
import '../models/opened_push_model.dart';

/// Keeps the backend in sync with this device's push token and exposes taps.
class PushRepository {
  PushRepository(this._push, this._account);

  final PushDataSource _push;
  final AccountRepository _account;
  StreamSubscription<String>? _refreshSub;
  bool _initialized = false;

  Stream<OpenedPushModel> get onOpened => _push.onOpened;

  Stream<void> get onForegroundMessage => _push.onForegroundMessage;

  Future<OpenedPushModel?> initialMessage() => _push.initialMessage();

  Future<void> initialize({required String channelName, required String channelDescription}) async {
    if (_initialized) return;
    _initialized = true;
    await _push.initialize(channelName: channelName, channelDescription: channelDescription);
  }

  /// After login, and again whenever FCM rotates the token.
  Future<void> registerDevice() async {
    final token = await _push.getToken();
    if (token != null) await _account.registerDevice(token);
    _refreshSub ??= _push.onTokenRefresh.listen(_account.registerDevice);
  }

  Future<String?> currentToken() async {
    await _refreshSub?.cancel();
    _refreshSub = null;
    return _push.getToken();
  }
}
