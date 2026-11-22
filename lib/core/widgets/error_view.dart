import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../network/api_failure.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/failure_message.dart';

/// Full-area error with a retry button and, for unexpected errors, the request id.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.failure, this.onRetry});

  final ApiFailure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final requestId = failureRequestId(failure);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              failure is NetworkFailure ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(failureMessage(failure), style: AppStyles.body, textAlign: TextAlign.center),
            if (requestId != null) ...[
              const SizedBox(height: 8),
              Text(LocaleKeys.common_request_id.tr(args: [requestId]), style: AppStyles.caption),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(LocaleKeys.common_retry.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
