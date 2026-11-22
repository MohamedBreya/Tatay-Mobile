import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/state/action_status.dart';
import '../../../../core/utils/app_snack.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/auth_requests.dart';
import '../cubits/reset_password_cubit.dart';
import '../cubits/resend_timer_cubit.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/reset/reset_password_form.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.cooldown});

  final String email;
  final int cooldown;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ResetPasswordCubit(sl(), email: email)),
        BlocProvider(
          create: (_) =>
              ResendTimerCubit(sl(), email: email, purpose: OtpPurpose.resetPassword)..startCountdown(cooldown),
        ),
      ],
      child: BlocListener<ResetPasswordCubit, ActionStatus>(
        listener: (context, status) {
          if (status is! ActionSucceeded) return;
          AppSnack.show(context, LocaleKeys.auth_reset_done.tr());
          context.go(AppRoutes.login);
        },
        child: AuthScaffold(
          showBack: true,
          title: LocaleKeys.auth_reset_title.tr(),
          subtitle: LocaleKeys.auth_reset_subtitle.tr(args: [email]),
          child: const ResetPasswordForm(),
        ),
      ),
    );
  }
}
