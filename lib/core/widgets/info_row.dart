import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(label, style: AppStyles.bodySecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, style: AppStyles.subtitle, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
