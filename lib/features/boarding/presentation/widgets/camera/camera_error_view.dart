import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';

/// No camera permission (or no camera).
class CameraErrorView extends StatelessWidget {
  const CameraErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined, size: 56, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(LocaleKeys.boarding_camera_denied.tr(), style: AppStyles.body, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
