import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.foreground, required this.background, this.icon});

  final String label;
  final Color foreground;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: foreground), const SizedBox(width: 4)],
          Text(label, style: AppStyles.chip.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
