import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/forgot_password_cubit.dart';
import '../../cubits/forgot_password_state.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ForgotPasswordCubit>().submit(_email.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForgotPasswordCubit>().state;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _email,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: LocaleKeys.auth_email.tr(),
              prefixIcon: const Icon(Icons.alternate_email_rounded),
            ),
          ),
          const SizedBox(height: 20),
          if (state case ForgotPasswordFailed(:final failure)) ...[
            FailureBanner(failure: failure),
            const SizedBox(height: 16),
          ],
          LoadingButton(
            label: LocaleKeys.auth_send_code.tr(),
            isLoading: state is ForgotPasswordSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
