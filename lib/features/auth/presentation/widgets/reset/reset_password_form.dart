import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_failure.dart';
import '../../../../../core/state/action_status.dart';
import '../../../../../core/utils/failure_message.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/reset_password_cubit.dart';
import '../otp_code_field.dart';
import '../password_field.dart';
import '../resend_code_button.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_code, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ResetPasswordCubit>().submit(code: _code.text, newPassword: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<ResetPasswordCubit>().state;
    final failure = status is ActionFailed ? status.failure : null;
    final fieldError = failure is ServerFailure ? failure.fieldError('new_password') : null;
    final codeError = failure is ServerFailure && fieldError == null ? failureMessage(failure) : null;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpCodeField(controller: _code, errorText: codeError),
          const SizedBox(height: 16),
          PasswordField(
            controller: _password,
            label: LocaleKeys.auth_new_password.tr(),
            validator: Validators.password,
            errorText: fieldError,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _confirm,
            label: LocaleKeys.auth_confirm_password.tr(),
            validator: Validators.matches(() => _password.text),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          if (failure != null && failure is! ServerFailure) ...[
            FailureBanner(failure: failure),
            const SizedBox(height: 16),
          ],
          LoadingButton(
            label: LocaleKeys.auth_reset_button.tr(),
            isLoading: status is ActionInProgress,
            onPressed: _submit,
          ),
          const SizedBox(height: 8),
          const Center(child: ResendCodeButton()),
        ],
      ),
    );
  }
}
