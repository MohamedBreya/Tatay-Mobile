import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_format.dart';
import '../utils/app_styles.dart';

/// Big mm:ss countdown (payment hold, waitlist offer). Turns red in the last [urgentBelow] seconds.
class CountdownCard extends StatelessWidget {
  const CountdownCard({super.key, required this.label, required this.secondsLeft, this.urgentBelow = 120});

  final String label;
  final int secondsLeft;
  final int urgentBelow;

  @override
  Widget build(BuildContext context) {
    final urgent = secondsLeft <= urgentBelow;
    return Card(
      color: urgent ? AppColors.dangerLight : AppColors.warningLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(label, style: AppStyles.bodySecondary, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              AppFormat.countdown(secondsLeft),
              textDirection: TextDirection.ltr,
              style: AppStyles.countdown.copyWith(color: urgent ? AppColors.danger : AppColors.warning),
            ),
          ],
        ),
      ),
    );
  }
}
