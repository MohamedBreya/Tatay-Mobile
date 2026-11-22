import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[Text(title!, style: AppStyles.subtitle), const SizedBox(height: 12)],
            child,
          ],
        ),
      ),
    );
  }
}
