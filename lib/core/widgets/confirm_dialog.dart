import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../utils/app_styles.dart';

/// Yes/no dialog. Returns true when confirmed.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.message, this.confirmLabel});

  final String message;
  final String? confirmLabel;

  static Future<bool> show(BuildContext context, {required String message, String? confirmLabel}) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => ConfirmDialog(message: message, confirmLabel: confirmLabel),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message, style: AppStyles.body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(LocaleKeys.common_cancel.tr())),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel ?? LocaleKeys.common_confirm.tr()),
        ),
      ],
    );
  }
}
