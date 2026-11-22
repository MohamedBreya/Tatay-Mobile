import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_error_code.dart';
import '../../../../../core/network/api_failure.dart';
import '../../../../../core/utils/failure_message.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/verify_email_cubit.dart';
import '../../cubits/verify_email_state.dart';
import '../otp_code_field.dart';
import '../resend_code_button.dart';

class VerifyEmailForm extends StatefulWidget {
  const VerifyEmailForm({super.key});

  @override
  State<VerifyEmailForm> createState() => _VerifyEmailFormState();
}

class _VerifyEmailFormState extends State<VerifyEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<VerifyEmailCubit>().submit(_code.text);
  }

  /// Code problems show under the field; anything else as a banner.
  static const _codeErrors = {ApiErrorCode.otpInvalid, ApiErrorCode.otpExpired, ApiErrorCode.otpTooMany};

  @override
  Widget build(BuildContext context) {
    final state = context.watch<VerifyEmailCubit>().state;
    final failure = state is VerifyEmailFailed ? state.failure : null;
    final isCodeError = failure is ServerFailure && _codeErrors.contains(failure.code);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpCodeField(
            controller: _code,
            errorText: isCodeError ? failureMessage(failure) : null,
            onCompleted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          if (failure != null && !isCodeError) ...[FailureBanner(failure: failure), const SizedBox(height: 16)],
          LoadingButton(
            label: LocaleKeys.auth_verify_button.tr(),
            isLoading: state is VerifyEmailSubmitting || state is VerifyEmailSucceeded,
            onPressed: _submit,
          ),
          const SizedBox(height: 8),
          const Center(child: ResendCodeButton()),
        ],
      ),
    );
  }
}
