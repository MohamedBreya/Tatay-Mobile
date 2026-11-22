import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class ResultMessage extends StatelessWidget {
  const ResultMessage({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, size: 52, color: color),
        ),
        const SizedBox(height: 20),
        Text(title, style: AppStyles.headline, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(body, style: AppStyles.bodySecondary, textAlign: TextAlign.center),
        const SizedBox(height: 28),
      ],
    );
  }
}
