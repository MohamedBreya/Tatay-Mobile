import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/opened_push_model.dart';
import 'push_data_source.dart';

/// FCM + a local notification for pushes that arrive while the app is open
/// (Android does not show those by itself). N10 is sent high priority by the server.
class PushFirebaseDataSource implements PushDataSource {
  final _local = FlutterLocalNotificationsPlugin();
  final _opened = StreamController<OpenedPushModel>.broadcast();
  final _foreground = StreamController<void>.broadcast();
  AndroidNotificationChannel? _channel;

  static const _channelId = 'tatay_bookings';

  @override
  Future<void> initialize({required String channelName, required String channelDescription}) async {
    await Firebase.initializeApp();
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    _channel = AndroidNotificationChannel(
      _channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );
    await _local.initialize(
      settings: const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      onDidReceiveNotificationResponse: (response) => _emitPayload(response.payload),
    );
    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel!);

    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _opened.add(OpenedPushModel.fromData(m.data)));
  }

  @override
  Future<String?> getToken() async {
    try {
      // The backend sends with Firebase Admin to classic registration tokens, so the app keeps
      // using them instead of the newer FID-based register()/onRegistered API.
      // ignore: deprecated_member_use
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('FCM token unavailable: $e');
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh =>
      // ignore: deprecated_member_use
      FirebaseMessaging.instance.onTokenRefresh;

  @override
  Stream<void> get onForegroundMessage => _foreground.stream;

  @override
  Stream<OpenedPushModel> get onOpened => _opened.stream;

  @override
  Future<OpenedPushModel?> initialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) return OpenedPushModel.fromData(message.data);
    final launch = await _local.getNotificationAppLaunchDetails();
    final payload = launch?.notificationResponse?.payload;
    if (launch?.didNotificationLaunchApp != true || payload == null) {
      return null;
    }
    return OpenedPushModel.fromData(jsonDecode(payload) as Map<String, dynamic>);
  }

  Future<void> _showForeground(RemoteMessage message) async {
    _foreground.add(null);
    final notification = message.notification;
    final channel = _channel;
    if (notification == null || channel == null) return;
    await _local.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      payload: jsonEncode(message.data),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  void _emitPayload(String? payload) {
    if (payload == null) return;
    _opened.add(OpenedPushModel.fromData(jsonDecode(payload) as Map<String, dynamic>));
  }
}
