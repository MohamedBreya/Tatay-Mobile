import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/auth_requests.dart';
import '../cubits/resend_timer_cubit.dart';
import '../cubits/session_cubit.dart';
import '../cubits/verify_email_cubit.dart';
import '../cubits/verify_email_state.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/otp/verify_email_form.dart';

/// Reached after registering ([cooldown] > 0, a code was just sent) or after logging in
/// with an unverified email ([cooldown] = 0, so a fresh code is requested on open).
class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.email, required this.cooldown});

  final String email;
  final int cooldown;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VerifyEmailCubit(sl(), email: email)),
        BlocProvider(
          create: (_) {
            final timer = ResendTimerCubit(sl(), email: email, purpose: OtpPurpose.verifyEmail);
            cooldown > 0 ? timer.startCountdown(cooldown) : timer.resend();
            return timer;
          },
        ),
      ],
      child: BlocListener<VerifyEmailCubit, VerifyEmailState>(
        listener: (context, state) {
          if (state case VerifyEmailSucceeded(:final user)) {
            context.read<SessionCubit>().signedIn(user);
          }
        },
        child: AuthScaffold(
          title: LocaleKeys.auth_otp_title.tr(),
          subtitle: LocaleKeys.auth_otp_subtitle.tr(args: [email]),
          footer: TextButton(
            onPressed: () => context.read<SessionCubit>().logout(),
            child: Text(LocaleKeys.auth_other_account.tr()),
          ),
          child: const VerifyEmailForm(),
        ),
      ),
    );
  }
}
