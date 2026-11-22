import '../models/opened_push_model.dart';

/// Receives push messages from the platform (FCM on Android).
abstract interface class PushDataSource {
  Future<void> initialize({required String channelName, required String channelDescription});

  Future<String?> getToken();

  Stream<String> get onTokenRefresh;

  /// A push arrived while the app is open (refresh badges and lists).
  Stream<void> get onForegroundMessage;

  /// The passenger tapped a notification while the app was running or in the background.
  Stream<OpenedPushModel> get onOpened;

  /// The notification that launched the app from a terminated state, if any.
  Future<OpenedPushModel?> initialMessage();
}
