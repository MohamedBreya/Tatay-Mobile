import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/login_cubit.dart';
import '../cubits/login_state.dart';
import '../cubits/session_cubit.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(sl()),
      child: BlocListener<LoginCubit, LoginState>(
        // The router takes it from here: verified users go to trips, others to the OTP screen.
        listener: (context, state) {
          if (state case LoginSucceeded(:final user)) {
            context.read<SessionCubit>().signedIn(user);
          }
        },
        child: AuthScaffold(
          title: LocaleKeys.auth_login_title.tr(),
          subtitle: LocaleKeys.auth_login_subtitle.tr(),
          footer: AuthFooterLink(
            question: LocaleKeys.auth_no_account.tr(),
            action: LocaleKeys.auth_create_account.tr(),
            onTap: () => context.push(AppRoutes.register),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
