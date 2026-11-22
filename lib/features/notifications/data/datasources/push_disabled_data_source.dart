import '../models/opened_push_model.dart';
import 'push_data_source.dart';

/// Used when `PUSH_ENABLED` is false (mock runs, or no Firebase config yet).
/// Notifications still reach the passenger through the in-app notifications list.
class PushDisabledDataSource implements PushDataSource {
  @override
  Future<void> initialize({required String channelName, required String channelDescription}) async {}

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<void> get onForegroundMessage => const Stream.empty();

  @override
  Stream<OpenedPushModel> get onOpened => const Stream.empty();

  @override
  Future<OpenedPushModel?> initialMessage() async => null;
}
