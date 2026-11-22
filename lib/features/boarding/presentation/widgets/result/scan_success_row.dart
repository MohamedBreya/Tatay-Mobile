import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';

class ScanSuccessRow extends StatelessWidget {
  const ScanSuccessRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: AppStyles.successBody.copyWith(color: AppColors.textOnDark.withValues(alpha: 0.85))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, style: AppStyles.successBody, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
