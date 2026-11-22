import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// A full-width button that shows a spinner and ignores taps while [isLoading].
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final action = isLoading ? null : onPressed;
    final child = isLoading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: outlined ? AppColors.primary : AppColors.onPrimary,
            ),
          )
        : Text(label);
    final iconWidget = icon == null || isLoading ? null : Icon(icon);
    if (outlined) {
      return iconWidget == null
          ? OutlinedButton(onPressed: action, child: child)
          : OutlinedButton.icon(onPressed: action, icon: iconWidget, label: child);
    }
    return iconWidget == null
        ? FilledButton(onPressed: action, child: child)
        : FilledButton.icon(onPressed: action, icon: iconWidget, label: child);
  }
}
