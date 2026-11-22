import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/register_cubit.dart';
import '../cubits/register_state.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(sl()),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state case RegisterSucceeded(:final email, :final resendInSeconds)) {
            context.pushReplacement(AppRoutes.verifyEmailFor(email, cooldown: resendInSeconds));
          }
        },
        child: AuthScaffold(
          showBack: true,
          title: LocaleKeys.auth_register_title.tr(),
          subtitle: LocaleKeys.auth_register_subtitle.tr(),
          footer: AuthFooterLink(
            question: LocaleKeys.auth_have_account.tr(),
            action: LocaleKeys.auth_login_link.tr(),
            onTap: () => context.pop(),
          ),
          child: const RegisterForm(),
        ),
      ),
    );
  }
}
