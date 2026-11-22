import 'package:flutter/material.dart';

import '../network/api_failure.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/failure_message.dart';

/// Inline error under a form or above an action.
class FailureBanner extends StatelessWidget {
  const FailureBanner({super.key, this.failure, this.message});

  final ApiFailure? failure;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message ?? (failure == null ? '' : failureMessage(failure!));
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppStyles.body.copyWith(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}
