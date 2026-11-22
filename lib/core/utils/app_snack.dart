import 'package:flutter/material.dart';

import '../network/api_failure.dart';
import 'failure_message.dart';

abstract final class AppSnack {
  /// Set on MaterialApp, so snackbars also work from contexts above it (app-wide listeners).
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(BuildContext context, String message) {
    (messengerKey.currentState ?? ScaffoldMessenger.of(context))
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static void failure(BuildContext context, ApiFailure failure) => show(context, failureMessage(failure));
}
