import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_snack.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/resend_timer_cubit.dart';
import '../cubits/resend_timer_state.dart';

/// "Send the code again", disabled while the server cooldown runs.
class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResendTimerCubit, ResendTimerState>(
      listener: (context, state) {
        if (state case ResendReady(:final failure?)) {
          AppSnack.failure(context, failure);
        }
      },
      builder: (context, state) => switch (state) {
        ResendCountingDown(:final secondsLeft) => TextButton(
          onPressed: null,
          child: Text(LocaleKeys.auth_resend_in.tr(args: ['$secondsLeft'])),
        ),
        ResendSending() => const TextButton(
          onPressed: null,
          child: SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        ResendReady() => TextButton(
          onPressed: () async {
            final sent = await context.read<ResendTimerCubit>().resend();
            if (sent && context.mounted) {
              AppSnack.show(context, LocaleKeys.auth_code_resent.tr());
            }
          },
          child: Text(LocaleKeys.auth_resend.tr()),
        ),
      },
    );
  }
}
