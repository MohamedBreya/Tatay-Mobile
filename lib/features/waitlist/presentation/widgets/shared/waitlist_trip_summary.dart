import 'package:flutter/material.dart';

import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../data/models/waitlist_entry_model.dart';
import 'waitlist_status_chip.dart';

class WaitlistTripSummary extends StatelessWidget {
  const WaitlistTripSummary({super.key, required this.entry});

  final WaitlistEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppFormat.dayAndTime(entry.stop.scheduledAt), style: AppStyles.subtitle),
              Text(entry.stop.name, style: AppStyles.bodySecondary),
            ],
          ),
        ),
        WaitlistStatusChip(status: entry.status),
      ],
    );
  }
}
