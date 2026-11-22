import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_failure.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/register_cubit.dart';
import '../../cubits/register_state.dart';
import '../password_field.dart';
import 'register_error_section.dart';
import 'register_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().submit(
      name: _name.text,
      phone: _phone.text,
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterCubit>().state;
    final failure = state is RegisterFailed ? state.failure : null;
    String? serverError(String field) => failure is ServerFailure ? failure.fieldError(field) : null;

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegisterTextField(
              controller: _name,
              label: LocaleKeys.auth_name.tr(),
              icon: Icons.badge_outlined,
              validator: Validators.name,
              errorText: serverError('name'),
              autofillHints: const [AutofillHints.name],
            ),
            RegisterTextField(
              controller: _phone,
              label: LocaleKeys.auth_phone.tr(),
              icon: Icons.phone_android_rounded,
              validator: Validators.phone,
              errorText: serverError('phone'),
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
            ),
            RegisterTextField(
              controller: _email,
              label: LocaleKeys.auth_email.tr(),
              icon: Icons.alternate_email_rounded,
              validator: Validators.email,
              errorText: serverError('email'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            PasswordField(
              controller: _password,
              label: LocaleKeys.auth_password.tr(),
              validator: Validators.password,
              errorText: serverError('password'),
              autofillHints: const [AutofillHints.newPassword],
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            if (failure != null) RegisterErrorSection(failure: failure),
            LoadingButton(
              label: LocaleKeys.auth_register_button.tr(),
              isLoading: state is RegisterSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
