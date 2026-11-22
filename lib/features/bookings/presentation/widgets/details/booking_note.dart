import 'package:flutter/material.dart';

import '../../../../../core/utils/app_styles.dart';

/// A colored note card used by the status sections.
class BookingNote extends StatelessWidget {
  const BookingNote({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    required this.lines,
    this.action,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final List<String> lines;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [for (final line in lines) Text(line, style: AppStyles.body)],
                  ),
                ),
              ],
            ),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}
