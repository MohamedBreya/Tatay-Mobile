import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/state/action_status.dart';
import '../../../../core/utils/app_snack.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/change_password_cubit.dart';
import '../widgets/password/change_password_form.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(sl()),
      child: BlocListener<ChangePasswordCubit, ActionStatus>(
        listener: (context, status) {
          if (status is! ActionSucceeded) return;
          AppSnack.show(context, LocaleKeys.account_password_changed.tr());
          context.pop();
        },
        child: Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.account_change_password.tr())),
          body: const SingleChildScrollView(padding: EdgeInsets.all(24), child: ChangePasswordForm()),
        ),
      ),
    );
  }
}
