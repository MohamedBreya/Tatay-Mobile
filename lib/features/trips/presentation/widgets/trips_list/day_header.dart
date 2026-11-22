import 'package:flutter/material.dart';

import '../../../../../core/utils/app_styles.dart';

class DayHeader extends StatelessWidget {
  const DayHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 8),
      child: Text(label, style: AppStyles.subtitle),
    );
  }
}
