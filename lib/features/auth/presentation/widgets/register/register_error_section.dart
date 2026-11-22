import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/network/api_error_code.dart';
import '../../../../../core/network/api_failure.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../generated/locale_keys.g.dart';

/// The registration error, plus a "forgot password" shortcut when the phone or email
/// already belongs to an account.
class RegisterErrorSection extends StatelessWidget {
  const RegisterErrorSection({super.key, required this.failure});

  final ApiFailure failure;

  bool get _isDuplicate =>
      failure is ServerFailure &&
      {ApiErrorCode.duplicateEmail, ApiErrorCode.duplicatePhone}.contains((failure as ServerFailure).code);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FailureBanner(failure: failure),
          if (_isDuplicate)
            TextButton(
              onPressed: () => context.push(AppRoutes.forgotPassword),
              child: Text(LocaleKeys.auth_duplicate_hint.tr()),
            ),
        ],
      ),
    );
  }
}
