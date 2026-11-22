import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../generated/locale_keys.g.dart';

/// Six-digit code input, used by email verification and password reset.
class OtpCodeField extends StatelessWidget {
  const OtpCodeField({super.key, required this.controller, this.errorText, this.onCompleted, this.enabled = true});

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: Validators.otp,
      forceErrorText: errorText,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLength: 6,
      autofillHints: const [AutofillHints.oneTimeCode],
      style: AppStyles.accountNumber,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        if (value.length == 6) onCompleted?.call(value);
      },
      decoration: InputDecoration(labelText: LocaleKeys.auth_otp_code.tr(), counterText: ''),
    );
  }
}
