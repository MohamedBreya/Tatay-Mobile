import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_error_code.dart';
import '../../../../../core/network/api_failure.dart';
import '../../../../../core/state/action_status.dart';
import '../../../../../core/utils/failure_message.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../auth/presentation/widgets/password_field.dart';
import '../../cubits/change_password_cubit.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_current, _new, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ChangePasswordCubit>().submit(currentPassword: _current.text, newPassword: _new.text);
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<ChangePasswordCubit>().state;
    final failure = status is ActionFailed ? status.failure : null;
    final wrongCurrent = failure is ServerFailure && failure.code == ApiErrorCode.invalidCredentials;
    final newError = failure is ServerFailure ? failure.fieldError('new_password') : null;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PasswordField(
            controller: _current,
            label: LocaleKeys.account_current_password.tr(),
            validator: Validators.required,
            errorText: wrongCurrent ? failureMessage(failure) : null,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _new,
            label: LocaleKeys.auth_new_password.tr(),
            validator: Validators.password,
            errorText: newError,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _confirm,
            label: LocaleKeys.auth_confirm_password.tr(),
            validator: Validators.matches(() => _new.text),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          if (failure != null && !wrongCurrent && newError == null) ...[
            FailureBanner(failure: failure),
            const SizedBox(height: 16),
          ],
          LoadingButton(label: LocaleKeys.account_save.tr(), isLoading: status is ActionInProgress, onPressed: _submit),
        ],
      ),
    );
  }
}
