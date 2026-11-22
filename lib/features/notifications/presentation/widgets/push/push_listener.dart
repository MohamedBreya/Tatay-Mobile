import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../auth/presentation/cubits/session_cubit.dart';
import '../../../../auth/presentation/cubits/session_state.dart';
import '../../../data/models/opened_push_model.dart';
import '../../../data/repositories/push_repository.dart';
import '../../cubits/notifications_cubit.dart';
import 'notification_target_router.dart';

/// Sets up push once, and opens the right screen when a notification is tapped.
/// A tap that launched the app waits until the session is restored.
class PushListener extends StatefulWidget {
  const PushListener({super.key, required this.router, required this.child});

  final GoRouter router;
  final Widget child;

  @override
  State<PushListener> createState() => _PushListenerState();
}

class _PushListenerState extends State<PushListener> {
  final PushRepository _push = sl();
  StreamSubscription<OpenedPushModel>? _openedSub;
  OpenedPushModel? _pending;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_openedSub != null) return;
    _openedSub = _push.onOpened.listen(_handle);
    unawaited(_init());
  }

  Future<void> _init() async {
    try {
      await _push.initialize(
        channelName: LocaleKeys.notifications_channel_name.tr(),
        channelDescription: LocaleKeys.notifications_channel_description.tr(),
      );
      final initial = await _push.initialMessage();
      if (initial != null) _handle(initial);
    } catch (e) {
      debugPrint('Push setup failed: $e');
    }
  }

  void _handle(OpenedPushModel opened) {
    if (context.read<SessionCubit>().state is! SessionAuthenticated) {
      _pending = opened;
      return;
    }
    final id = opened.notificationId;
    if (id != null) unawaited(context.read<NotificationsCubit>().markRead(id));
    NotificationTargetRouter.open(widget.router, opened.target);
  }

  @override
  void dispose() {
    _openedSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        final pending = _pending;
        if (state is SessionAuthenticated && pending != null) {
          _pending = null;
          // Let the redirect to the home tab finish first.
          WidgetsBinding.instance.addPostFrameCallback((_) => _handle(pending));
        }
      },
      child: widget.child,
    );
  }
}
