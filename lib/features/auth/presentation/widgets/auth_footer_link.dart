import 'package:flutter/material.dart';

import '../../../../core/utils/app_styles.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({super.key, required this.question, required this.action, required this.onTap});

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Wrap, not Row: long translations or a large font scale must not overflow.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(question, style: AppStyles.bodySecondary),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
