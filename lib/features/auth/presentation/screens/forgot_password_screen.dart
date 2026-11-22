import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/forgot_password_cubit.dart';
import '../cubits/forgot_password_state.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/forgot/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(sl()),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state case ForgotPasswordSent(:final email, :final resendInSeconds)) {
            context.pushReplacement(AppRoutes.resetPasswordFor(email, cooldown: resendInSeconds));
          }
        },
        child: AuthScaffold(
          showBack: true,
          title: LocaleKeys.auth_forgot_title.tr(),
          subtitle: LocaleKeys.auth_forgot_subtitle.tr(),
          child: const ForgotPasswordForm(),
        ),
      ),
    );
  }
}
