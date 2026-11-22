import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/login_cubit.dart';
import '../../cubits/login_state.dart';
import '../password_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().submit(identifier: _identifier.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginCubit>().state;
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _identifier,
              validator: Validators.identifier,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email, AutofillHints.telephoneNumber],
              decoration: InputDecoration(
                labelText: LocaleKeys.auth_identifier.tr(),
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            PasswordField(
              controller: _password,
              label: LocaleKeys.auth_password.tr(),
              validator: Validators.required,
              onSubmitted: (_) => _submit(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: Text(LocaleKeys.auth_forgot_password.tr()),
              ),
            ),
            if (state case LoginFailed(:final failure)) ...[
              FailureBanner(failure: failure),
              const SizedBox(height: 16),
            ],
            LoadingButton(
              label: LocaleKeys.auth_login_button.tr(),
              isLoading: state is LoginSubmitting || state is LoginSucceeded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
