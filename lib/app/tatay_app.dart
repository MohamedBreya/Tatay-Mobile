import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/router/app_router.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/app_theme.dart';
import '../features/auth/presentation/cubits/session_cubit.dart';
import '../features/auth/presentation/cubits/session_state.dart';
import '../features/config/presentation/cubits/config_cubit.dart';
import '../features/notifications/presentation/cubits/notifications_cubit.dart';
import '../features/notifications/presentation/widgets/push/push_listener.dart';
import '../generated/locale_keys.g.dart';
import 'session_effects.dart';

class TatayApp extends StatefulWidget {
  const TatayApp({super.key});

  @override
  State<TatayApp> createState() => _TatayAppState();
}

class _TatayAppState extends State<TatayApp> {
  final SessionCubit _session = sl();
  late final GoRouter _router = AppRouter.create(_session);

  @override
  void initState() {
    super.initState();
    // The session may already be restored before the listener below subscribes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) SessionEffects.onChange(context, _session.state);
    });
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dates and numbers follow the app language (the device language, ar or en).
    Intl.defaultLocale = context.locale.languageCode;
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: _session),
        BlocProvider<ConfigCubit>.value(value: sl<ConfigCubit>()),
        BlocProvider<NotificationsCubit>.value(value: sl<NotificationsCubit>()),
      ],
      child: BlocListener<SessionCubit, SessionState>(
        listener: SessionEffects.onChange,
        child: MaterialApp.router(
          onGenerateTitle: (_) => LocaleKeys.app_name.tr(),
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: AppSnack.messengerKey,
          theme: AppTheme.light(),
          routerConfig: _router,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) => PushListener(router: _router, child: child!),
        ),
      ),
    );
  }
}
