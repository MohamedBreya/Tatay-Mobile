import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/di/injection.dart';
import '../core/utils/app_snack.dart';
import '../features/auth/presentation/cubits/session_state.dart';
import '../features/config/presentation/cubits/config_cubit.dart';
import '../features/notifications/presentation/cubits/notifications_cubit.dart';
import '../generated/locale_keys.g.dart';

/// What happens app-wide when the session changes.
abstract final class SessionEffects {
  static void onChange(BuildContext context, SessionState state) {
    // App-wide cubits come from the locator: this also runs from above the providers.
    final notifications = sl<NotificationsCubit>();
    switch (state) {
      case SessionAuthenticated():
        notifications.load();
        sl<ConfigCubit>().load(force: true);
      case SessionUnauthenticated(:final expired):
        notifications.reset();
        if (expired) AppSnack.show(context, LocaleKeys.errors_session_expired.tr());
      case SessionUnknown() || SessionUnverified():
        break;
    }
  }
}
