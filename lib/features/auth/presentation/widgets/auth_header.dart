import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
          child: const Icon(Icons.airport_shuttle_rounded, size: 38, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(title, style: AppStyles.headline, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(subtitle, style: AppStyles.bodySecondary, textAlign: TextAlign.center),
        const SizedBox(height: 28),
      ],
    );
  }
}
