import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Shown while the saved session is restored.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.airport_shuttle_rounded, size: 72, color: AppColors.onPrimary),
            const SizedBox(height: 12),
            Text(LocaleKeys.app_name.tr(), style: AppStyles.displayLarge),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.onPrimary),
          ],
        ),
      ),
    );
  }
}
